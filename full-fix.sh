#!/bin/bash
# =========================================================
#  full-fix.sh
#  Fix lengkap: bersihkan, validasi, generate, fix kode
#  Untuk project CuciMesin (Vue 3 + Vite)
# =========================================================

set -e

# Warna output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  FULL FIX — CuciMesin Images${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Pastikan di root project
if [ ! -f "package.json" ]; then
  echo -e "${RED}Error: package.json tidak ditemukan!${NC}"
  echo "Jalankan di root project Vue."
  exit 1
fi

# =========================================================
# 1. BERSIHKAN FILE SAMPAH
# =========================================================
echo -e "${YELLOW}[1/7] Bersihkan file sampah...${NC}"

REMOVED=0

# File sampah di hero (h.webp, k.webp, o.webp, p.webp, ..webp, dll)
for f in "public/images/hero/..webp" \
         "public/images/hero/h.webp" \
         "public/images/hero/k.webp" \
         "public/images/hero/o.webp" \
         "public/images/hero/p.webp"; do
  if [ -f "$f" ]; then
    rm -f "$f"
    echo "  - Dihapus: $f"
    REMOVED=$((REMOVED + 1))
  fi
done

# File lain yang namanya cuma 1 huruf di folder images (kemungkinan sampah)
find public/images -type f -regextype posix-extended \
  -regex '.*\/[a-z]\.webp' 2>/dev/null | while read -r f; do
  base=$(basename "$f")
  case "$base" in
    h.webp|k.webp|o.webp|p.webp)
      # sudah dihapus di atas
      ;;
    *)
      echo "  - Dihapus (sampah): $f"
      rm -f "$f"
      ;;
  esac
done

if [ "$REMOVED" -eq 0 ]; then
  echo "  (tidak ada file sampah)"
fi
echo ""

# =========================================================
# 2. INSTALL TOOL YANG DIBUTUHKAN
# =========================================================
echo -e "${YELLOW}[2/7] Cek tool convert (webp + imagemagick)...${NC}"

if ! command -v cwebp &>/dev/null || ! command -v convert &>/dev/null; then
  echo "  Tool belum ada, install dulu..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq webp imagemagick
  echo "  ✅ Tool terinstall"
else
  echo "  ✅ Tool sudah ada"
fi
echo ""

# =========================================================
# 3. VALIDASI FILE WEBP
# =========================================================
echo -e "${YELLOW}[3/7] Validasi file WebP...${NC}"

declare -A EXPECTED=(
  # Hero (800x800)
  ["public/images/hero/main.webp"]="800x800"
  ["public/images/hero/layanan.webp"]="800x800"
  ["public/images/hero/booking.webp"]="800x800"
  ["public/images/hero/status.webp"]="800x800"
  ["public/images/hero/login.webp"]="800x800"
  # Cards (200x200)
  ["public/images/cards/choice.webp"]="200x200"
  ["public/images/cards/booking.webp"]="200x200"
  ["public/images/cards/guide.webp"]="200x200"
  # Packages (800x600)
  ["public/images/packages/grand.webp"]="800x600"
  ["public/images/packages/balloon.webp"]="800x600"
  ["public/images/packages/exclusive.webp"]="800x600"
  # Articles (1000x700)
  ["public/images/articles/travel.webp"]="1000x700"
  ["public/images/articles/discount.webp"]="1000x700"
)

MISSING=()
INVALID=()

for path in "${!EXPECTED[@]}"; do
  if [ ! -f "$path" ]; then
    MISSING+=("$path")
    echo -e "  ${RED}✗ MISSING${NC}  $path"
  else
    size=$(stat -c%s "$path")
    fmt=$(file -b "$path")
    if [ "$size" -lt 500 ]; then
      INVALID+=("$path")
      echo -e "  ${RED}✗ KECIL${NC}    $path ($size byte)"
    elif echo "$fmt" | grep -q "Web/P"; then
      echo -e "  ${GREEN}✓ OK${NC}       $path ($((size / 1024)) KB)"
    else
      INVALID+=("$path")
      echo -e "  ${RED}✗ FORMAT${NC}   $path ($fmt)"
    fi
  fi
done

echo ""

# =========================================================
# 4. GENERATE WEBP DUMMY (untuk yang missing / invalid)
# =========================================================
TO_GENERATE=("${MISSING[@]}" "${INVALID[@]}")

