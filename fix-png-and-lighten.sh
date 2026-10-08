#!/bin/bash
# =========================================================
#  fix-png-and-lighten.sh
#  1. Fix PNG tidak tampil (cache + no-cache header)
#  2. Fix perlu refresh (reveal langsung aktif)
#  3. Kurangi animasi berat (GPU-friendly)
# =========================================================

set -e

echo "🔧 Fix PNG + ringankan animasi..."
echo ""

if [ ! -f "package.json" ]; then
  echo "❌ Error: package.json tidak ditemukan!"
  exit 1
fi

# =========================================================
# 1. CEK FILE PNG YANG ADA
# =========================================================
echo "🔍 Cek file PNG di public/images/..."
echo ""

if [ -d "public/images" ]; then
  find public/images -type f -name "*.png" | sort
else
  echo "⚠️  Folder public/images/ belum ada"
fi
echo ""

# =========================================================
# 2. FIX VITE CONFIG — matikan cache asset
# =========================================================
echo "📝 Update vite.config.js (disable cache)..."

cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    open: true,
    // Matikan cache untuk file di public/ biar PNG baru langsung muncul
    headers: {
      'Cache-Control': 'no-store, no-cache, must-revalidate'
    }
  },
  // Pastikan asset public tidak di-hash
  publicDir: 'public',
  build: {
    assetsInlineLimit: 0
  }
})
EOF

echo "   ✅ vite.config.js updated."
echo ""

# =========================================================
# 3. FIX IMAGES.JS — tambahkan cache buster
# =========================================================
echo "📝 Update src/data/images.js (cache buster)..."

mkdir -p src/data

cat > src/data/images.js << 'EOF'
// =========================================================
//  Konfigurasi Gambar CuciMesin
//  File fisik: public/images/...
//  Cache buster v=1 supaya browser tidak pakai versi lama
// =========================================================

const V = '1' // naikkan angka ini kalau ganti gambar dengan nama sama

export const IMAGES = {
  hero: {
    main:    `/images/hero/main.png?v=${V}`,
    layanan: `/images/hero/layanan.png?v=${V}`,
    booking: `/images/hero/booking.png?v=${V}`,
    status:  `/images/hero/status.png?v=${V}`,
    login:   `/images/hero/login.png?v=${V}`
  },
  cards: {
    choice:  `/images/cards/choice.png?v=${V}`,
    booking: `/images/cards/booking.png?v=${V}`,
    guide:   `/images/cards/guide.png?v=${V}`
  },
  packages: {
    grand:     `/images/packages/grand.png?v=${V}`,
    balloon:   `/images/packages/balloon.png?v=${V}`,
    exclusive: `/images/packages/exclusive.png?v=${V}`
  },
  articles: {
    travel:   `/images/articles/travel.png?v=${V}`,
    discount: `/images/articles/discount.png?v=${V}`
  }
}
EOF

echo "   ✅ images.js updated."
echo ""

# =========================================================
# 4. FIX USE REVEAL — langsung aktif, no refresh
# =========================================================
echo "📝 Update src/composables/useReveal.js..."

mkdir -p src/composables

cat > src/composables/useReveal.js << 'EOF'
import { onMounted } from 'vue'

/**
 * Reveal ringan — langsung tampil, tidak perlu refresh.
 * Kalau browser lambat / tidak support observer → tampil semua.
 */
export function useReveal() {
  onMounted(() => {
    const els = document.querySelectorAll('.reveal')

    // Failsafe 1: tidak ada observer → langsung tampil
    if (!('IntersectionObserver' in window)) {
      els.forEach((el) => el.classList.add('active'))
      return
    }

    // Failsafe 2: kalau elemen sudah di viewport → langsung aktif
    els.forEach((el) => {
      const rect = el.getBoundingClientRect()
      if (rect.top < window.innerHeight && rect.bottom > 0) {
        el.classList.add('active')
      }
    })

    // Observer untuk yang belum kelihatan
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('active')
            observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.05, rootMargin: '0px 0px -30px 0px' }
    )

    els.forEach((el) => {
      if (!el.classList.contains('active')) observer.observe(el)
    })

    // Failsafe 3: 500ms kemudian, paksa tampil yang masih dekat viewport
    setTimeout(() => {
      document.querySelectorAll('.reveal:not(.active)').forEach((el) => {
        const rect = el.getBoundingClientRect()
        if (rect.top < window.innerHeight * 1.5) {
          el.classList.add('active')
        }
      })
    }, 500)
  })
}
EOF

