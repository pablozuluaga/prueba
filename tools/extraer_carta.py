#!/usr/bin/env python3
"""
Extrae la carta de Crepes & Waffles desde el PDF original a assets/carta.json.

Paginas 1-6: traen capa de texto -> se parsean por coordenadas y fuentes.
Paginas 7-8: son imagen pura (sin capa de texto) -> se transcribieron a mano
             leyendo la pagina renderizada y viven en
             tools/carta_paginas_imagen.json, que este script fusiona al final.

Layout observado en el PDF (familia NittiGrotesk, pagina de 1080 pt de ancho):
  size >= 60  Bold/SemiLight            -> titulo de seccion
  size ~35/30 Medium, x0 <= 130         -> nombre de plato (o variante con precio propio)
  size ~26    Medium, x0 en 158 / 580   -> opcion de la barra de ensaladas (sin precio)
  size ~35    SemiLight                 -> descripcion del plato
  size ~39    Bold empezando por $      -> precio, alineado a la derecha (x1 ~ 985)
El precio de un plato se imprime 2-4 pt ARRIBA del nombre, por eso el emparejamiento
se hace en una segunda pasada por cercania vertical y no por orden de lectura.
"""
import json, re, sys, unicodedata
from pathlib import Path

import pymupdf

PDF = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(
    "/root/.claude/uploads/2b9b9bf9-b2fa-5d74-a74e-9833030c568f/70bd657b-afmenupagwebinterior1.pdf")
RAIZ = Path(__file__).resolve().parent.parent
SALIDA = RAIZ / "assets" / "carta.json"
IMAGEN_JSON = RAIZ / "tools" / "carta_paginas_imagen.json"

PRECIO = re.compile(r"^\$\s?[\d.,]+$")
X_ITEM_MAX = 130          # margen izquierdo de los platos
TOLERANCIA_Y = 15         # distancia vertical maxima entre precio y nombre
RUIDO = (
    "Productos sujetos a disponibilidad", "Información sobre alérgenos",
    "equipo de servicio", "contienen trigo", "de los ingredientes",
    "Imagen de carácter ilustrativo", "Sujeto a disponibilidad",
    "Se prohíbe el expendio",
)


def slug(s):
    s = "".join(c for c in unicodedata.normalize("NFD", s) if unicodedata.category(c) != "Mn")
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def leer_lineas(pagina):
    """Spans de la pagina, normalizados, unidos por renglon+estilo y ordenados."""
    spans = []
    for bloque in pagina.get_text("dict")["blocks"]:
        if bloque["type"] != 0:
            continue
        for linea in bloque["lines"]:
            for s in linea["spans"]:
                texto = s["text"].replace("ﬂ", "fl").replace("ﬁ", "fi")
                if not texto.strip() or any(texto.strip().startswith(r) for r in RUIDO):
                    continue
                x0, y0, x1, _ = s["bbox"]
                spans.append({"texto": texto, "x0": x0, "x1": x1, "y": y0,
                              "fuente": s["font"], "tam": round(s["size"], 1)})
    spans.sort(key=lambda s: (round(s["y"]), s["x0"]))

    lineas = []
    for s in spans:
        if lineas:
            ant = lineas[-1]
            if (abs(ant["y"] - s["y"]) <= 4 and ant["fuente"] == s["fuente"]
                    and ant["tam"] == s["tam"] and 0 <= s["x0"] - ant["x1"] <= 12):
                ant["texto"] += s["texto"]
                ant["x1"] = s["x1"]
                continue
        lineas.append(dict(s, texto=s["texto"]))
    for l in lineas:
        l["texto"] = l["texto"].strip()
    return [l for l in lineas if l["texto"]]


def clasificar(l):
    f, t, x0, txt = l["fuente"], l["tam"], l["x0"], l["texto"]
    if PRECIO.match(txt):
        return "precio"
    if t >= 60:
        return "seccion"
    if t >= 45:
        return "descarte"          # rotulo suelto duplicado ("Cervezas" sobre VINOS)
    if t <= 22:
        return "descarte"          # letra menuda / marcadores de nota al pie
    es_titulo = ("Medium" in f or "Bold" in f) and "Italic" not in f and "Itali" not in f
    if es_titulo and t >= 29 and x0 <= X_ITEM_MAX:
        return "plato"
    if es_titulo and t < 29:
        return "opcion"            # ingrediente de la barra de ensaladas
    if es_titulo and x0 > X_ITEM_MAX:
        return "opcion"
    return "descripcion"


def fusionar_titulos(lineas):
    """'MINI' + 'WAFFLES' o 'OTRAS' + 'BEBIDAS' llegan como dos spans del mismo renglon."""
    out = []
    for l in lineas:
        if (out and l["tipo"] == "seccion" == out[-1]["tipo"] and abs(out[-1]["y"] - l["y"]) <= 8):
            a, b = sorted((out[-1], l), key=lambda s: s["x0"])
            out[-1]["texto"] = f"{a['texto'].strip()} {b['texto'].strip()}"
            out[-1]["x0"] = a["x0"]
            continue
        out.append(l)
    return out


