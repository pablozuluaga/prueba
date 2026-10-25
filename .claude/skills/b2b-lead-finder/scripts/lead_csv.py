#!/usr/bin/env python3
"""Deterministic helpers for b2b-lead-finder: CSV writing, dedupe keys, checkpoints.

Import the functions or use the CLI. Keeping these in one script means every run
gets identical column order, Excel-safe quoting, UTF-8 BOM, and dedupe logic —
instead of re-implementing them from prose each time.

CLI:
  python3 lead_csv.py append <leads.csv> <rows.json>     # rows.json = JSON array of objects
  python3 lead_csv.py key "<organization name>" "<website-or-empty>"
  python3 lead_csv.py state-get <state.json> <key>
  python3 lead_csv.py state-set <state.json> <key> <json-value>
"""
import csv, json, os, re, sys
from urllib.parse import urlparse

COLUMNS = [
    "organization_name", "category", "website", "google_maps_link",
    "facebook_page", "instagram_page", "linkedin_page", "phone", "whatsapp",
    "email", "physical_address", "area", "online_service_mentioned",
    "exact_source_quote", "source_url", "why_good_fit", "priority", "confidence", "notes",
]

_LEGAL_SUFFIXES = re.compile(
    r"\b(ltd|limited|inc|incorporated|llc|llp|plc|pvt|private|co|company|corp|corporation)\b\.?",
    re.IGNORECASE,
)


def normalize_name(name: str) -> str:
    """Dedupe key from an organization name: lowercase, no punctuation, no legal suffixes."""
    if not name:
        return ""
    s = _LEGAL_SUFFIXES.sub(" ", name.lower())
    s = re.sub(r"[^a-z0-9ঀ-৿؀-ۿ一-鿿]+", " ", s)
    return re.sub(r"\s+", " ", s).strip()


def domain_key(website: str) -> str:
    """Dedupe key from a website URL: bare registrable host, no www."""
    if not website or not website.startswith("http"):
        return ""
    host = urlparse(website).netloc.lower()
    return host[4:] if host.startswith("www.") else host


def dedupe_key(name: str, website: str = "") -> str:
    """Prefer domain (spelling-proof); fall back to normalized name."""
    return domain_key(website) or normalize_name(name)


def append_leads(csv_path: str, rows: list) -> int:
    """Append rows (list of dicts) to csv_path. Creates the file with a UTF-8-BOM
    header if missing. Every field quoted; missing keys become ""; unknown keys
    beyond COLUMNS are appended in stable sorted order on first write only."""
    new_file = not os.path.exists(csv_path)
    extras = sorted({k for r in rows for k in r} - set(COLUMNS))
    cols = COLUMNS + extras
    if not new_file:
        with open(csv_path, newline="", encoding="utf-8-sig") as f:
            cols = next(csv.reader(f))
    with open(csv_path, "a", newline="", encoding="utf-8-sig" if new_file else "utf-8") as f:
        w = csv.DictWriter(f, fieldnames=cols, quoting=csv.QUOTE_ALL, extrasaction="ignore")
        if new_file:
            w.writeheader()
        for r in rows:
            w.writerow({c: ("" if r.get(c) is None else str(r.get(c, ""))) for c in cols})
    return len(rows)


def load_state(path: str) -> dict:
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    return {"round": 0, "seen_keys": [], "confirmed": [], "rejected": []}


def save_state(path: str, state: dict) -> None:
    tmp = path + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(state, f, ensure_ascii=False, indent=1)
    os.replace(tmp, path)


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "append":
        with open(sys.argv[3], encoding="utf-8") as f:
            n = append_leads(sys.argv[2], json.load(f))
        print(f"appended {n} rows to {sys.argv[2]}")
    elif cmd == "key":
        print(dedupe_key(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else ""))
    elif cmd == "state-get":
        print(json.dumps(load_state(sys.argv[2]).get(sys.argv[3])))
    elif cmd == "state-set":
        s = load_state(sys.argv[2]); s[sys.argv[3]] = json.loads(sys.argv[4]); save_state(sys.argv[2], s)
        print("ok")
    else:
        sys.exit(__doc__)