echo "   ✅ useReveal.js updated."
echo ""

# =========================================================
# 5. HAPUS ANIMASI BERAT DI STYLE
# =========================================================
echo "📝 Ringankan src/assets/style.css..."

# Backup
if [ ! -f "src/assets/style.heavy.backup.css" ]; then
  cp src/assets/style.css src/assets/style.heavy.backup.css
fi

cat > src/assets/style.css << 'EOF'
/* =========================================================
   CuciMesin — Style (versi ringan, tidak berat)
   - Tanpa animasi background yang bergerak terus
   - Tanpa conic-gradient rotate
   - Reveal instan, tidak perlu refresh
   ========================================================= */

@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

/* ---------- RESET ---------- */
*, *::before, *::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* ---------- TOKENS ---------- */
:root {
  --cream:        #FBF8F3;
  --cream-2:      #F5EFE4;
  --peach:        #FFE9D6;
  --lavender:     #E8E4FF;
  --sky:          #DCEBFF;

  --primary:      #4F5BFF;
  --primary-2:    #6B7BFF;
  --primary-dark: #2E38A8;
  --accent:       #FF8A3D;
  --accent-2:     #FF6B1A;

  --navy:         #0B1030;
  --navy-3:       #1E2450;
  --ink:          #12163A;
  --text-2:       #4A5170;
  --text-3:       #8A90AA;

  --shadow-xs: 0 1px 2px rgba(18, 22, 58, 0.04);
  --shadow-sm: 0 2px 8px rgba(18, 22, 58, 0.06);
  --shadow-md: 0 8px 24px rgba(18, 22, 58, 0.08);
  --shadow-lg: 0 20px 48px rgba(18, 22, 58, 0.12);
  --shadow-xl: 0 32px 80px rgba(18, 22, 58, 0.16);

  --r-sm: 12px;
  --r-md: 20px;
  --r-lg: 28px;
  --r-xl: 40px;
  --r-pill: 999px;

  --font-sans: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
  --ease-out: cubic-bezier(0.22, 1, 0.36, 1);
}

/* ---------- BASE ---------- */
html { scroll-behavior: smooth; }

body {
  font-family: var(--font-sans);
  background: var(--cream);
  color: var(--ink);
  line-height: 1.6;
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* Background statis (tidak bergerak) — hemat GPU */
body::before {
  content: '';
  position: fixed;
  inset: 0;
  z-index: -1;
  pointer-events: none;
  background:
    radial-gradient(ellipse 70% 50% at 5% 0%, rgba(255, 212, 179, 0.55), transparent 60%),
    radial-gradient(ellipse 60% 50% at 95% 8%, rgba(212, 204, 255, 0.5), transparent 60%),
    radial-gradient(ellipse 50% 40% at 50% 100%, rgba(220, 235, 255, 0.55), transparent 60%);
  /* TIDAK ada animasi */
}

a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; border: none; background: none; }
img { max-width: 100%; display: block; }
::selection { background: var(--accent); color: white; }

h1, h2, h3, h4 {
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.1;
  color: var(--ink);
}

/* =========================================================
   NAVBAR
   ========================================================= */
.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(251, 248, 243, 0.85);
  backdrop-filter: saturate(180%) blur(16px);
  -webkit-backdrop-filter: saturate(180%) blur(16px);
  border-bottom: 1px solid rgba(18, 22, 58, 0.06);
}
.nav-container {
  max-width: 1240px;
  margin: 0 auto;
  padding: 16px 32px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}