def parsear_pagina(pagina, numero):
    lineas = leer_lineas(pagina)
    for l in lineas:
        l["tipo"] = clasificar(l)
    lineas = fusionar_titulos([l for l in lineas if l["tipo"] != "descarte"])

    secciones, actual, ultimo_plato, grupo = [], None, None, None
    for l in lineas:
        tipo, txt = l["tipo"], l["texto"]
        if tipo == "seccion":
            actual = {"seccion": txt, "pagina": numero, "items": [], "opciones": [], "_precios": []}
            secciones.append(actual)
            ultimo_plato = grupo = None
        elif actual is None:
            continue                                  # rotulos sobre las fotos de portada
        elif tipo == "plato":
            if txt.lower().startswith("elige tus"):    # abre un grupo de opciones
                grupo = {"grupo": txt, "valores": []}
                actual["opciones"].append(grupo)
                ultimo_plato = None
                continue
            ultimo_plato = {"nombre": txt, "descripcion": "", "precio": None, "y": l["y"]}
            actual["items"].append(ultimo_plato)
        elif tipo == "opcion" and grupo is not None:
            grupo["valores"].append(txt)
        elif tipo == "descripcion":
            if grupo is not None and l["x0"] > X_ITEM_MAX and grupo["valores"]:
                grupo["valores"][-1] += " " + txt      # "Ceviche" + "de chontaduro"
            elif txt.startswith("( Máximo") and grupo is not None:
                grupo["limite"] = txt.strip("( )")
            elif ultimo_plato is not None:
                ultimo_plato["descripcion"] = (ultimo_plato["descripcion"] + " " + txt).strip()
            else:
                actual.setdefault("nota", "")
                actual["nota"] = (actual["nota"] + " " + txt).strip()
        elif tipo == "precio":
            actual["_precios"].append({"valor": txt.replace("$ ", "$"), "y": l["y"]})

    # segunda pasada: el precio se imprime unos puntos ARRIBA del nombre del plato,
    # asi que solo despues de tener todos los platos se puede emparejar por cercania.
    for s in secciones:
        for pr in s.pop("_precios"):
            libres = [it for it in s["items"]
                      if it["precio"] is None and abs(it["y"] - pr["y"]) <= TOLERANCIA_Y]
            if libres:
                min(libres, key=lambda it: abs(it["y"] - pr["y"]))["precio"] = pr["valor"]
                continue
            # algunos precios se alinean con la descripcion y no con el nombre
            # (p.ej. Batido "Bienestar"): se cuelgan del ultimo plato sin precio arriba.
            arriba = [it for it in s["items"]
                      if it["precio"] is None and 0 < pr["y"] - it["y"] <= 90]
            if arriba:
                min(arriba, key=lambda it: pr["y"] - it["y"])["precio"] = pr["valor"]
            else:
                print(f"  !! precio huerfano p{numero} y={round(pr['y'])} {pr['valor']}",
                      file=sys.stderr)
    return secciones


def limpiar(secciones):
    out = []
    prefijos_nota = ("Pídelo también", "Pídelos también", "Puedes pedirlo también")
    for s in secciones:
        # lineas de invitacion sin precio propio no son platos, son nota del plato anterior
        depurados = []
        for it in s["items"]:
            if it["precio"] is None and it["nombre"].startswith(prefijos_nota):
                if depurados:
                    depurados[-1]["descripcion"] = (
                        depurados[-1]["descripcion"] + " " + it["nombre"]).strip()
                continue
            depurados.append(it)
        s["items"] = depurados
        for it in s["items"]:
            it.pop("y", None)
            it["id"] = slug(it["nombre"])
            if not it["descripcion"]:
                it.pop("descripcion")
        if not s["opciones"]:
            s.pop("opciones")
        if s["items"] or s.get("opciones"):
            out.append(s)
    return out


def main():
    doc = pymupdf.open(PDF)
    secciones = limpiar([s for i in range(6) for s in parsear_pagina(doc[i], i + 1)])
    if IMAGEN_JSON.exists():
        secciones += json.loads(IMAGEN_JSON.read_text(encoding="utf-8"))

    carta = {
        "restaurante": "Crepes & Waffles",
        "ciudad": "Medellín",
        "moneda": "COP",
        "fuente_pdf": PDF.name,
        "nota_precios": "Nombres y precios exactos, tal como aparecen en la carta PDF vigente.",
        "secciones": secciones,
        "total_items": sum(len(s["items"]) for s in secciones),
    }
    SALIDA.parent.mkdir(parents=True, exist_ok=True)
    SALIDA.write_text(json.dumps(carta, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"{SALIDA}: {len(secciones)} secciones, {carta['total_items']} items")
    for s in secciones:
        faltan = [i["nombre"] for i in s["items"] if not i.get("precio")]
        print(f"  p{s['pagina']:>2}  {s['seccion']:<26} {len(s['items']):>3} items"
              + (f"   SIN PRECIO: {faltan}" if faltan else ""))


if __name__ == "__main__":
    main()
