#!/usr/bin/env bash
# Build the interactive mind maps: one Markmap page per mind map plus an index.
# `make site` runs this into _site/mind-maps/ after the MkDocs build.
#
# Usage: mind_maps/build_site.sh [output_dir]
set -euo pipefail

MARKMAP_VERSION="0.18.12"
SRC_DIR="$(cd "$(dirname "$0")/markdown" && pwd)"
OUT_DIR="${1:-_site}"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# Copy only the images the Markdown actually embeds (the full set is ~58 MB).
mkdir -p "$OUT_DIR/images"
grep -rhoE '\.\./images/[^") ]+' "$SRC_DIR" | sort -u | while read -r ref; do
  cp "$SRC_DIR/$ref" "$OUT_DIR/images/"
done

items=""
for md in "$SRC_DIR"/*.md; do
  name="$(basename "$md" .md)"
  [ "$name" = "README" ] && continue

  # Images are referenced as ../images/ (valid on GitHub and MkDocs); the Markmap page
  # sits next to a copy of them, so point the render at images/ instead.
  render_src="$(mktemp -t "${name}.XXXXXX.md")"
  sed 's|\.\./images/|images/|g' "$md" > "$render_src"
  npx --yes "markmap-cli@${MARKMAP_VERSION}" "$render_src" \
    --offline --no-open -o "$OUT_DIR/${name}.html"
  rm -f "$render_src"

  # Markmap draws images at natural size; cap them so a screenshot does not dwarf the map.
  sed -i.bak 's|</head>|<style>.markmap-foreign img{max-width:600px;height:auto}</style></head>|' "$OUT_DIR/${name}.html"
  rm -f "$OUT_DIR/${name}.html.bak"

  # Title comes from the front matter "title:" line, falling back to the file name.
  title="$(sed -n 's/^title: *"\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$md" | head -n 1)"
  title="${title//&/&amp;}"

  # markmap-cli titles every page "Markmap"; use the topic name for the browser tab.
  sed_title="$(printf '%s' "${title:-$name}" | sed 's/[&|\\]/\\&/g')"
  sed -i.bak "s|<title>Markmap</title>|<title>${sed_title} - AWS Mind Maps</title>|" "$OUT_DIR/${name}.html"
  rm -f "$OUT_DIR/${name}.html.bak"
  items+="      <li><a href=\"${name}.html\">${title:-$name}</a></li>"$'\n'
done

cat > "$OUT_DIR/index.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AWS Learning Mind Maps</title>
  <style>
    :root { color-scheme: light dark; }
    body { font-family: system-ui, sans-serif; max-width: 720px; margin: 0 auto; padding: 32px 16px; line-height: 1.5; }
    h1 { margin-bottom: 4px; }
    p { color: GrayText; margin-top: 0; }
    ol { padding-left: 24px; }
    li { margin: 6px 0; }
    a { text-decoration: none; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <h1>AWS Learning Mind Maps</h1>
  <p>Interactive mind maps for the AWS Solutions Architect Associate course. Click a node to expand or collapse it; scroll to zoom.</p>
  <ol>
${items}  </ol>
  <p><a href="../">← AWS Learning home</a> · <a href="https://github.com/nshoa/aws-learning/tree/main/mind_maps">Source on GitHub</a></p>
</body>
</html>
EOF

# Serve files as-is (no Jekyll processing).
touch "$OUT_DIR/.nojekyll"

echo "Built $(find "$OUT_DIR" -name '*.html' | wc -l | tr -d ' ') pages in $OUT_DIR"
