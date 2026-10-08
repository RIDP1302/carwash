#!/bin/bash
# =========================================================
#  redesign-mockup.sh
#  Sesuaikan tampilan CuciMesin dengan mockup "Every Sunday"
#  Struktur: Hero + Search + 3 Cards + Special Package +
#            Featured Banner + Articles + CTA Newsletter + Footer
# =========================================================

set -e

echo "🎨 Redesign CuciMesin sesuai mockup..."
echo ""

if [ ! -f "package.json" ]; then
  echo "❌ Error: package.json tidak ditemukan!"
  echo "   Jalankan di folder root project Vue."
  exit 1
fi

# =========================================================
# 1. FOLDER GAMBAR
# =========================================================
echo "📁 Siapkan folder public/images/..."

mkdir -p public/images/hero
mkdir -p public/images/cards
mkdir -p public/images/packages
mkdir -p public/images/articles

# Placeholder PNG transparan (kamu ganti sendiri nanti)
PLACEHOLDER_B64="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="

for f in \
  "hero/main" \
  "hero/layanan" \
  "hero/booking" \
  "hero/status" \
  "hero/login" \
  "cards/choice" \
  "cards/booking" \
  "cards/guide" \
  "packages/grand" \
  "packages/balloon" \
  "packages/exclusive" \
  "articles/travel" \
  "articles/discount"
do
  echo "$PLACEHOLDER_B64" | base64 -d > "public/images/${f}.png" 2>/dev/null || true
done

echo "   ✅ Placeholder PNG dibuat di public/images/"
echo ""

# =========================================================
# 2. GLOBAL STYLE (tema sesuai mockup)
# =========================================================
echo "📝 Update src/assets/style.css..."

cat > src/assets/style.css << 'EOF'
/* =========================================================
   CuciMesin — Global Style (tema mockup Every Sunday)
   ========================================================= */

* { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --primary: #4f6bff;
  --primary-dark: #2c3e9e;
  --primary-light: #e8ecff;
  --accent: #ff8a3d;
  --accent-dark: #f06a1a;
  --navy: #0f1535;
  --navy-2: #1a2148;
  --navy-3: #252d5c;
  --cream: #f5f2ea;
  --cream-2: #ebe6da;
  --text: #0f1535;
  --text-light: #6b7280;
  --white: #ffffff;
  --shadow-sm: 0 4px 12px rgba(15, 21, 53, 0.08);
  --shadow-md: 0 12px 32px rgba(15, 21, 53, 0.12);
  --shadow-lg: 0 24px 60px rgba(15, 21, 53, 0.18);
  --radius: 20px;
  --radius-lg: 32px;
}

html { scroll-behavior: smooth; }

body {
  font-family: 'Poppins', 'Segoe UI', system-ui, -apple-system, sans-serif;
  background: var(--cream);
  color: var(--text);
  line-height: 1.6;
  overflow-x: hidden;
}

a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; border: none; background: none; }
img { max-width: 100%; display: block; }

/* ===== LOADER ===== */
.loader {
  position: fixed; inset: 0;
  background: var(--cream);
  display: flex; flex-direction: column;
  justify-content: center; align-items: center;
  z-index: 9999;
}
.loader-bubble {
  width: 60px; height: 60px; border-radius: 50%;
  background: radial-gradient(circle at 30% 30%, var(--accent), var(--primary));
  animation: bubble 1.2s ease-in-out infinite;
}
.loader p {
  margin-top: 20px; letter-spacing: 4px;
  font-weight: 700; color: var(--primary);
  animation: pulse 1.5s ease-in-out infinite;
}
@keyframes bubble {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.3); }
}
@keyframes pulse {
  0%, 100% { opacity: 0.5; }
  50% { opacity: 1; }
}

/* ===== NAVBAR ===== */
.navbar {
  position: sticky; top: 0; z-index: 100;
  background: rgba(245, 242, 234, 0.85);
  backdrop-filter: blur(14px);
  border-bottom: 1px solid rgba(15, 21, 53, 0.05);
}
.nav-container {
  max-width: 1200px; margin: 0 auto;
  padding: 18px 32px;
  display: flex; align-items: center; justify-content: space-between;
  gap: 24px;
}
.logo {
  display: flex; align-items: center; gap: 8px;
  font-weight: 800; font-size: 1.15rem;
  color: var(--primary);
}
.logo-mark {
  width: 28px; height: 28px; border-radius: 8px;
  background: linear-gradient(135deg, var(--accent), var(--primary));
  display: flex; align-items: center; justify-content: center;
  color: white; font-size: 14px;
}
.nav-links {
  display: flex; list-style: none; gap: 6px;
  margin: 0 auto;
}
.nav-links a {
  padding: 8px 18px; border-radius: 999px;
  font-size: 0.92rem; font-weight: 500;
  color: var(--text-light);
  transition: all 0.25s;
}
.nav-links a:hover { color: var(--primary); }
.nav-links a.active {
  color: var(--primary);
  background: var(--primary-light);
}
.nav-actions {
  display: flex; align-items: center; gap: 12px;
}
.hamburger {
  display: none; flex-direction: column; gap: 5px;
  padding: 8px;
}
.hamburger span {
  width: 22px; height: 2px;
  background: var(--text); border-radius: 2px;
}
.btn-logout {
  padding: 9px 22px; border-radius: 999px;
  border: 1.5px solid var(--primary);
  color: var(--primary); background: transparent;
  font-weight: 600; font-size: 0.88rem;
  transition: all 0.25s;
}
.btn-logout:hover {
  background: var(--primary); color: white;
  box-shadow: var(--shadow-sm);
}

