"""Genera backend/supabase/seed.sql a partir de assets/carta.json.

Carga la carta completa (categorías, productos, variantes, sellos y fotos reales)
en la base de datos. Se puede volver a correr: borra la carta y la vuelve a crear.
Los pedidos no se tocan (conservan su copia de nombre y precio).

Uso: python3 tools/generar_seed.py
"""

import json
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
CARTA = RAIZ / "assets" / "carta.json"
CATALOGO = RAIZ / "assets" / "reales" / "catalogo.json"
SALIDA = RAIZ / "backend" / "supabase" / "seed.sql"


def pesos(texto):
    """'$14.900' -> 14900"""
    return int(texto.replace("$", "").replace(".", "").strip())


def sql(valor):
    if valor is None:
        return "null"
    if isinstance(valor, bool):
        return "true" if valor else "false"
    if isinstance(valor, int):
        return str(valor)
    if isinstance(valor, list):
        return "array[" + ", ".join(sql(v) for v in valor) + "]::text[]"
    return "'" + str(valor).replace("'", "''") + "'"


def slugificar(texto):
    import unicodedata
    base = unicodedata.normalize("NFKD", texto).encode("ascii", "ignore").decode()
    return "-".join("".join(c if c.isalnum() else " " for c in base.lower()).split())


def agrupar_variantes(items):
    """En la carta impresa, un ítem sin precio es un encabezado cuyo precio está en
    las líneas siguientes sin descripción ("Cesar" -> "Con Pollo" / "Con Salmón
    Ahumado"). Esas líneas se vuelven variantes del encabezado. Un encabezado sin
    líneas así (p. ej. "Nuestros Clásicos Parfaits") es solo un subtítulo y se omite.

    Devuelve [(item, [hijos])]."""
    salida = []
    k = 0
    while k < len(items):
        item = items[k]
        k += 1
        if item.get("precio"):
            salida.append((item, []))
            continue
        hijos = []
        while k < len(items) and items[k].get("precio") and not items[k].get("descripcion"):
            hijos.append(items[k])
            k += 1
        if hijos:
            salida.append((item, hijos))
    return salida


def main():
    carta = json.loads(CARTA.read_text(encoding="utf-8"))
    catalogo = json.loads(CATALOGO.read_text(encoding="utf-8"))

    # "SECCION/id" -> archivo de foto real. La primera sección con ese nombre gana.
    fotos = {p["item_carta"]: p["archivo"].removeprefix("assets/") for p in catalogo["platos"]}

    lineas = [
        "-- Generado por tools/generar_seed.py a partir de assets/carta.json. No editar a mano.",
        "",
        "begin;",
        "",
        "delete from public.productos;",
        "delete from public.categorias;",
        "",
        f"update public.config set nombre = {sql(carta['restaurante'])} where id = 1;",
        "",
    ]

    slugs_usados = set()
    secciones_vistas = set()
    total = 0
    omitidas = []

    for orden_cat, seccion in enumerate(carta["secciones"]):
        nombre_sec = seccion["seccion"]
        primera_vez = nombre_sec not in secciones_vistas
        secciones_vistas.add(nombre_sec)
        grupos = agrupar_variantes(seccion["items"])
        if not grupos:
            # Secciones que solo listan opciones (sabores de helado, salsas):
            # no se piden solas. Quedan para cuando haya modificadores.
            omitidas.append(nombre_sec)
            continue

        lineas.append(
            "with c as (insert into public.categorias (nombre, nota, orden) values "
            f"({sql(nombre_sec)}, {sql(seccion.get('nota'))}, {orden_cat}) returning id)"
        )
        filas = []
        for orden_prod, (item, hijos) in enumerate(grupos):
            slug = f"{slugificar(nombre_sec)}--{item['id']}"
            n = 2
            while slug in slugs_usados:
                slug = f"{slugificar(nombre_sec)}--{item['id']}-{n}"
                n += 1
            slugs_usados.add(slug)

            if hijos:
                variantes = [{"nombre": h["nombre"], "precio": pesos(h["precio"])} for h in hijos]
            else:
                variantes = [
                    {"nombre": nombre, "precio": pesos(precio)}
                    for nombre, precio in item.get("precios", {}).items()
                ]
            precio = min(v["precio"] for v in variantes) if variantes else pesos(item["precio"])

            etiquetas = []
            for fuente in [item, *hijos]:
                for e in fuente.get("dieta", []) + fuente.get("alergenos", []) + fuente.get("notas", []):
                    if e not in etiquetas:
                        etiquetas.append(e)

            foto = None
            if primera_vez:
                for fuente in [item, *hijos]:
                    foto = foto or fotos.get(f"{nombre_sec}/{fuente['id']}")

            filas.append(
                "("
                + ", ".join([
                    "(select id from c)",
                    sql(slug),
                    sql(item["nombre"]),
                    sql(item.get("descripcion")),
                    sql(precio),
                    sql(json.dumps(variantes, ensure_ascii=False)) + "::jsonb",
                    sql(etiquetas),
                    sql(foto),
                    sql(orden_prod),
                ])
                + ")"
            )
            total += 1

        lineas.append(
            "insert into public.productos "
            "(categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values\n  "
            + ",\n  ".join(filas)
            + ";"
        )
        lineas.append("")

    lineas.append("commit;")
    SALIDA.write_text("\n".join(lineas) + "\n", encoding="utf-8")
    print(f"{SALIDA.relative_to(RAIZ)}: {len(carta['secciones']) - len(omitidas)} categorías, {total} productos")
    if omitidas:
        print("Secciones sin productos pedibles (omitidas):", ", ".join(omitidas))


if __name__ == "__main__":
    main()
