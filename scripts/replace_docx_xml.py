#!/usr/bin/env python3
import sys, json, zipfile, tempfile, shutil, os

def usage():
    print(f"Usage: {sys.argv[0]} <input.docx> <replacements.json> <output.docx>", file=sys.stderr)
    sys.exit(1)

def replace_in_xml(data: bytes, replacements: dict) -> bytes:
    text = data.decode('utf-8')
    for old, new in replacements.items():
        text = text.replace(old, new)
    return text.encode('utf-8')

def main():
    if len(sys.argv) != 4:
        usage()
    in_docx, repl_json, out_docx = sys.argv[1], sys.argv[2], sys.argv[3]

    # Load replacements mapping
    try:
        with open(repl_json, 'r', encoding='utf-8') as f:
            replacements = json.load(f)
    except Exception as e:
        print(f"Error loading JSON '{repl_json}': {e}", file=sys.stderr)
        sys.exit(2)

    # Work in a temp dir to unpack/repack
    tmpdir = tempfile.mkdtemp()
    try:
        # 1) unzip into tmpdir
        with zipfile.ZipFile(in_docx, 'r') as zin:
            zin.extractall(tmpdir)

        # 2) apply replacements in document.xml (and optionally headers/footers)
        targets = [
            'word/document.xml',
            # Falls du Überschriften/Fußzeilen hast, kannst du diese ebenfalls ersetzen:
            # 'word/header1.xml', 'word/header2.xml', 
            # 'word/footer1.xml', 'word/footer2.xml',
        ]
        for relpath in targets:
            full = os.path.join(tmpdir, relpath)
            if os.path.exists(full):
                data = open(full, 'rb').read()
                new_data = replace_in_xml(data, replacements)
                with open(full, 'wb') as f:
                    f.write(new_data)

        # 3) rezip zu out_docx
        with zipfile.ZipFile(out_docx, 'w', zipfile.ZIP_DEFLATED) as zout:
            for root, _, files in os.walk(tmpdir):
                for name in files:
                    path = os.path.join(root, name)
                    arcname = os.path.relpath(path, tmpdir)
                    zout.write(path, arcname)

    finally:
        shutil.rmtree(tmpdir)

if __name__ == "__main__":
    main()