.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  font-weight: 800;
  font-size: 1.1rem;
  color: var(--ink);
  letter-spacing: -0.02em;
}
.logo-mark {
  width: 32px;
  height: 32px;
  border-radius: 10px;
  background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  box-shadow: 0 8px 20px rgba(79, 91, 255, 0.35);
}

.nav-links {
  display: flex;
  list-style: none;
  gap: 4px;
  margin: 0 auto;
}
.nav-links a {
  padding: 8px 18px;
  border-radius: var(--r-pill);
  font-size: 0.9rem;
  font-weight: 500;
  color: var(--text-2);
  transition: color 0.2s, background 0.2s;
}
.nav-links a:hover { color: var(--ink); background: rgba(79, 91, 255, 0.06); }
.nav-links a.active {
  color: var(--primary);
  background: rgba(79, 91, 255, 0.1);
}

.nav-actions { display: flex; align-items: center; gap: 10px; }

.btn-logout {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 9px 20px;
  border-radius: var(--r-pill);
  border: 1.5px solid rgba(18, 22, 58, 0.12);
  background: rgba(255, 255, 255, 0.6);
  color: var(--ink);
  font-weight: 600;
  font-size: 0.85rem;
  transition: all 0.2s;
}
.btn-logout:hover {
  border-color: var(--primary);
  color: var(--primary);
  background: white;
}

.hamburger {
  display: none;
  align-items: center;
  justify-content: center;
  padding: 8px;
  color: var(--ink);
  border-radius: 10px;
}

/* =========================================================
   HERO
   ========================================================= */
.hero {
  position: relative;
  padding: 60px 32px 0;
  overflow: hidden;
}

.hero-inner {
  max-width: 1240px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr 1.1fr;
  gap: 48px;
  align-items: center;
  position: relative;
  z-index: 2;
}
.hero-text { padding-bottom: 60px; }

.hero-tagline {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 14px;
  border-radius: var(--r-pill);
  background: rgba(255, 255, 255, 0.7);
  border: 1px solid rgba(255, 138, 61, 0.25);
  color: var(--accent-2);
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  margin-bottom: 20px;
}
.hero-tagline::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--accent);
}

.hero-title {
  font-size: clamp(2.6rem, 6vw, 4.5rem);
  font-weight: 800;
  line-height: 0.98;
  letter-spacing: -0.04em;
  color: var(--ink);
  margin-bottom: 22px;
}
.hero-title .accent {
  background: linear-gradient(120deg, var(--primary) 0%, var(--accent) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  /* TIDAK ada animasi shift */
}

.hero-desc {
  color: var(--text-2);
  font-size: 1.02rem;
  line-height: 1.7;
  max-width: 460px;
  margin-bottom: 28px;
}

.hero-image {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: flex-end;
}
.hero-png {
  max-width: 100%;
  max-height: 500px;
  object-fit: contain;
  filter: drop-shadow(0 30px 50px rgba(79, 91, 255, 0.2));
  /* TIDAK ada float animation */
}

/* ---------- SEARCH BAR ---------- */
.search-bar {
  max-width: 760px;
  margin: -32px auto 0;
  padding: 8px;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.9);
  border-radius: var(--r-pill);
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: 8px;
  position: relative;
  z-index: 3;
  transition: box-shadow 0.2s;
}
.search-bar:focus-within {
  box-shadow: var(--shadow-xl), 0 0 0 4px rgba(79, 91, 255, 0.1);
}
.search-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-left: 22px;
  color: var(--text-3);
  flex-shrink: 0;
}
.search-bar input {
  flex: 1;
  padding: 14px 12px;
  border: none;
  outline: none;
  background: transparent;
  font-size: 0.95rem;
  color: var(--ink);
  font-family: inherit;
}
.search-bar input::placeholder { color: var(--text-3); }

.btn-search {
  padding: 12px 30px;
  border-radius: var(--r-pill);
  background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 100%);
  color: white;
  font-weight: 700;
  font-size: 0.9rem;
  transition: transform 0.2s, box-shadow 0.2s;
  box-shadow: 0 12px 28px rgba(255, 138, 61, 0.3);
}
.btn-search:hover {
  transform: translateY(-1px);
  box-shadow: 0 16px 36px rgba(255, 138, 61, 0.4);
}