/* ===== HERO ===== */
.hero {
  position: relative;
  padding: 40px 32px 0;
  overflow: hidden;
  background: linear-gradient(180deg, #ffffff 0%, var(--cream) 100%);
}
.hero-inner {
  max-width: 1200px; margin: 0 auto;
  display: grid; grid-template-columns: 1fr 1.1fr;
  gap: 40px; align-items: center;
  position: relative; z-index: 2;
}
.hero-text { padding-bottom: 80px; }
.hero-tagline {
  color: var(--accent);
  font-size: 0.85rem; font-weight: 700;
  letter-spacing: 3px; text-transform: uppercase;
  margin-bottom: 14px;
}
.hero-title {
  font-size: clamp(2.4rem, 5.5vw, 4.2rem);
  font-weight: 900;
  line-height: 1.02;
  color: var(--primary);
  letter-spacing: -1px;
  margin-bottom: 18px;
}
.hero-title .accent { color: var(--accent); }
.hero-desc {
  color: var(--text-light);
  font-size: 0.98rem;
  max-width: 440px;
  margin-bottom: 28px;
}
.hero-image {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: flex-end;
}
.hero-png {
  max-width: 100%; max-height: 480px;
  object-fit: contain;
  filter: drop-shadow(0 30px 50px rgba(79, 107, 255, 0.25));
  animation: floatImg 4s ease-in-out infinite;
}
@keyframes floatImg {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-14px); }
}

/* ===== SEARCH BAR (mirip mockup) ===== */
.search-bar {
  max-width: 720px;
  margin: -30px auto 0;
  padding: 8px;
  background: white;
  border-radius: 999px;
  box-shadow: var(--shadow-lg);
  display: flex; align-items: center;
  gap: 8px;
  position: relative; z-index: 3;
}
.search-bar input {
  flex: 1;
  padding: 14px 24px;
  border: none; outline: none;
  background: transparent;
  font-size: 0.95rem;
  color: var(--text);
}
.search-bar input::placeholder { color: var(--text-light); }
.search-bar .btn-search {
  padding: 12px 32px;
  border-radius: 999px;
  background: var(--accent);
  color: white;
  font-weight: 700; font-size: 0.9rem;
  transition: 0.25s;
}
.search-bar .btn-search:hover {
  background: var(--accent-dark);
  transform: translateX(2px);
}

/* ===== 3 CARDS FITUR (di bawah hero) ===== */
.features-row {
  max-width: 1200px;
  margin: 60px auto 0;
  padding: 0 32px;
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1.1fr;
  gap: 20px;
  align-items: center;
}
.feature-card {
  background: var(--navy);
  color: white;
  border-radius: var(--radius);
  padding: 26px 20px;
  text-align: center;
  transition: transform 0.3s, box-shadow 0.3s;
  box-shadow: var(--shadow-md);
}
.feature-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
}
.feature-card .icon {
  width: 46px; height: 46px;
  margin: 0 auto 14px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.1);
  display: flex; align-items: center; justify-content: center;
  font-size: 22px;
}
.feature-card h4 {
  font-size: 0.95rem; font-weight: 700;
  margin-bottom: 6px;
}
.feature-card p {
  font-size: 0.78rem;
  color: rgba(255, 255, 255, 0.65);
  line-height: 1.5;
}

/* Info panel kanan (dengan nomor 01) */
.info-panel {
  padding: 8px 4px;
}
.step-badge {
  display: inline-flex; align-items: center; justify-content: center;
  width: 36px; height: 36px;
  border-radius: 50%;
  background: white;
  border: 2px solid var(--primary);
  color: var(--primary);
  font-weight: 800; font-size: 0.85rem;
  margin-bottom: 12px;
}
.info-panel h3 {
  font-size: 1.05rem; font-weight: 800;
  color: var(--navy);
  letter-spacing: 0.5px;
  margin-bottom: 8px;
}
.info-panel p {
  font-size: 0.82rem;
  color: var(--text-light);
  margin-bottom: 14px;
  line-height: 1.5;
}

/* ===== BUTTONS ===== */
.btn-primary {
  display: inline-flex; align-items: center; gap: 8px;
  padding: 12px 28px;
  border-radius: 999px;
  background: var(--primary);
  color: white;
  font-weight: 700; font-size: 0.9rem;
  transition: 0.25s;
  box-shadow: 0 10px 24px rgba(79, 107, 255, 0.3);
}
.btn-primary:hover {
  background: var(--primary-dark);
  transform: translateY(-2px);
  box-shadow: 0 14px 32px rgba(79, 107, 255, 0.4);
}
.btn-accent {
  display: inline-flex; align-items: center; gap: 8px;
  padding: 10px 22px;
  border-radius: 999px;
  background: var(--accent);
  color: white;
  font-weight: 700; font-size: 0.82rem;
  transition: 0.25s;
}
.btn-accent:hover { background: var(--accent-dark); }
.btn-secondary {
  display: inline-flex; align-items: center; gap: 8px;
  padding: 11px 24px;
  border-radius: 999px;
  border: 1.5px solid var(--primary);
  color: var(--primary);
  background: transparent;
  font-weight: 600; font-size: 0.88rem;
  transition: 0.25s;
}
.btn-secondary:hover {
  background: var(--primary); color: white;
}

