#!/usr/bin/env bash
# Convert LaTeX resume/CV to PDF, PNG image(s), and Word (.docx).
#
# Supports two versions:
#   - English:    outputs/cv-fullstack.tex (and outputs/cv-fullstack-en.tex)
#   - Vietnamese: outputs/cv-fullstack-vi.tex
#
# Usage:
#   ./convert.sh [en|vi|all|<file.tex>] [pdf|png|docx|all]
#
# Examples:
#   ./convert.sh                                   # builds both EN and VI (all formats)
#   ./convert.sh all                               # builds both EN and VI (all formats)
#   ./convert.sh en                                # builds English version (all formats)
#   ./convert.sh vi                                # builds Vietnamese version (all formats)
#   ./convert.sh en pdf                            # builds only English PDF
#   ./convert.sh vi png                            # builds only Vietnamese PNG page image
#   ./convert.sh vi docx                           # builds only Vietnamese Word (.docx)
#   ./convert.sh outputs/cv-fullstack-vi.tex docx  # converts a specific file
#
# Requires: pdflatex/xelatex (texlive), pdftoppm (poppler-utils), pandoc.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-all}"
MODE="${2:-all}"

get_engine() {
  local file="$1"
  if grep -q "fontspec" "$file" || grep -q "xelatex" "$file"; then
    echo "xelatex"
  else
    echo "pdflatex"
  fi
}

compile_file() {
  local tex_file="$1"
  local mode="$2"

  if [[ ! -f "$tex_file" ]]; then
    echo "Error: file not found: $tex_file" >&2
    exit 1
  fi

  local dir
  dir="$(cd "$(dirname "$tex_file")" && pwd)"
  local base
  base="$(basename "$tex_file" .tex)"
  local pdf_file="$dir/$base.pdf"
  local engine
  engine="$(get_engine "$tex_file")"

  to_pdf() {
    echo ":: Compiling $tex_file -> PDF (using $engine)"
    ( cd "$dir" && "$engine" -interaction=nonstopmode "$base.tex" >/dev/null
      "$engine" -interaction=nonstopmode "$base.tex" >/dev/null )
    echo "   -> $pdf_file"
  }

  to_png() {
    [[ -f "$pdf_file" ]] || to_pdf
    echo ":: Rendering PDF -> PNG"
    pdftoppm -png -r 150 "$pdf_file" "$dir/$base"
    for f in "$dir/$base"-*.png; do echo "   -> $f"; done
  }

  to_docx() {
    [[ -f "$pdf_file" ]] || to_pdf
    echo ":: Converting LaTeX -> Word (.docx) via pandoc"
    sed -e 's/\\hrule height [0-9.]*pt/\\hrule/' \
        -e 's/\\textls\[[0-9]*\]//g' \
        -e 's/\\color{[a-zA-Z]*}//g' "$tex_file" | \
      pandoc -f latex -t docx -o "$dir/$base.docx"
    echo "   -> $dir/$base.docx"
  }

  case "$mode" in
    pdf)  to_pdf ;;
    png)  to_png ;;
    docx) to_docx ;;
    all)  to_pdf; to_png; to_docx ;;
    *) echo "Unknown mode: $mode (use pdf|png|docx|all)" >&2; exit 1 ;;
  esac

  # Clean LaTeX aux files
  rm -f "$dir/$base".{aux,log,out}
}

sync_en_outputs() {
  local dir="$SCRIPT_DIR/outputs"
  # Keep cv-fullstack.* and cv-fullstack-en.* in sync for convenience
  for ext in pdf docx; do
    if [[ -f "$dir/cv-fullstack.$ext" ]]; then
      cp -f "$dir/cv-fullstack.$ext" "$dir/cv-fullstack-en.$ext"
    fi
  done
  for png in "$dir"/cv-fullstack-[0-9]*.png; do
    if [[ -f "$png" ]]; then
      local b
      b="$(basename "$png")"
      local num="${b#cv-fullstack-}"
      cp -f "$png" "$dir/cv-fullstack-en-$num"
    fi
  done
}

case "$TARGET" in
  en)
    echo "=========================================="
    echo " Building English CV"
    echo "=========================================="
    compile_file "$SCRIPT_DIR/outputs/cv-fullstack.tex" "$MODE"
    cp -f "$SCRIPT_DIR/outputs/cv-fullstack.tex" "$SCRIPT_DIR/outputs/cv-fullstack-en.tex"
    sync_en_outputs
    ;;
  vi)
    echo "=========================================="
    echo " Building Vietnamese CV"
    echo "=========================================="
    compile_file "$SCRIPT_DIR/outputs/cv-fullstack-vi.tex" "$MODE"
    ;;
  all)
    echo "=========================================="
    echo " Building All CV Versions (EN & VI)"
    echo "=========================================="
    compile_file "$SCRIPT_DIR/outputs/cv-fullstack.tex" "$MODE"
    cp -f "$SCRIPT_DIR/outputs/cv-fullstack.tex" "$SCRIPT_DIR/outputs/cv-fullstack-en.tex"
    sync_en_outputs
    echo ""
    compile_file "$SCRIPT_DIR/outputs/cv-fullstack-vi.tex" "$MODE"
    ;;
  *)
    if [[ -f "$TARGET" ]]; then
      compile_file "$TARGET" "$MODE"
    elif [[ -f "$SCRIPT_DIR/$TARGET" ]]; then
      compile_file "$SCRIPT_DIR/$TARGET" "$MODE"
    else
      echo "Unknown target: $TARGET" >&2
      echo "Usage: $0 [en|vi|all|<file.tex>] [pdf|png|docx|all]" >&2
      exit 1
    fi
    ;;
esac

echo ":: Build completed successfully."