/* =========================================================
   FEATURES ROW
   ========================================================= */
.features-row {
  max-width: 1240px;
  margin: 80px auto 0;
  padding: 0 32px;
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1.1fr;
  gap: 18px;
  align-items: stretch;
}
.feature-card {
  background: linear-gradient(160deg, var(--navy) 0%, var(--navy-3) 100%);
  color: white;
  border-radius: var(--r-lg);
  padding: 28px 22px;
  text-align: center;
  transition: transform 0.25s var(--ease-out), box-shadow 0.25s;
  box-shadow: var(--shadow-md);
}
.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}
.feature-card .icon {
  width: 48px;
  height: 48px;
  margin: 0 auto 16px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}
.feature-card h4 {
  font-size: 0.98rem;
  font-weight: 700;
  color: white;
  margin-bottom: 6px;
}
.feature-card p {
  font-size: 0.78rem;
  color: rgba(255, 255, 255, 0.65);
  line-height: 1.55;
}

.info-panel { padding: 12px 4px; }
.step-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: white;
  border: 1.5px solid rgba(79, 91, 255, 0.25);
  color: var(--primary);
  font-weight: 800;
  font-size: 0.85rem;
  margin-bottom: 14px;
  box-shadow: var(--shadow-sm);
}
.info-panel h3 {
  font-size: 1.05rem;
  font-weight: 800;
  color: var(--ink);
  letter-spacing: 0.02em;
  margin-bottom: 8px;
  text-transform: uppercase;
}
.info-panel p {
  font-size: 0.85rem;
  color: var(--text-2);
  margin-bottom: 16px;
  line-height: 1.6;
}

/* =========================================================
   BUTTONS
   ========================================================= */
.btn-primary,
.btn-accent,
.btn-secondary {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-weight: 700;
  font-size: 0.88rem;
  border-radius: var(--r-pill);
  transition: transform 0.2s, box-shadow 0.2s, background 0.2s;
  font-family: inherit;
}

.btn-primary {
  padding: 13px 28px;
  background: linear-gradient(135deg, var(--primary) 0%, var(--primary-2) 100%);
  color: white;
  box-shadow: 0 12px 28px rgba(79, 91, 255, 0.3);
}
.btn-primary:hover {
  transform: translateY(-1px);
  box-shadow: 0 16px 36px rgba(79, 91, 255, 0.4);
}

.btn-accent {
  padding: 11px 22px;
  background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 100%);
  color: white;
  box-shadow: 0 10px 24px rgba(255, 138, 61, 0.28);
}
.btn-accent:hover {
  transform: translateY(-1px);
  box-shadow: 0 14px 32px rgba(255, 138, 61, 0.4);
}

.btn-secondary {
  padding: 12px 24px;
  background: rgba(255, 255, 255, 0.7);
  border: 1.5px solid rgba(18, 22, 58, 0.1);
  color: var(--ink);
}
.btn-secondary:hover {
  border-color: var(--primary);
  color: var(--primary);
  background: white;
}

/* =========================================================
   SECTION
   ========================================================= */
.section {
  max-width: 1240px;
  margin: 0 auto;
  padding: 90px 32px;
  position: relative;
}
.section-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 24px;
  margin-bottom: 40px;
  flex-wrap: wrap;
}
.section-head-left { max-width: 520px; }

.section-title {
  font-size: clamp(1.8rem, 3.6vw, 2.6rem);
  font-weight: 800;
  color: var(--ink);
  letter-spacing: -0.03em;
  margin-bottom: 12px;
  line-height: 1.05;
}
.section-sub {
  color: var(--text-2);
  font-size: 0.95rem;
  line-height: 1.7;
}

/* =========================================================
   PACKAGE CARDS
   ========================================================= */
.package-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
}
.package-card {
  background: white;
  border-radius: var(--r-xl);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  border: 1px solid rgba(255, 255, 255, 0.9);
  transition: transform 0.3s var(--ease-out), box-shadow 0.3s;
  display: flex;
  flex-direction: column;
}
.package-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-xl);
}