/* ===== SECTION ===== */
.section {
  max-width: 1200px;
  margin: 0 auto;
  padding: 90px 32px;
}
.section-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 24px;
  margin-bottom: 40px;
  flex-wrap: wrap;
}
.section-head-left { max-width: 480px; }
.section-title {
  font-size: clamp(1.6rem, 3.2vw, 2.4rem);
  font-weight: 900;
  color: var(--navy);
  letter-spacing: -0.5px;
  margin-bottom: 10px;
}
.section-sub {
  color: var(--text-light);
  font-size: 0.9rem;
}

/* ===== SPECIAL PACKAGE CARDS ===== */
.package-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
}
.package-card {
  background: white;
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  transition: transform 0.3s, box-shadow 0.3s;
  display: flex; flex-direction: column;
}
.package-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
}
.package-image {
  height: 260px;
  background: linear-gradient(135deg, #c5d2ff, #ffe6c7);
  display: flex; align-items: center; justify-content: center;
  position: relative;
  overflow: hidden;
}
.package-image img {
  width: 100%; height: 100%;
  object-fit: cover;
}
.package-rating {
  position: absolute; top: 16px; right: 16px;
  background: white;
  padding: 6px 12px;
  border-radius: 999px;
  font-size: 0.82rem; font-weight: 700;
  box-shadow: var(--shadow-sm);
}
.package-body {
  padding: 22px 24px;
  display: flex; justify-content: space-between; align-items: center;
  gap: 16px;
}
.package-body h4 {
  font-size: 1.1rem; font-weight: 800;
  color: var(--navy);
  margin-bottom: 4px;
}
.package-body p {
  font-size: 0.8rem; color: var(--text-light);
}

/* ===== FEATURED BANNER BIRU ===== */
.featured-banner {
  background: linear-gradient(135deg, var(--primary) 0%, #6b83ff 100%);
  border-radius: var(--radius-lg);
  padding: 60px 48px 0;
  color: white;
  position: relative;
  overflow: hidden;
  margin: 40px 0;
}
.featured-banner .step-badge {
  background: rgba(255, 255, 255, 0.15);
  border-color: white;
  color: white;
}
.featured-banner h2 {
  font-size: clamp(1.6rem, 3.5vw, 2.6rem);
  font-weight: 900;
  line-height: 1.1;
  max-width: 720px;
  letter-spacing: -0.5px;
  margin-bottom: 24px;
}
.featured-tabs {
  display: flex; gap: 10px;
  margin-bottom: 32px;
}
.tab {
  padding: 8px 20px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.15);
  color: white;
  font-size: 0.85rem;
  font-weight: 600;
  transition: 0.25s;
}
.tab.active {
  background: var(--accent);
}
.featured-bottom {
  background: white;
  border-radius: var(--radius) var(--radius) 0 0;
  padding: 32px;
  display: grid;
  grid-template-columns: 1.2fr 1fr 60px;
  gap: 32px;
  align-items: center;
  color: var(--text);
}
.exclusive-img {
  max-height: 220px;
  object-fit: contain;
  margin: 0 auto;
}
.exclusive-info h3 {
  font-size: 0.85rem;
  color: var(--text-light);
  font-weight: 600;
  margin-bottom: 8px;
}
.exclusive-info .price {
  font-size: 2.4rem;
  font-weight: 900;
  color: var(--primary);
  line-height: 1;
  margin-bottom: 20px;
}
.exclusive-info .price small {
  font-size: 0.9rem;
  font-weight: 500;
  color: var(--text-light);
}
.exclusive-info ul {
  list-style: none;
  margin-bottom: 20px;
}
.exclusive-info ul li {
  display: flex; align-items: center; gap: 8px;
  font-size: 0.85rem;
  color: var(--text);
  padding: 4px 0;
}
.exclusive-info ul li::before {
  content: '✓';
  display: inline-flex; align-items: center; justify-content: center;
  width: 18px; height: 18px;
  border-radius: 50%;
  background: var(--primary);
  color: white;
  font-size: 11px;
  font-weight: 800;
}
.exclusive-vertical {
  writing-mode: vertical-rl;
  text-orientation: mixed;
  font-size: 0.72rem;
  font-weight: 700;
  letter-spacing: 4px;
  color: var(--accent);
  text-transform: uppercase;
  background: #fff4e8;
  padding: 16px 8px;
  border-radius: 12px;
  align-self: stretch;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* ===== ARTICLES ===== */
.articles-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}
.article-card {
  background: white;
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  transition: transform 0.3s, box-shadow 0.3s;
}
.article-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
}
.article-image {
  height: 320px;
  position: relative;
  background: linear-gradient(135deg, #ffd6a5, #ff9a76);
  overflow: hidden;
}
.article-image img {
  width: 100%; height: 100%; object-fit: cover;
}
.article-image .tag {
  position: absolute; top: 20px; left: 20px;
  background: white;
  padding: 6px 14px;
  border-radius: 999px;
  font-size: 0.75rem; font-weight: 700;
  color: var(--primary);
}
.article-image .article-title-overlay {
  position: absolute;
  left: 20px; right: 20px; bottom: 20px;
  color: white;
}
.article-image .article-title-overlay h4 {
  font-size: 1.4rem; font-weight: 900;
  line-height: 1.15;
  text-shadow: 0 2px 12px rgba(0, 0, 0, 0.35);
}
.article-body {
  padding: 20px 24px;
  display: flex; justify-content: space-between; align-items: center;
  gap: 16px;
}
.article-body p {
  font-size: 0.82rem;
  color: var(--text-light);
  flex: 1;
}
.article-body .date {
  font-size: 0.78rem;
  font-weight: 700;
  color: var(--text);
  white-space: nowrap;
}

/* ===== NEWSLETTER CTA ===== */
.newsletter {
  max-width: 900px;
  margin: 40px auto 0;
  text-align: center;
  padding: 60px 32px;
}
.newsletter h2 {
  font-size: clamp(1.8rem, 4vw, 3rem);
  font-weight: 900;
  line-height: 1.05;
  letter-spacing: -1px;
  color: var(--navy);
  margin-bottom: 32px;
}
.newsletter h2 .highlight { color: var(--accent); }
.newsletter-form {
  max-width: 520px;
  margin: 0 auto;
  padding: 8px;
  background: white;
  border-radius: 999px;
  box-shadow: var(--shadow-md);
  display: flex; align-items: center;
  gap: 8px;
}
.newsletter-form input {
  flex: 1;
  padding: 12px 24px;
  border: none; outline: none;
  background: transparent;
  font-size: 0.92rem;
}
.newsletter-form .btn-accent {
  padding: 12px 28px;
  font-size: 0.88rem;
}

/* ===== FOOTER ===== */
.footer {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 32px;
  border-top: 1px solid rgba(15, 21, 53, 0.08);
  display: flex; justify-content: space-between; align-items: center;
  gap: 24px; flex-wrap: wrap;
  color: var(--text-light);
  font-size: 0.85rem;
}
.footer-links {
  display: flex; gap: 24px;
}
.footer-links a:hover { color: var(--primary); }
.footer-social {
  display: flex; gap: 10px;
}
.footer-social a {
  width: 34px; height: 34px;
  border-radius: 50%;
  background: white;
  display: flex; align-items: center; justify-content: center;
  box-shadow: var(--shadow-sm);
  transition: 0.25s;
  font-size: 14px;
}
.footer-social a:hover {
  background: var(--primary);
  color: white;
  transform: translateY(-2px);
}

/* ===== FORM ===== */
.form-group { margin-bottom: 16px; }
.form-group label {
  display: block; margin-bottom: 6px;
  color: var(--text); font-size: 0.88rem;
  font-weight: 600;
}
.form-group input,
.form-group select,
.form-group textarea {
  width: 100%; padding: 12px 16px;
  background: white;
  border: 1.5px solid rgba(15, 21, 53, 0.1);
  border-radius: 12px;
  color: var(--text);
  font-size: 0.92rem;
  font-family: inherit;
  transition: 0.2s;
}
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 4px rgba(79, 107, 255, 0.12);
}

