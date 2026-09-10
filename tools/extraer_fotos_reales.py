#!/usr/bin/env python3
"""
Cataloga las fotos REALES disponibles del restaurante en assets/reales/.

La unica fuente de foto real que tenemos hoy es la carta PDF: sus paginas traen
bodegones (varios platos por foto) con rotulos que nombran cada plato. Este script:

  1. exporta el JPEG original de cada bodegon a resolucion nativa (sin recomprimir);
  2. recorta cada plato rotulado a un archivo propio (el recorte es la imagen fuente
     para el paso image-to-image del PASO 1B);
  3. escribe assets/reales/catalogo.json cruzando cada foto con su item de carta.json.

Los rectangulos de recorte estan en puntos de pagina del PDF (pagina de 1080 pt de
ancho) y se fijaron mirando cada bodegon renderizado.
"""
import json, unicodedata
from pathlib import Path

import pymupdf

PDF = Path("/root/.claude/uploads/2b9b9bf9-b2fa-5d74-a74e-9833030c568f/70bd657b-afmenupagwebinterior1.pdf")
RAIZ = Path(__file__).resolve().parent.parent
DESTINO = RAIZ / "assets" / "reales"
DPI_RECORTE = 220
# Los bodegones vienen escalados y rotados dentro del PDF, asi que recortar el JPEG
# incrustado exigiria deshacer la transformacion. Es mas fiable renderizar la pagina,
# pero antes hay que borrar los rotulos que la carta imprime ENCIMA de las fotos:
# se redactan todos los textos y flechitas de la franja superior de cada pagina.

# bodegones completos: xref del JPEG incrustado -> nombre de archivo
BODEGONES = {
    44: ("p1-bodegon-desayunos", 1),
    46: ("p2-bodegon-entradas-y-sopas", 2),
    69: ("p3-bodegon-crepes-y-waffles-de-sal", 3),
    93: ("p4-bodegon-pitas-y-panne-cook", 4),
    100: ("p5-bodegon-ensaladas", 5),
    109: ("p6-bodegon-bebidas", 6),
}

# recortes por plato: pagina -> [(id, rotulo, seccion de carta, rect[, id exacto en la carta])]
# el ultimo campo solo se usa cuando el rotulo de la foto no basta para desambiguar
# (p.ej. la foto es la variante "con Camarón", no la ensalada base).
PLATOS = {
    1: [
        ("huevos-australianos", "Huevos Australianos", "HUEVOS", (0, 0, 800, 880)),
        ("crepe-jamon-y-queso", "Crepe Jamón y Queso", "CREPES", (600, 550, 1080, 1250)),
        ("pancakes-de-ahuyama", "Pancakes de Ahuyama", "+ OPCIONES", (0, 560, 545, 1520)),
        ("acai-bowl", "Açaí Bowl", "+ OPCIONES", (295, 1220, 1005, 2000)),
    ],
    2: [
        ("sopa-mexicana-con-pollo", "Sopa Mexicana con Pollo", "SOPAS", (0, 95, 890, 1040)),
        ("sopa-covarachia", "Sopa Covarachía", "SOPAS", (635, 955, 1080, 1670)),
        ("ensalada-de-la-barra", "Ensalada de la Barra", "ENTRADAS", (0, 1285, 580, 1820)),
    ],
    3: [
        ("salmon-roll", "Salmon Roll", "CREPES DE MAR", (215, 0, 1015, 470)),
        ("pollo-rosarito", "Pollo Rosarito", "CREPES DE POLLO", (0, 415, 480, 1000)),
        ("sombrero-vueltiao", "Sombrero Vueltiao", "CREPES DE CARNE", (460, 545, 1015, 1250)),
        ("cochinita-pibil", "Cochinita Pibil", "CREPES DE CARNE", (0, 955, 575, 1545)),
        ("mar-encocado", "Mar Encocado", "CREPES DE MAR", (415, 1325, 1015, 1920)),
    ],
    4: [
        ("panne-cook-de-camarones", "Panne Cook de Camarones en Salsa de la Casa",
         "PANNE COOK", (180, 25, 990, 660)),
        ("panne-cook-de-pollo-al-curry", "Panne Cook de Pollo al Curry",
         "PANNE COOK", (0, 640, 490, 1260)),
        ("pita-vegetariana", "Pita Vegetariana", "PITAS", (500, 675, 1080, 1320)),
        ("pita-siciliana", "Pita Siciliana", "PITAS", (260, 1325, 890, 1990)),
    ],
    5: [
        ("ensalada-marroqui-con-camarones", "Ensalada Marroquí con Camarones",
         "ENSALADAS", (0, 0, 440, 630), "con-camaron"),
        ("ensalada-torina", "Ensalada Torina", "ENSALADAS", (445, 205, 1080, 980)),
        ("ensalada-cesar-con-salmon", "Ensalada Cesar con Salmón", "ENSALADAS",
         (0, 695, 600, 1500), "con-salmon-ahumado"),
        ("ensalada-florentina", "Ensalada Florentina", "ENSALADAS", (595, 1145, 1080, 1940)),
    ],
    6: [
        ("limonada-hierbabuena", "Limonada Hierbabuena", "LIMONADAS", (30, 180, 350, 820)),
        ("jugo-de-fresa", "Jugo de Fresa", "JUGOS", (640, 175, 940, 760)),
        ("jugo-de-guanabana", "Jugo de Guanábana", "JUGOS", (390, 540, 720, 1200)),
        ("jugo-de-mandarina", "Jugo de Mandarina", "JUGOS", (110, 890, 520, 1660)),
        ("jugo-de-mango", "Jugo de Mango", "JUGOS", (600, 1010, 1050, 1890)),
    ],
}