.package-image {
  height: 280px;
  background: linear-gradient(135deg, var(--lavender) 0%, var(--peach) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}
.package-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s var(--ease-out);
}
.package-card:hover .package-image img {
  transform: scale(1.03);
}

.package-rating {
  position: absolute;
  top: 18px;
  right: 18px;
  background: rgba(255, 255, 255, 0.95);
  padding: 6px 14px;
  border-radius: var(--r-pill);
  font-size: 0.82rem;
  font-weight: 700;
  color: var(--ink);
  box-shadow: var(--shadow-sm);
  display: inline-flex;
  align-items: center;
  gap: 4px;
}
.package-rating svg { color: var(--accent); }

.package-body {
  padding: 26px 28px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}
.package-body h4 {
  font-size: 1.15rem;
  font-weight: 800;
  color: var(--ink);
  margin-bottom: 6px;
  letter-spacing: -0.01em;
}
.package-body p {
  font-size: 0.82rem;
  color: var(--text-2);
  line-height: 1.5;
}

/* =========================================================
   FEATURED BANNER
   ========================================================= */
.featured-banner {
  position: relative;
  border-radius: var(--r-xl);
  padding: 72px 56px 0;
  color: white;
  overflow: hidden;
  margin: 40px 0;
  background: linear-gradient(135deg, #4F5BFF 0%, #6B7BFF 50%, #FF8A3D 100%);
  /* TIDAK ada animasi gradient shift */
  box-shadow: var(--shadow-xl);
}
.featured-banner .step-badge {
  background: rgba(255, 255, 255, 0.18);
  border-color: rgba(255, 255, 255, 0.3);
  color: white;
}
.featured-banner h2 {
  font-size: clamp(1.8rem, 4vw, 2.8rem);
  font-weight: 800;
  line-height: 1.05;
  letter-spacing: -0.03em;
  max-width: 760px;
  margin-bottom: 28px;
  color: white;
}
.featured-tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 36px;
  flex-wrap: wrap;
}
.tab {
  padding: 9px 22px;
  border-radius: var(--r-pill);
  background: rgba(255, 255, 255, 0.14);
  color: white;
  font-size: 0.85rem;
  font-weight: 600;
  border: 1px solid rgba(255, 255, 255, 0.18);
  transition: all 0.2s;
}
.tab:hover { background: rgba(255, 255, 255, 0.22); }
.tab.active {
  background: white;
  color: var(--primary);
  border-color: white;
}

.featured-bottom {
  background: white;
  border-radius: var(--r-lg) var(--r-lg) 0 0;
  padding: 40px 40px 36px;
  display: grid;
  grid-template-columns: 1.2fr 1fr 64px;
  gap: 36px;
  align-items: center;
  color: var(--ink);
}
.exclusive-img {
  max-height: 240px;
  object-fit: contain;
  margin: 0 auto;
}
.exclusive-info h3 {
  font-size: 0.75rem;
  color: var(--text-3);
  font-weight: 700;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  margin-bottom: 10px;
}
.exclusive-info .price {
  font-size: 2.6rem;
  font-weight: 800;
  line-height: 1;
  margin-bottom: 22px;
  background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  letter-spacing: -0.03em;
}
.exclusive-info .price small {
  font-size: 0.95rem;
  font-weight: 500;
  color: var(--text-3);
  -webkit-text-fill-color: var(--text-3);
}
.exclusive-info ul {
  list-style: none;
  margin-bottom: 24px;
}
.exclusive-info ul li {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 0.88rem;
  color: var(--ink);
  padding: 5px 0;
  font-weight: 500;
}
.exclusive-info ul li::before {
  content: '';
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary), var(--primary-2));
  display: inline-flex;
  flex-shrink: 0;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='3.5' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='20 6 9 17 4 12'/%3E%3C/svg%3E");
  background-size: 12px;
  background-position: center;
  background-repeat: no-repeat;
}