/* ===== CARD UMUM ===== */
.card {
  background: white;
  border-radius: var(--radius);
  padding: 28px;
  box-shadow: var(--shadow-sm);
}
.card h3 {
  color: var(--navy);
  margin-bottom: 10px;
}
.card p { color: var(--text-light); font-size: 0.9rem; }

/* ===== TABLE ===== */
.data-table {
  width: 100%; border-collapse: collapse;
  background: white;
  border-radius: var(--radius);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}
.data-table th, .data-table td {
  padding: 14px 18px;
  text-align: left;
  border-bottom: 1px solid rgba(15, 21, 53, 0.06);
}
.data-table th {
  background: var(--primary-light);
  color: var(--primary);
  font-weight: 700;
  font-size: 0.85rem;
}
.data-table tr:hover { background: rgba(79, 107, 255, 0.03); }

/* ===== REVEAL ===== */
.reveal {
  opacity: 0; transform: translateY(30px);
  transition: opacity 0.7s ease, transform 0.7s ease;
}
.reveal.active { opacity: 1; transform: translateY(0); }

/* ===== RESPONSIVE ===== */
@media (max-width: 1024px) {
  .features-row {
    grid-template-columns: 1fr 1fr;
  }
  .info-panel {
    grid-column: 1 / -1;
    text-align: center;
  }
}
@media (max-width: 900px) {
  .hero-inner {
    grid-template-columns: 1fr;
    gap: 24px;
    text-align: center;
  }
  .hero-text { padding-bottom: 20px; }
  .hero-desc { margin-left: auto; margin-right: auto; }
  .hero-png { max-height: 320px; }
  .package-grid,
  .articles-grid,
  .featured-bottom {
    grid-template-columns: 1fr;
  }
  .exclusive-vertical {
    writing-mode: horizontal-tb;
    padding: 10px 16px;
  }
}
@media (max-width: 640px) {
  .nav-links {
    display: none;
    position: absolute;
    top: 100%; left: 0; right: 0;
    flex-direction: column;
    background: white;
    padding: 16px;
    box-shadow: var(--shadow-md);
    border-radius: 0 0 20px 20px;
  }
  .nav-links.open { display: flex; }
  .hamburger { display: flex; }
  .features-row { grid-template-columns: 1fr; padding: 0 20px; }
  .section { padding: 60px 20px; }
  .search-bar { flex-direction: column; border-radius: 20px; }
  .search-bar .btn-search { width: 100%; border-radius: 14px; }
  .newsletter-form { flex-direction: column; border-radius: 20px; }
  .newsletter-form .btn-accent { width: 100%; border-radius: 14px; }
  .footer { flex-direction: column; text-align: center; }
}
EOF

echo "   ✅ style.css (tema mockup) dibuat."
echo ""

# =========================================================
# 3. DATA GAMBAR
# =========================================================
echo "📝 Update src/data/images.js..."

mkdir -p src/data

cat > src/data/images.js << 'EOF'
// =========================================================
//  Konfigurasi Gambar CuciMesin
//  File fisik: public/images/...
//  URL di kode: /images/...
// =========================================================