# bandas fotograficas de las paginas 7 y 8, donde la pagina entera es una sola imagen
BANDAS = [
    (7, 0, 1430, "p7-banda-helados", "Bodegón de bolas de helado y frutas sobre fondo cacao."),
    (8, 0, 1640, "p8-banda-crepes-en-casa", "Envases de Crepes en Casa sobre mesón claro."),
    (8, 2740, 3980, "p8-banda-salsas-de-sal", "Salsas de sal en envases sobre tabla de madera."),
    (8, 4180, 5060, "p8-banda-salsas-de-dulce", "Salsas de dulce en envases sobre tabla de madera."),
]


def limpiar_rotulos(pagina, hasta_y=2100):
    """Borra del bodegon los rotulos de plato y sus flechitas antes de recortar."""
    for bloque in pagina.get_text("dict")["blocks"]:
        if bloque["type"] != 0:
            continue
        for linea in bloque["lines"]:
            for s in linea["spans"]:
                r = pymupdf.Rect(s["bbox"])
                if r.y1 < hasta_y:
                    pagina.add_redact_annot(r + (-16, -16, 16, 16), fill=False)
    pagina.apply_redactions(images=pymupdf.PDF_REDACT_IMAGE_NONE,
                            graphics=pymupdf.PDF_REDACT_LINE_ART_REMOVE_IF_TOUCHED)


def buscar_en_carta(carta, seccion, texto):
    """Devuelve el id del item de carta.json que corresponde al rotulo de la foto."""
    def norm(s):
        s = "".join(c for c in unicodedata.normalize("NFD", s) if unicodedata.category(c) != "Mn")
        return s.lower()
    objetivo = norm(texto)  # puede ser el rotulo de la foto o un id exacto de la carta
    for s in carta["secciones"]:
        if s["seccion"] != seccion:
            continue
        for it in s["items"]:
            n = norm(it["nombre"])
            if it["id"] == objetivo or n == objetivo or n in objetivo or objetivo.endswith(n):
                return f"{seccion}/{it['id']}", it.get("precio")
    return None, None


def main():
    doc = pymupdf.open(PDF)
    DESTINO.mkdir(parents=True, exist_ok=True)
    carta = json.loads((RAIZ / "assets" / "carta.json").read_text(encoding="utf-8"))

    catalogo = {
        "fuente": ("Fotografia oficial de Crepes & Waffles extraida de la carta PDF vigente. "
                   "No hay banco de fotos propio del local: estas son las unicas fotos reales "
                   "disponibles hoy."),
        "estilo_original": ("Cenital, plato blanco de borde fino, fondo liso beige/terracota, "
                            "luz difusa de estudio, sin props. Bebidas: vaso de vidrio facetado "
                            "sobre fondo hueso, luz lateral suave."),
        "bodegones": [],
        "platos": [],
        "bandas": [],
        "faltantes": [
            "Foto de la fachada del local (necesaria para el PASO 1C).",
            "Fotos de interior, barra, terraza y equipo (necesarias para varios heroes del PASO 1D).",
        ],
    }

    vistos = set()
    for pno in range(6):
        for xref, *_ in doc[pno].get_images(full=True):
            if xref in vistos or xref not in BODEGONES:
                continue
            vistos.add(xref)
            nombre, pagina = BODEGONES[xref]
            info = doc.extract_image(xref)
            archivo = DESTINO / f"{nombre}.{info['ext']}"
            archivo.write_bytes(info["image"])
            catalogo["bodegones"].append({
                "archivo": f"assets/reales/{archivo.name}",
                "pagina_pdf": pagina,
                "ancho": info["width"], "alto": info["height"],
                "platos": [p[0] for p in PLATOS[pagina]],
            })

    for pagina, platos in PLATOS.items():
        hoja = doc[pagina - 1]
        limpiar_rotulos(hoja)
        for pid, rotulo, seccion, rect, *forzado in platos:
            pix = hoja.get_pixmap(clip=pymupdf.Rect(*rect), dpi=DPI_RECORTE)
            archivo = DESTINO / f"plato-{pid}.png"
            pix.save(archivo)
            ref, precio = buscar_en_carta(carta, seccion, forzado[0] if forzado else rotulo)
            catalogo["platos"].append({
                "id": pid,
                "rotulo_en_carta": rotulo,
                "archivo": f"assets/reales/{archivo.name}",
                "ancho": pix.width, "alto": pix.height,
                "pagina_pdf": pagina,
                "recorte_pt": list(rect),
                "item_carta": ref,
                "precio": precio,
            })

    for pagina, y0, y1, nombre, desc in BANDAS:
        pix = doc[pagina - 1].get_pixmap(clip=pymupdf.Rect(0, y0, 1080, y1), dpi=200)
        archivo = DESTINO / f"{nombre}.png"
        pix.save(archivo)
        catalogo["bandas"].append({
            "archivo": f"assets/reales/{archivo.name}",
            "pagina_pdf": pagina, "descripcion": desc,
            "ancho": pix.width, "alto": pix.height,
        })

    (DESTINO / "catalogo.json").write_text(
        json.dumps(catalogo, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"{len(catalogo['bodegones'])} bodegones, {len(catalogo['platos'])} platos recortados, "
          f"{len(catalogo['bandas'])} bandas")
    for p in catalogo["platos"]:
        estado = p["item_carta"] or "!! sin cruce con carta.json"
        print(f"  {p['id']:<32} {p['ancho']}x{p['alto']:<5} {estado} {p['precio'] or ''}")


if __name__ == "__main__":
    main()
