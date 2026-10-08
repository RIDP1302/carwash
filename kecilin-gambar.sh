#!/bin/bash
# kecilin-gambar.sh
# Kecilin ukuran semua gambar di public/images
# TIDAK menghapus file asli — hanya menambah versi .webp

set -e

echo "🔍 Scan file gambar..."
echo ""

# Folder & ukuran target
declare -A TARGETS=(
  ["hero"]="800x800"
  ["cards"]="200x200"
  ["packages"]="800x600"
  ["articles"]="1000x700"
)

total_before=0
total_after=0

for folder in "${!TARGETS[@]}"; do
  dir="public/images/$folder"
  [ -d "$dir" ] || continue

  size="${TARGETS[$folder]}"

  echo "📁 $folder (target: $size)"

  # Cari semua file JPG/PNG/JPEG
  for f in "$dir"/*.{jpg,jpeg,png}; do
    [ -f "$f" ] || continue

    # Skip kalau sudah WebP
    case "$f" in
      *.webp) continue ;;
    esac

    name=$(basename "$f")
    base="${name%.*}"
    output="$dir/$base.webp"

    size_before=$(stat -c%s "$f")
    total_before=$((total_before + size_before))

    # Convert + resize + compress
    convert "$f" \
      -resize "$size^" \
      -gravity center \
      -extent "$size" \
      -quality 80 \
      -define webp:method=6 \
      "$output"

    size_after=$(stat -c%s "$output")
    total_after=$((total_after + size_after))

    # Hitung persentase
    saved=$((size_before - size_after))
    pct=$((saved * 100 / size_before))

    printf "  %-25s %6s KB → %6s KB  (-%d%%)\n" \
      "$name" \
      "$((size_before / 1024))" \
      "$((size_after / 1024))" \
      "$pct"
  done
  echo ""
done

echo "==========================================="
echo "Total sebelum : $((total_before / 1024)) KB"
echo "Total sesudah : $((total_after / 1024)) KB"
if [ "$total_before" -gt 0 ]; then
  echo "Hemat         : $(( (total_before - total_after) / 1024 )) KB"
fi
echo "==========================================="
echo ""
echo "✅ File .webp sudah dibuat."
echo "   File asli (.jpg/.png) TIDAK dihapus."
echo ""