export const IMAGES = {
  hero: {
    main:    '/images/hero/main.png',
    layanan: '/images/hero/layanan.png',
    booking: '/images/hero/booking.png',
    status:  '/images/hero/status.png',
    login:   '/images/hero/login.png'
  },
  cards: {
    choice:  '/images/cards/choice.png',
    booking: '/images/cards/booking.png',
    guide:   '/images/cards/guide.png'
  },
  packages: {
    grand:     '/images/packages/grand.png',
    balloon:   '/images/packages/balloon.png',
    exclusive: '/images/packages/exclusive.png'
  },
  articles: {
    travel:   '/images/articles/travel.png',
    discount: '/images/articles/discount.png'
  }
}
EOF

echo "   ✅ images.js diperbarui."
echo ""

# =========================================================
# 4. KOMPONEN NAVBAR (versi mockup)
# =========================================================
echo "📝 Update src/components/PublicNavbar.vue..."

cat > src/components/PublicNavbar.vue << 'EOF'
<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/beranda" class="logo">
        <span class="logo-mark">💧</span>
        CuciMesin
      </router-link>

      <nav>
        <ul class="nav-links" :class="{ open: menuOpen }">
          <li><router-link to="/beranda" @click="closeMenu">Beranda</router-link></li>
          <li><router-link to="/layanan" @click="closeMenu">Layanan</router-link></li>
          <li><router-link to="/booking" @click="closeMenu">Booking</router-link></li>
          <li><router-link to="/status" @click="closeMenu">Status</router-link></li>
          <li><router-link to="/profil" @click="closeMenu">Profil</router-link></li>
        </ul>
      </nav>

      <div class="nav-actions">
        <button class="btn-logout" @click="logout">Logout</button>
        <button class="hamburger" @click="menuOpen = !menuOpen">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const menuOpen = ref(false)

function closeMenu() { menuOpen.value = false }

function logout() {
  if (!confirm('Yakin mau keluar?')) return
  localStorage.removeItem('cucimesin_user')
  router.push('/login')
}
</script>
EOF

echo "   ✅ PublicNavbar.vue diperbarui."
echo ""

# =========================================================
# 5. HALAMAN BERANDA (SESUAI MOCKUP)
# =========================================================
echo "📝 Update src/views/public/HomeView.vue..."

