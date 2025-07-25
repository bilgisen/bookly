#!/bin/bash

set -e

JSON_FILE=${1:-payload.json}

# JSON'dan değerleri oku
HTML_URL=$(jq -r '.html_url' "$JSON_FILE")
OUTPUT_FILE=$(jq -r '.output_filename' "$JSON_FILE")
TITLE=$(jq -r '.title' "$JSON_FILE")
CREATOR=$(jq -r '.creator' "$JSON_FILE")
PUBLISHER=$(jq -r '.publisher' "$JSON_FILE")
LANG=$(jq -r '.lang' "$JSON_FILE")
IDENTIFIER=$(jq -r '.identifier' "$JSON_FILE")
COVER_IMAGE=$(jq -r '.cover_image' "$JSON_FILE")
CSS=$(jq -r '.css' "$JSON_FILE")
TOC=$(jq -r '.toc' "$JSON_FILE")
TOC_DEPTH=$(jq -r '.toc_depth' "$JSON_FILE")

# HTML dosyasını indir
curl -s "$HTML_URL" -o book.html

# Pandoc komutu
PANDOC_CMD=(pandoc book.html -o "$OUTPUT_FILE" --from=html --to=epub)

[[ "$TOC" == "true" ]] && PANDOC_CMD+=("--toc" "--toc-depth=$TOC_DEPTH")
[[ -n "$CSS" && "$CSS" != "null" ]] && PANDOC_CMD+=("--css=$CSS")
[[ -n "$TITLE" && "$TITLE" != "null" ]] && PANDOC_CMD+=("--metadata=title=$TITLE")
[[ -n "$CREATOR" && "$CREATOR" != "null" ]] && PANDOC_CMD+=("--metadata=creator=$CREATOR")
[[ -n "$PUBLISHER" && "$PUBLISHER" != "null" ]] && PANDOC_CMD+=("--metadata=publisher=$PUBLISHER")
[[ -n "$LANG" && "$LANG" != "null" ]] && PANDOC_CMD+=("--metadata=lang=$LANG")
[[ -n "$IDENTIFIER" && "$IDENTIFIER" != "null" ]] && PANDOC_CMD+=("--metadata=identifier=$IDENTIFIER")
[[ -n "$COVER_IMAGE" && "$COVER_IMAGE" != "null" ]] && PANDOC_CMD+=("--epub-cover-image=$COVER_IMAGE")

# Komutu çalıştır
echo "📦 Pandoc komutu çalıştırılıyor..."
"${PANDOC_CMD[@]}"
echo "✅ EPUB oluşturuldu: $OUTPUT_FILE"