if [ "${#TO_GENERATE[@]}" -gt 0 ]; then
  echo -e "${YELLOW}[4/7] Generate WebP dummy untuk yang bermasalah...${NC}"

  for path in "${TO_GENERATE[@]}"; do
    dir=$(dirname "$path")
    mkdir -p "$dir"

    # Pilih ukuran & warna berdasarkan folder
    case "$path" in
      *hero*)
        convert -size 800x800 gradient:'#4F5BFF'-'#FF8A3D' \
          -gravity center -pointsize 60 -fill white \
          -annotate +0+0 "CuciMesin" \
          "$path"
        ;;
      *cards*)
        name=$(basename "$path" .webp)
        convert -size 200x200 xc:'#4F5BFF' \
          -gravity center -pointsize 18 -fill white \
          -annotate +0+0 "$name" \
          "$path"
        ;;
      *packages/grand*)
        convert -size 800x600 gradient:'#4F5BFF'-'#6B7BFF' \
          -gravity center -pointsize 48 -fill white \
          -annotate +0-30 "Paket Showroom" \
          -pointsize 24 -annotate +0+40 "Rp 450.000" \
          "$path"
        ;;
      *packages/balloon*)
        convert -size 800x600 gradient:'#FF8A3D'-'#FF6B1A' \
          -gravity center -pointsize 48 -fill white \
          -annotate +0-30 "Ultimate Detail" \
          -pointsize 24 -annotate +0+40 "Rp 850.000" \
          "$path"
        ;;
      *packages/exclusive*)
        convert -size 800x600 xc:'#F5EFE4' \
          -gravity center -pointsize 40 -fill '#4F5BFF' \
          -annotate +0+0 "Exclusive" \
          "$path"
        ;;
      *articles/travel*)
        convert -size 1000x700 gradient:'#FFD4B3'-'#FFE9D6' \
          -gravity center -pointsize 44 -fill '#12163A' \
          -annotate +0+0 "5 Tanda Mesin Perlu Dicuci" \
          "$path"
        ;;
      *articles/discount*)
        convert -size 1000x700 gradient:'#D4CCFF'-'#E8E4FF' \
          -gravity center -pointsize 44 -fill '#12163A' \
          -annotate +0+0 "Diskon 50%" \
          "$path"
        ;;
      *)
        convert -size 800x800 xc:'#4F5BFF' \
          -gravity center -pointsize 40 -fill white \
          -annotate +0+0 "CuciMesin" \
          "$path"
        ;;
    esac

    size=$(stat -c%s "$path")
    echo -e "  ${GREEN}+ Generated${NC} $path ($((size / 1024)) KB)"
  done
else
  echo -e "${YELLOW}[4/7] Semua file OK, tidak perlu generate${NC}"
fi
echo ""

# =========================================================
# 5. FIX images.js (hapus cache buster)
# =========================================================
echo -e "${YELLOW}[5/7] Fix src/data/images.js...${NC}"

mkdir -p src/data

cat > src/data/images.js << 'EOF'
// =========================================================
//  Konfigurasi Gambar CuciMesin
//  Tanpa cache buster — biar Vite langsung serve file
// =========================================================

export const IMAGES = {
  hero: {
    main:    '/images/hero/main.webp',
    layanan: '/images/hero/layanan.webp',
    booking: '/images/hero/booking.webp',
    status:  '/images/hero/status.webp',
    login:   '/images/hero/login.webp'
  },
  cards: {
    choice:  '/images/cards/choice.webp',
    booking: '/images/cards/booking.webp',
    guide:   '/images/cards/guide.webp'
  },
  packages: {
    grand:     '/images/packages/grand.webp',
    balloon:   '/images/packages/balloon.webp',
    exclusive: '/images/packages/exclusive.webp'
  },
  articles: {
    travel:   '/images/articles/travel.webp',
    discount: '/images/articles/discount.webp'
  }
}
EOF

echo "  ✅ images.js updated"
echo ""

# =========================================================
# 6. FIX HomeView.vue (matikan @error handler)
# =========================================================
echo -e "${YELLOW}[6/7] Fix @error handler di views...${NC}"

# Ganti hideOnError biar tidak sembunyikan gambar
# Cari di semua .vue di src/views
find src/views -type f -name "*.vue" | while read -r file; do
  if grep -q "hideOnError" "$file"; then
    # Ganti isi fungsi hideOnError
    perl -i -0pe '
      s/function hideOnError\(e\)\s*\{[^}]*\}/function hideOnError(e) {
  console.warn("[Image failed]", e.target.src);
  e.target.style.opacity = "0.3";
  e.target.style.background = "rgba(255, 138, 61, 0.1)";
}/gs
    ' "$file"
    echo "  ✅ Fixed: $file"
  fi
done
echo ""

# =========================================================
# 7. RESTART DEV SERVER INFO
# =========================================================
echo -e "${YELLOW}[7/7] Selesai — langkah selanjutnya:${NC}"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SELESAI${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Cek hasil akhir
echo -e "${BLUE}Struktur folder images:${NC}"
find public/images -type f -name "*.webp" -exec ls -lh {} \; | awk '{print "  " $9 " (" $5 ")"}' | sort
echo ""

# Summary
TOTAL=$(find public/images -type f -name "*.webp" | wc -l)
echo -e "${BLUE}Total file WebP: ${GREEN}$TOTAL${NC}"
echo ""

echo -e "${YELLOW}Langkah selanjutnya:${NC}"
echo ""
echo "  1. Stop dev server (Ctrl+C kalau masih jalan)"
echo "  2. Jalankan ulang:"
echo ""
echo -e "     ${GREEN}npm run dev${NC}"
echo ""
echo "  3. Buka browser:"
echo ""
echo -e "     ${GREEN}http://localhost:5173/beranda${NC}"
echo ""
echo "  4. Hard refresh: Ctrl+Shift+R"
echo ""
echo -e "${YELLOW}Kalau masih tidak tampil, cek manual:${NC}"
echo ""
echo "     http://localhost:5173/images/hero/main.webp"
echo ""
echo "  Harus muncul gambar 'CuciMesin' gradient biru-orange."
echo ""
echo -e "${YELLOW}Kalau di browser muncul tapi di halaman tidak:${NC}"
echo ""
echo "  Buka F12 → Network → filter Img → refresh"
echo "  Screenshot hasilnya, kirim ke saya."
echo ""