cat > src/views/public/HomeView.vue << 'EOF'
<template>
  <PublicNavbar />

  <!-- ============ HERO ============ -->
  <section class="hero">
    <div class="hero-inner">
      <div class="hero-text reveal">
        <p class="hero-tagline">#PASTIBERSIH, PASTITERJANGKAU</p>
        <h1 class="hero-title">
          CUCI MESIN<br>
          <span class="accent">KINCLONG!</span> 💧
        </h1>
        <p class="hero-desc">
          CuciMesin adalah spesialis cuci mesin mobil dengan metode dry-wash
          dan masking elektrikal total. Aman, cepat, bergaransi.
        </p>
      </div>

      <div class="hero-image reveal">
        <img
          :src="IMAGES.hero.main"
          alt="Ilustrasi Cuci Mesin Mobil"
          class="hero-png"
          @error="hideOnError"
        />
      </div>
    </div>

    <!-- Search Bar -->
    <div class="search-bar">
      <input
        type="text"
        v-model="search"
        placeholder="Cari layanan atau masukkan plat nomor..."
        @keyup.enter="doSearch"
      />
      <button class="btn-search" @click="doSearch">Cari</button>
    </div>
  </section>

  <!-- ============ FITUR CARDS + INFO 01 ============ -->
  <section class="features-row reveal">
    <div class="feature-card">
      <div class="icon">📍</div>
      <h4>Banyak Pilihan</h4>
      <p>Paket cuci mesin dari reguler hingga showroom.</p>
    </div>
    <div class="feature-card">
      <div class="icon">📅</div>
      <h4>Booking Mudah</h4>
      <p>Booking online, konfirmasi cepat via WhatsApp.</p>
    </div>
    <div class="feature-card">
      <div class="icon">👨‍🔧</div>
      <h4>Teknisi Ahli</h4>
      <p>Ditangani teknisi tersertifikasi ruang mesin.</p>
    </div>

    <div class="info-panel">
      <div class="step-badge">01</div>
      <h3>LAYANAN KAMI</h3>
      <p>
        CuciMesin melayani perawatan ruang mesin mobil pribadi hingga showroom
        dengan standar kebersihan premium.
      </p>
      <router-link to="/layanan" class="btn-accent">Pelajari →</router-link>
    </div>
  </section>

  <!-- ============ SPECIAL PACKAGE 02 ============ -->
  <section class="section">
    <div class="section-head">
      <div class="section-head-left">
        <div class="step-badge">02</div>
        <h2 class="section-title">PAKET SPESIAL</h2>
        <p class="section-sub">
          Pilih paket sesuai kebutuhan kendaraan Anda. Semua paket sudah termasuk
          garansi aman kelistrikan.
        </p>
      </div>
      <router-link to="/layanan" class="btn-accent">Lihat Semua →</router-link>
    </div>

    <div class="package-grid">
      <article class="package-card">
        <div class="package-image">
          <img :src="IMAGES.packages.grand" alt="Paket Showroom" @error="hideOnError" />
          <div class="package-rating">⭐ 4.9</div>
        </div>
        <div class="package-body">
          <div>
            <h4>Paket Spesialis Showroom</h4>
            <p>Rp 450.000 / mobil — Deep cleaning & engine dressing</p>
          </div>
          <router-link to="/booking" class="btn-accent">Booking →</router-link>
        </div>
      </article>

      <article class="package-card">
        <div class="package-image">
          <img :src="IMAGES.packages.balloon" alt="Paket Ultimate" @error="hideOnError" />
        </div>
        <div class="package-body">
          <div>
            <h4>Ultimate Detail</h4>
            <p>Rp 850.000 — Coating & restorasi total</p>
          </div>
        </div>
      </article>
    </div>
  </section>

  <!-- ============ FEATURED BANNER 03 ============ -->
  <section class="section" style="padding-top:0">
    <div class="featured-banner reveal">
      <div class="step-badge">03</div>
      <h2>DIPERCAYA LEBIH DARI<br>500+ PEMILIK MOBIL</h2>

      <div class="featured-tabs">
        <button class="tab active">Semua Paket</button>
        <button class="tab">Reguler</button>
        <button class="tab">Premium</button>
      </div>

      <div class="featured-bottom">
        <img
          :src="IMAGES.packages.exclusive"
          alt="Paket Exclusive"
          class="exclusive-img"
          @error="hideOnError"
        />
        <div class="exclusive-info">
          <h3>Eksklusif</h3>
          <p class="price">Rp 450k <small>/ mobil</small></p>
          <ul>
            <li>Semua fitur Reguler Wash</li>
            <li>Deep cleaning kerak oli menahun</li>
            <li>Engine dressing premium (anti getas)</li>
            <li>Sertifikat garansi digital</li>
          </ul>
          <router-link to="/booking" class="btn-accent">Booking →</router-link>
        </div>
        <div class="exclusive-vertical">CUCI MESIN PRO</div>
      </div>
    </div>
  </section>

  <!-- ============ ARTICLES 04 ============ -->
  <section class="section" style="padding-top:0">
    <div class="section-head">
      <div class="section-head-left">
        <div class="step-badge">04</div>
        <h2 class="section-title">ARTIKEL & TIPS</h2>
      </div>
      <a href="#" class="btn-accent">Lihat Semua →</a>
    </div>

    <div class="articles-grid">
      <article class="article-card">
        <div class="article-image">
          <img :src="IMAGES.articles.travel" alt="Artikel 1" @error="hideOnError" />
          <span class="tag">CuciMesin</span>
          <div class="article-title-overlay">
            <h4>5 Tanda Mesin Mobil<br>Perlu Dicuci</h4>
          </div>
        </div>
        <div class="article-body">
          <p>Kenali tanda-tanda ruang mesin kotor sebelum merusak performa.</p>
          <span class="date">10 Okt 2024</span>
        </div>
      </article>

      <article class="article-card">
        <div class="article-image">
          <img :src="IMAGES.articles.discount" alt="Artikel 2" @error="hideOnError" />
          <span class="tag">CuciMesin</span>
          <div class="article-title-overlay">
            <h4>Diskon 50%<br>Untuk Member Baru</h4>
          </div>
        </div>
        <div class="article-body">
          <p>Daftar sekarang dan nikmati promo cuci mesin pertama.</p>
          <span class="date">10 Okt 2024</span>
        </div>
      </article>
    </div>
  </section>

  <!-- ============ NEWSLETTER CTA ============ -->
  <section class="newsletter reveal">
    <h2>
      MULAI SEKARANG & DAPATKAN<br>
      <span class="highlight">UPDATE PROMO</span> DARI KAMI
    </h2>
    <form class="newsletter-form" @submit.prevent="subscribe">
      <input type="email" v-model="email" placeholder="Masukkan email Anda" required />
      <button type="submit" class="btn-accent">Mulai →</button>
    </form>
  </section>

  <!-- ============ FOOTER ============ -->
  <footer class="footer">
    <div class="logo">
      <span class="logo-mark">💧</span>
      CuciMesin
    </div>
    <div class="footer-links">
      <router-link to="/beranda">Beranda</router-link>
      <router-link to="/layanan">Layanan</router-link>
      <router-link to="/booking">Booking</router-link>
      <router-link to="/status">Status</router-link>
    </div>
    <div class="footer-social">
      <a href="#" aria-label="Instagram">📷</a>
      <a href="#" aria-label="Twitter">🐦</a>
      <a href="#" aria-label="Facebook">📘</a>
    </div>
    <small>© 2024 CuciMesin Carwash</small>
  </footer>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import PublicNavbar from '../../components/PublicNavbar.vue'
import { useReveal } from '../../composables/useReveal'
import { IMAGES } from '../../data/images'

useReveal()

const router = useRouter()
const search = ref('')
const email = ref('')

function doSearch() {
  if (search.value.trim()) {
    alert('🔍 Mencari: ' + search.value)
    router.push('/layanan')
  }
}

function subscribe() {
  alert('✅ Terima kasih! Email ' + email.value + ' sudah terdaftar.')
  email.value = ''
}

// Sembunyikan gambar kalau file PNG belum di-upload
function hideOnError(e) {
  e.target.style.opacity = '0'
}
</script>
EOF

echo "   ✅ HomeView.vue diperbarui (sesuai mockup)."
echo ""

# =========================================================
# 6. UPDATE LOGIN VIEW (tema baru)
# =========================================================
echo "📝 Update src/views/public/LoginView.vue..."