.exclusive-vertical {
  writing-mode: vertical-rl;
  text-orientation: mixed;
  font-size: 0.7rem;
  font-weight: 800;
  letter-spacing: 0.4em;
  color: var(--accent-2);
  text-transform: uppercase;
  background: linear-gradient(180deg, #FFF4E8, #FFE9D6);
  padding: 20px 10px;
  border-radius: 14px;
  align-self: stretch;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 138, 61, 0.2);
}

/* =========================================================
   ARTICLES
   ========================================================= */
.articles-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}
.article-card {
  background: white;
  border-radius: var(--r-xl);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  transition: transform 0.3s var(--ease-out), box-shadow 0.3s;
}
.article-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-xl);
}
.article-image {
  height: 340px;
  position: relative;
  background: linear-gradient(135deg, var(--peach), var(--lavender));
  overflow: hidden;
}
.article-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s var(--ease-out);
}
.article-card:hover .article-image img {
  transform: scale(1.03);
}
.article-image::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(18, 22, 58, 0) 30%, rgba(18, 22, 58, 0.55) 100%);
  pointer-events: none;
}
.article-image .tag {
  position: absolute;
  top: 22px;
  left: 22px;
  z-index: 2;
  background: rgba(255, 255, 255, 0.95);
  padding: 6px 14px;
  border-radius: var(--r-pill);
  font-size: 0.72rem;
  font-weight: 800;
  color: var(--primary);
  letter-spacing: 0.04em;
  text-transform: uppercase;
  box-shadow: var(--shadow-sm);
}
.article-title-overlay {
  position: absolute;
  left: 24px;
  right: 24px;
  bottom: 24px;
  color: white;
  z-index: 2;
}
.article-title-overlay h4 {
  font-size: 1.45rem;
  font-weight: 800;
  line-height: 1.15;
  color: white;
  letter-spacing: -0.02em;
  text-shadow: 0 2px 16px rgba(0, 0, 0, 0.3);
}
.article-body {
  padding: 22px 28px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}
.article-body p {
  font-size: 0.85rem;
  color: var(--text-2);
  flex: 1;
  line-height: 1.6;
}
.article-body .date {
  font-size: 0.78rem;
  font-weight: 700;
  color: var(--ink);
  white-space: nowrap;
  padding: 4px 12px;
  border-radius: var(--r-pill);
  background: var(--cream-2);
}

/* =========================================================
   NEWSLETTER
   ========================================================= */
.newsletter {
  max-width: 920px;
  margin: 40px auto 0;
  text-align: center;
  padding: 80px 32px;
  position: relative;
}
.newsletter::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: var(--r-xl);
  background:
    radial-gradient(ellipse 60% 80% at 50% 0%, rgba(255, 212, 179, 0.5), transparent 70%),
    radial-gradient(ellipse 60% 80% at 50% 100%, rgba(212, 204, 255, 0.5), transparent 70%);
  z-index: -1;
}
.newsletter h2 {
  font-size: clamp(2rem, 4.5vw, 3.2rem);
  font-weight: 800;
  line-height: 1.05;
  letter-spacing: -0.035em;
  color: var(--ink);
  margin-bottom: 36px;
}
.newsletter h2 .highlight {
  background: linear-gradient(120deg, var(--accent) 0%, var(--primary) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}
.newsletter-form {
  max-width: 540px;
  margin: 0 auto;
  padding: 8px;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.9);
  border-radius: var(--r-pill);
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: 8px;
}
.newsletter-form:focus-within {
  box-shadow: var(--shadow-xl), 0 0 0 4px rgba(79, 91, 255, 0.1);
}
.newsletter-form input {
  flex: 1;
  padding: 12px 24px;
  border: none;
  outline: none;
  background: transparent;
  font-size: 0.92rem;
  font-family: inherit;
  color: var(--ink);
}
.newsletter-form input::placeholder { color: var(--text-3); }
.newsletter-form .btn-accent { padding: 12px 26px; }

/* =========================================================
   FOOTER
   ========================================================= */
