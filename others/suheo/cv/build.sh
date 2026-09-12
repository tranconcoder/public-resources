#!/usr/bin/env bash
# Compile CV .tex -> PDF (+ PNG preview). Usage:
#   ./build.sh            build every cv-*.tex
#   ./build.sh cv-vi.tex  build one file
#   ./build.sh -w cv-vi   rebuild on every save (needs entr, falls back to poll)
set -euo pipefail
cd "$(dirname "$0")"
OUT=build

png() {  # $1 = pdf path -- render page images so the result can be eyeballed
  local base; base=$(basename "$1" .pdf)
  if command -v pdftoppm >/dev/null; then
    pdftoppm -png -r 110 "$1" "$OUT/$base-page"
  elif command -v magick >/dev/null; then
    magick -density 110 "$1" "$OUT/$base-page-%d.png"
  else
    echo "  (no pdftoppm/magick — skipping PNG preview)" >&2; return
  fi
  ls "$OUT/$base-page"*.png 2>/dev/null | sed 's/^/  preview: /'
}

build() {
  local tex=$1 base; base=$(basename "$tex" .tex)
  echo "==> $tex"
  mkdir -p "$OUT"
  # -halt-on-error so a broken macro fails loudly instead of dropping to a prompt
  if ! xelatex -interaction=nonstopmode -halt-on-error \
       -output-directory="$OUT" "$tex" >"$OUT/$base.build.log" 2>&1; then
    echo "  FAILED — errors:" >&2
    grep -A4 -m5 '^!' "$OUT/$base.build.log" >&2 || tail -25 "$OUT/$base.build.log" >&2
    return 1
  fi
  xelatex -interaction=nonstopmode -halt-on-error \
    -output-directory="$OUT" "$tex" >>"$OUT/$base.build.log" 2>&1   # settle page refs
  local boxes; boxes=$(grep -c '^Overfull\|^Underfull' "$OUT/$base.log" 2>/dev/null || true)
  [[ ${boxes:-0} -gt 0 ]] && echo "  $boxes overfull/underfull box(es) — see $OUT/$base.log" || true
  echo "  ok: $OUT/$base.pdf ($(pdfinfo "$OUT/$base.pdf" 2>/dev/null | awk '/^Pages/{print $2}') page(s))"
  png "$OUT/$base.pdf"
}

if [[ ${1:-} == "-w" ]]; then
  shift; target=${1:-cv-vi}; target=${target%.tex}
  echo "watching $target.tex + cvchem.cls (Ctrl-C to stop)"
  if command -v entr >/dev/null; then
    printf '%s\n' "$target.tex" cvchem.cls | entr -c "$0" "$target.tex"
  else
    last=""
    while true; do
      now=$(stat -c %Y "$target.tex" cvchem.cls | tr '\n' ' ')
      [[ $now != "$last" ]] && { build "$target.tex" || true; last=$now; }
      sleep 1
    done
  fi
  exit 0
fi

if [[ $# -gt 0 ]]; then for f in "$@"; do build "$f"; done
else for f in cv-*.tex; do build "$f"; done; fi