cat > src/views/public/LoginView.vue << 'EOF'
<template>
  <section class="hero" style="min-height:100vh;display:flex;align-items:center">
    <div class="hero-inner" style="width:100%">
      <div class="hero-text">
        <p class="hero-tagline">#PASTIBERSIH, PASTITERJANGKAU</p>
        <h1 class="hero-title">
          SELAMAT<br>
          <span class="accent">DATANG!</span>
        </h1>
        <p class="hero-desc">
          Login untuk mulai booking cuci mesin, atau kelola dashboard admin
          CuciMesin.
        </p>
      </div>

      <div style="width:100%;max-width:440px;margin:0 auto">
        <form @submit.prevent="login" class="card" style="padding:36px">
          <h2 style="margin-bottom:24px;text-align:center;color:var(--navy)">
            Masuk Aplikasi
          </h2>

          <div class="form-group">
            <label>Username</label>
            <input
              type="text"
              v-model="username"
              placeholder="admin / teknisi / kasir / pelanggan"
              required
              autocomplete="username"
            />
          </div>

          <div class="form-group">
            <label>Password</label>
            <input
              type="password"
              v-model="password"
              placeholder="••••••••"
              required
              autocomplete="current-password"
            />
          </div>

          <p v-if="errorMsg" class="error-msg">{{ errorMsg }}</p>

          <button type="submit" class="btn-primary" style="width:100%;justify-content:center">
            Masuk Aplikasi
          </button>

          <p style="text-align:center;margin-top:16px;color:var(--text-light);font-size:0.88rem">
            Belum punya akun?
            <router-link to="/daftar" style="color:var(--primary);font-weight:600">Daftar</router-link>
          </p>
        </form>

        <!-- Info Akun Test -->
        <div class="card" style="margin-top:20px;padding:24px">
          <h3 style="margin-bottom:14px;display:flex;align-items:center;gap:8px;color:var(--navy)">
            🔑 Akun Test & Admin
          </h3>
          <p style="color:var(--text-light);font-size:0.82rem;margin-bottom:14px">
            Klik kartu akun untuk mengisi form otomatis.
          </p>

          <div class="account-list">
            <button
              v-for="acc in accounts"
              :key="acc.username"
              type="button"
              class="account-item"
              @click="fillAccount(acc)"
            >
              <div class="account-left">
                <span class="account-badge" :style="{ background: acc.color }">
                  {{ acc.badge }}
                </span>
                <div>
                  <div class="account-username">{{ acc.username }}</div>
                  <div class="account-password">{{ acc.password }}</div>
                </div>
              </div>
              <span class="account-arrow">→</span>
            </button>
          </div>

          <div class="copy-section">
            <button type="button" class="btn-copy" @click="copyAll">
              📋 Salin Semua Akun
            </button>
            <span v-if="copied" class="copied-text">✅ Tersalin!</span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ACCOUNTS, findAccount } from '../../data/accounts'

const router = useRouter()
const username = ref('')
const password = ref('')
const errorMsg = ref('')
const copied = ref(false)
const accounts = ACCOUNTS

function fillAccount(acc) {
  username.value = acc.username
  password.value = acc.password
  errorMsg.value = ''
}

function login() {
  errorMsg.value = ''
  const acc = findAccount(username.value, password.value)

  if (!acc) {
    errorMsg.value = '❌ Username atau password salah!'
    return
  }

  localStorage.setItem('cucimesin_user', JSON.stringify({
    username: acc.username,
    nama: acc.nama,
    role: acc.role
  }))

  router.push(acc.redirect)
}

async function copyAll() {
  const text = accounts
    .map((a) => `${a.role.padEnd(10)} | ${a.username.padEnd(12)} | ${a.password}`)
    .join('\n')

  try {
    await navigator.clipboard.writeText(text)
  } catch (e) {
    const ta = document.createElement('textarea')
    ta.value = text
    document.body.appendChild(ta)
    ta.select()
    document.execCommand('copy')
    ta.remove()
  }
  copied.value = true
  setTimeout(() => (copied.value = false), 2000)
}
</script>

<style scoped>
.error-msg {
  color: #e11d48;
  font-size: 0.85rem;
  margin-bottom: 12px;
  padding: 10px 14px;
  background: #ffe4e8;
  border-radius: 10px;
  border: 1px solid #ffc9d3;
}

.account-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.account-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 14px;
  background: var(--cream);
  border: 1.5px solid rgba(15, 21, 53, 0.06);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.25s;
  text-align: left;
  color: var(--text);
  width: 100%;
  font-family: inherit;
}
.account-item:hover {
  background: var(--primary-light);
  border-color: var(--primary);
  transform: translateX(4px);
}

.account-left {
  display: flex; align-items: center; gap: 12px;
}

.account-badge {
  font-size: 0.65rem; font-weight: 800;
  letter-spacing: 1px;
  padding: 4px 10px;
  border-radius: 6px;
  color: white;
  min-width: 72px;
  text-align: center;
}

.account-username {
  font-weight: 700;
  font-size: 0.9rem;
  color: var(--navy);
}

.account-password {
  font-family: monospace;
  color: var(--text-light);
  font-size: 0.78rem;
}

.account-arrow {
  color: var(--primary);
  font-weight: 800;
  transition: transform 0.25s;
}
.account-item:hover .account-arrow { transform: translateX(4px); }

.copy-section {
  display: flex; align-items: center; gap: 10px;
  margin-top: 14px;
}

.btn-copy {
  flex: 1;
  padding: 10px;
  border-radius: 10px;
  border: 1.5px dashed rgba(79, 107, 255, 0.4);
  background: transparent;
  color: var(--primary);
  font-size: 0.85rem;
  font-weight: 600;
  transition: 0.25s;
  font-family: inherit;
}
.btn-copy:hover {
  background: var(--primary-light);
  border-style: solid;
}

.copied-text {
  color: #16a34a;
  font-size: 0.85rem;
  font-weight: 700;
}
</style>
EOF

echo "   ✅ LoginView.vue diperbarui."
echo ""