.footer {
  max-width: 1240px;
  margin: 40px auto 0;
  padding: 48px 32px;
  border-top: 1px solid rgba(18, 22, 58, 0.08);
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 24px;
  flex-wrap: wrap;
  color: var(--text-2);
  font-size: 0.88rem;
}
.footer-links {
  display: flex;
  gap: 28px;
  flex-wrap: wrap;
}
.footer-links a {
  font-weight: 500;
  transition: color 0.2s;
}
.footer-links a:hover { color: var(--primary); }

.footer-social {
  display: flex;
  gap: 10px;
}
.footer-social a {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(18, 22, 58, 0.06);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-2);
  transition: all 0.2s;
  box-shadow: var(--shadow-xs);
}
.footer-social a:hover {
  background: linear-gradient(135deg, var(--primary), var(--accent));
  color: white;
  border-color: transparent;
}

/* =========================================================
   FORM
   ========================================================= */
.form-group { margin-bottom: 18px; }
.form-group label {
  display: block;
  margin-bottom: 8px;
  color: var(--ink);
  font-size: 0.85rem;
  font-weight: 600;
}
.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 13px 18px;
  background: rgba(255, 255, 255, 0.9);
  border: 1.5px solid rgba(18, 22, 58, 0.08);
  border-radius: 14px;
  color: var(--ink);
  font-size: 0.92rem;
  font-family: inherit;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: var(--primary);
  background: white;
  box-shadow: 0 0 0 4px rgba(79, 91, 255, 0.12);
}

/* =========================================================
   CARD & TABLE
   ========================================================= */
.card {
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.9);
  border-radius: var(--r-lg);
  padding: 32px;
  box-shadow: var(--shadow-md);
}
.card h3 { color: var(--ink); margin-bottom: 12px; }
.card p { color: var(--text-2); font-size: 0.92rem; }

.data-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: var(--r-md);
  overflow: hidden;
  box-shadow: var(--shadow-md);
}
.data-table th,
.data-table td {
  padding: 16px 20px;
  text-align: left;
  border-bottom: 1px solid rgba(18, 22, 58, 0.06);
}
.data-table th {
  background: linear-gradient(180deg, #F4F6FF 0%, #ECEEFF 100%);
  color: var(--primary-dark);
  font-weight: 700;
  font-size: 0.85rem;
}
.data-table tr:hover { background: rgba(79, 91, 255, 0.03); }

/* =========================================================
   REVEAL — INSTAN, TIDAK PERLU REFRESH
   ========================================================= */
.reveal {
  opacity: 1; /* default langsung tampil */
  transform: none;
}

/* Kalau JS aktif & elemen belum masuk viewport baru disembunyikan */
.js-ready .reveal:not(.active) {
  opacity: 0;
  transform: translateY(16px);
}
.js-ready .reveal {
  transition: opacity 0.5s var(--ease-out), transform 0.5s var(--ease-out);
}
.js-ready .reveal.active {
  opacity: 1;
  transform: translateY(0);
}

/* =========================================================
   RESPONSIVE
   ========================================================= */
@media (max-width: 1024px) {
  .features-row { grid-template-columns: 1fr 1fr; }
  .info-panel { grid-column: 1 / -1; text-align: center; }
}
@media (max-width: 900px) {
  .hero-inner { grid-template-columns: 1fr; gap: 32px; text-align: center; }
  .hero-text { padding-bottom: 20px; }
  .hero-desc { margin-left: auto; margin-right: auto; }
  .hero-png { max-height: 340px; }
  .package-grid,
  .articles-grid,
  .featured-bottom { grid-template-columns: 1fr; }
  .exclusive-vertical {
    writing-mode: horizontal-tb;
    padding: 12px 20px;
    letter-spacing: 0.3em;
  }
}
@media (max-width: 640px) {
  .nav-container { padding: 14px 20px; }
  .nav-links {
    display: none;
    position: absolute;
    top: 100%;
    left: 16px;
    right: 16px;
    flex-direction: column;
    background: rgba(255, 255, 255, 0.98);
    padding: 16px;
    border-radius: var(--r-md);
    box-shadow: var(--shadow-lg);
    margin: 0;
  }
  .nav-links.open { display: flex; }
  .hamburger { display: inline-flex; }
  .btn-logout span { display: none; }
  .features-row { grid-template-columns: 1fr; padding: 0 20px; }
  .section { padding: 60px 20px; }
  .hero { padding: 40px 20px 0; }
  .search-bar,
  .newsletter-form { flex-direction: column; border-radius: 20px; }
  .search-bar .btn-search,
  .newsletter-form .btn-accent { width: 100%; justify-content: center; }
  .featured-banner { padding: 48px 28px 0; }
  .featured-bottom { padding: 28px 24px; }
  .footer { flex-direction: column; text-align: center; }
}
EOF

echo "   ✅ style.css diringankan."
echo ""

# =========================================================
# 6. UPDATE MAIN.JS — tambahkan class js-ready
# =========================================================
echo "📝 Update src/main.js..."

cat > src/main.js << 'EOF'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/style.css'

// Failsafe: hapus class no-js dan tambahkan js-ready
document.documentElement.classList.remove('no-js')

// js-ready ditambahkan setelah mount supaya reveal baru aktif
const app = createApp(App)
app.use(router)
app.mount('#app')

// Baru tambahkan js-ready setelah render
requestAnimationFrame(() => {
  document.documentElement.classList.add('js-ready')
})
EOF

echo "   ✅ main.js updated."
echo ""

# =========================================================
# 7. SCRIPT DEBUG PNG (opsional)
# =========================================================
echo "📝 Buat src/utils/checkImages.js (opsional, untuk debug)..."

mkdir -p src/utils

cat > src/utils/checkImages.js << 'EOF'
// Debug helper — cek PNG mana yang ada & mana yang tidak
// Pakai di console browser: import { checkImages } from '@/utils/checkImages'
import { IMAGES } from '../data/images'

export async function checkImages() {
  const results = []

  async function test(path, label) {
    try {
      const res = await fetch(path, { method: 'HEAD' })
      results.push({ label, path, ok: res.ok, status: res.status })
    } catch (e) {
      results.push({ label, path, ok: false, status: 'error' })
    }
  }

  for (const [k, v] of Object.entries(IMAGES.hero)) await test(v, `hero/${k}`)
  for (const [k, v] of Object.entries(IMAGES.cards)) await test(v, `cards/${k}`)
  for (const [k, v] of Object.entries(IMAGES.packages)) await test(v, `packages/${k}`)
  for (const [k, v] of Object.entries(IMAGES.articles)) await test(v, `articles/${k}`)

  console.table(results)
  return results
}
EOF

echo "   ✅ checkImages.js dibuat."
echo ""

# =========================================================
# 8. SELESAI
# =========================================================
echo "========================================================"
echo "SELESAI"
echo "========================================================"
echo ""
echo "Yang diperbaiki:"
echo ""
echo "1. PNG tidak tampil:"
echo "   - Vite config: Cache-Control no-store"
echo "   - images.js: cache buster ?v=1"
echo "   - Debug helper: src/utils/checkImages.js"
echo ""
echo "2. Perlu refresh:"
echo "   - useReveal: langsung aktif kalau di viewport"
echo "   - Failsafe 500ms paksa tampil"
echo "   - js-ready class ditambahkan setelah mount"
echo "   - Default .reveal = opacity 1 (langsung tampil)"
echo ""
echo "3. Animasi berat dihapus:"
echo "   - Mesh gradient bergerak -> statis"
echo "   - Blob float -> dihapus"
echo "   - Conic gradient rotate -> dihapus"
echo "   - Gradient text shift -> statis"
echo "   - Hero float -> statis"
echo "   - Shine sweep -> dihapus"
echo "   - Noise overlay -> dihapus"
echo ""
echo "Cara pakai:"
echo "  npm run dev"
echo ""
echo "Kalau PNG masih tidak muncul, cek di browser:"
echo "  http://localhost:5173/images/hero/main.png"
echo "  http://localhost:5173/images/packages/grand.png"
echo ""
echo "Kalau 404 -> cek nama file & folder"
echo "Kalau muncul -> berarti kode sudah benar"
echo ""