# =========================================================
# 7. UPDATE DATA AKUN
# =========================================================
cat > src/data/accounts.js << 'EOF'
export const ACCOUNTS = [
  { username: 'admin',     password: 'admin123',     nama: 'Administrator', role: 'admin',     redirect: '/admin/dashboard',      badge: 'ADMIN',     color: '#e11d48' },
  { username: 'teknisi',   password: 'teknisi123',   nama: 'Dedi Setiadi',  role: 'teknisi',   redirect: '/admin/teknisi/tugas',  badge: 'TEKNISI',   color: '#4f6bff' },
  { username: 'kasir',     password: 'kasir123',     nama: 'Rina Kasir',    role: 'kasir',     redirect: '/admin/keuangan',       badge: 'KASIR',     color: '#16a34a' },
  { username: 'pelanggan', password: 'pelanggan123', nama: 'Budi Santoso',  role: 'pelanggan', redirect: '/beranda',              badge: 'PELANGGAN', color: '#f59e0b' }
]

export function findAccount(username, password) {
  return ACCOUNTS.find(
    (a) => a.username === username.trim().toLowerCase() && a.password === password
  ) || null
}
EOF

echo "   ✅ accounts.js diperbarui."
echo ""

# =========================================================
# 8. UPDATE ADMIN NAVBAR (tema baru)
# =========================================================
cat > src/components/AdminNavbar.vue << 'EOF'
<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/admin/dashboard" class="logo">
        <span class="logo-mark">⚙️</span>
        Admin CuciMesin
      </router-link>

      <nav>
        <ul class="nav-links">
          <li><router-link to="/admin/dashboard">Dashboard</router-link></li>
          <li><router-link to="/admin/order">Order</router-link></li>
          <li><router-link to="/admin/pelanggan">Pelanggan</router-link></li>
          <li><router-link to="/admin/teknisi">Teknisi</router-link></li>
          <li><router-link to="/admin/laporan">Laporan</router-link></li>
          <li><router-link to="/admin/keuangan">Keuangan</router-link></li>
          <li><router-link to="/admin/pengaturan">Pengaturan</router-link></li>
        </ul>
      </nav>

      <div class="nav-actions">
        <span v-if="user" class="user-info">
          <span class="user-badge">{{ user.role }}</span>
          {{ user.nama }}
        </span>
        <button class="btn-logout" @click="logout">Keluar</button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const user = ref(null)

onMounted(() => {
  const raw = localStorage.getItem('cucimesin_user')
  if (raw) user.value = JSON.parse(raw)
})

function logout() {
  if (!confirm('Yakin mau keluar?')) return
  localStorage.removeItem('cucimesin_user')
  router.push('/login')
}
</script>

<style scoped>
.nav-actions { display: flex; align-items: center; gap: 12px; }
.user-info {
  display: flex; align-items: center; gap: 8px;
  color: var(--text-light); font-size: 0.85rem;
}
.user-badge {
  background: linear-gradient(135deg, var(--primary), var(--accent));
  color: white;
  font-weight: 800;
  padding: 3px 10px;
  border-radius: 999px;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
</style>
EOF

echo "   ✅ AdminNavbar.vue diperbarui."
echo ""

# =========================================================
# 9. UPDATE INDEX.HTML (tambah font Poppins)
# =========================================================
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CuciMesin — #PastiBersih, PastiTerjangkau!</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body>
  <div id="app"></div>
  <script type="module" src="/src/main.js"></script>
</body>
</html>
EOF

echo "   ✅ index.html diperbarui (font Poppins)."
echo ""

# =========================================================
# 10. SELESAI
# =========================================================
echo "========================================================"
echo "🎉 REDESIGN SELESAI!"
echo "========================================================"
echo ""
echo "📁 Struktur gambar (taruh PNG kamu di sini):"
echo ""
echo "   public/images/"
echo "   ├── hero/"
echo "   │   ├── main.png        ← hero beranda (mobil + karakter)"
echo "   │   ├── layanan.png     ← hero halaman layanan"
echo "   │   ├── booking.png     ← hero halaman booking"
echo "   │   ├── status.png      ← hero halaman status"
echo "   │   └── login.png       ← hero halaman login"
echo "   ├── cards/"
echo "   │   ├── choice.png      ← icon pilihan"
echo "   │   ├── booking.png     ← icon booking"
echo "   │   └── guide.png       ← icon teknisi"
echo "   ├── packages/"
echo "   │   ├── grand.png       ← card paket besar"
echo "   │   ├── balloon.png     ← card paket kecil"
echo "   │   └── exclusive.png   ← banner exclusive"
echo "   └── articles/"
echo "       ├── travel.png      ← artikel 1"
echo "       └── discount.png    ← artikel 2"
echo ""
echo "📐 Rekomendasi ukuran PNG:"
echo "   • Hero        : 800 x 800 px (transparan)"
echo "   • Card icon   : 200 x 200 px"
echo "   • Package img : 600 x 400 px"
echo "   • Article img : 800 x 600 px"
echo ""
echo "▶️  Jalankan: npm run dev"
echo "   Buka: http://localhost:5173"
echo ""
echo "📌 Halaman yang sudah disesuaikan dengan mockup:"
echo "   ✅ Beranda    (hero + search + 3 cards + 01-04 + articles + newsletter + footer)"
echo "   ✅ Login      (hero + form + akun test)"
echo ""
echo "📌 Halaman yang masih pakai style lama (bisa kamu request next):"
echo "   ⏳ Layanan, Booking, Status, Profil, Daftar"
echo "   ⏳ Semua halaman admin"
echo ""
echo "💡 Kalau mau semua halaman admin juga disesuaikan mockup, tinggal bilang!"
echo ""