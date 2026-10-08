#!/bin/bash
# =========================================================
#  premium-upgrade.sh
#  Upgrade visual CuciMesin → premium (kelas agency)
#  - Gradient multi-layer & transisi warna halus
#  - Mesh gradient animasi
#  - Glassmorphism + soft shadow berlapis
#  - Noise texture + gradient border
#  - Micro-interaction halus
# =========================================================

set -e

echo "💎 Premium visual upgrade..."
echo ""

if [ ! -f "package.json" ]; then
  echo "❌ Error: package.json tidak ditemukan!"
  exit 1
fi

# =========================================================
# 1. BACKUP STYLE LAMA
# =========================================================
if [ -f "src/assets/style.css" ] && [ ! -f "src/assets/style.backup.css" ]; then
  cp src/assets/style.css src/assets/style.backup.css
  echo "📦 Backup style lama → src/assets/style.backup.css"
  echo ""
fi

# =========================================================
# 2. PREMIUM STYLE (ganti total)
# =========================================================
echo "📝 Tulis ulang src/assets/style.css (premium)..."

cat > src/assets/style.css << 'EOF'
/* =========================================================
   CuciMesin — Premium Style
   Palette: cream → peach → lavender → navy
   Efek: mesh gradient, glass, noise, soft shadow
   ========================================================= */

/* ---------- FONTS ---------- */
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&display=swap');

/* ---------- RESET ---------- */
*, *::before, *::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* ---------- TOKENS ---------- */
:root {
  /* Warna dasar */
  --cream:        #FBF8F3;
  --cream-2:      #F5EFE4;
  --peach:        #FFE9D6;
  --peach-2:      #FFD4B3;
  --lavender:     #E8E4FF;
  --lavender-2:   #D4CCFF;
  --sky:          #DCEBFF;
  --mint:         #DCF5E8;

  --primary:      #4F5BFF;
  --primary-2:    #6B7BFF;
  --primary-dark: #2E38A8;
  --accent:       #FF8A3D;
  --accent-2:     #FF6B1A;
  --accent-soft:  #FFE0C7;

  --navy:         #0B1030;
  --navy-2:       #151A3D;
  --navy-3:       #1E2450;
  --ink:          #12163A;
  --text:         #12163A;
  --text-2:       #4A5170;
  --text-3:       #8A90AA;

  /* Shadow berlapis */
  --shadow-xs: 0 1px 2px rgba(18, 22, 58, 0.04);
  --shadow-sm: 0 2px 8px rgba(18, 22, 58, 0.06), 0 1px 2px rgba(18, 22, 58, 0.04);
  --shadow-md: 0 8px 24px rgba(18, 22, 58, 0.08), 0 2px 6px rgba(18, 22, 58, 0.05);
  --shadow-lg: 0 20px 48px rgba(18, 22, 58, 0.12), 0 4px 12px rgba(18, 22, 58, 0.06);
  --shadow-xl: 0 32px 80px rgba(18, 22, 58, 0.16), 0 8px 24px rgba(18, 22, 58, 0.08);
  --shadow-glow: 0 20px 60px rgba(79, 91, 255, 0.25);
  --shadow-accent: 0 20px 60px rgba(255, 138, 61, 0.3);

  /* Radius */
  --r-sm: 12px;
  --r-md: 20px;
  --r-lg: 28px;
  --r-xl: 40px;
  --r-pill: 999px;

  /* Font */
  --font-sans: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
  --font-serif: 'Instrument Serif', Georgia, serif;

  /* Timing */
  --ease-out: cubic-bezier(0.22, 1, 0.36, 1);
  --ease-soft: cubic-bezier(0.4, 0, 0.2, 1);
}

/* ---------- BASE ---------- */
html { scroll-behavior: smooth; }

body {
  font-family: var(--font-sans);
  background: var(--cream);
  color: var(--text);
  line-height: 1.6;
  overflow-x: hidden;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  position: relative;
}

/* Mesh gradient global di background body — bergerak halus */
body::before {
  content: '';
  position: fixed;
  inset: 0;
  z-index: -2;
  background:
    radial-gradient(ellipse 80% 50% at 10% 0%, rgba(255, 212, 179, 0.5), transparent 60%),
    radial-gradient(ellipse 70% 50% at 90% 10%, rgba(212, 204, 255, 0.5), transparent 60%),
    radial-gradient(ellipse 60% 40% at 50% 100%, rgba(220, 235, 255, 0.6), transparent 60%),
    radial-gradient(ellipse 50% 30% at 20% 80%, rgba(220, 245, 232, 0.5), transparent 60%);
  animation: meshShift 24s ease-in-out infinite;
  pointer-events: none;
}
@keyframes meshShift {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33%      { transform: translate(3%, -2%) scale(1.05); }
  66%      { transform: translate(-2%, 3%) scale(1.02); }
}

/* Noise overlay halus — bikin tidak flat */
body::after {
  content: '';
  position: fixed;
  inset: 0;
  z-index: -1;
  pointer-events: none;
  opacity: 0.035;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
}

a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; border: none; background: none; }
img { max-width: 100%; display: block; }
::selection { background: var(--accent); color: white; }

/* ---------- TYPOGRAPHY ---------- */
h1, h2, h3, h4 {
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.1;
  color: var(--ink);
}

.serif { font-family: var(--font-serif); font-weight: 400; letter-spacing: -0.01em; }

/* =========================================================
   NAVBAR
   ========================================================= */
.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(251, 248, 243, 0.72);
  backdrop-filter: saturate(180%) blur(20px);
  -webkit-backdrop-filter: saturate(180%) blur(20px);
  border-bottom: 1px solid rgba(18, 22, 58, 0.06);
  transition: all 0.3s var(--ease-soft);
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
  position: relative;
  overflow: hidden;
}
.logo-mark::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, transparent 40%, rgba(255,255,255,0.4) 50%, transparent 60%);
  transform: translateX(-100%);
  transition: transform 0.6s var(--ease-out);
}
.logo:hover .logo-mark::after { transform: translateX(100%); }

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
  transition: all 0.25s var(--ease-soft);
  position: relative;
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
  backdrop-filter: blur(10px);
  transition: all 0.25s var(--ease-soft);
}
.btn-logout:hover {
  border-color: var(--primary);
  color: var(--primary);
  background: white;
  transform: translateY(-1px);
  box-shadow: var(--shadow-sm);
}

.hamburger {
  display: none;
  align-items: center;
  justify-content: center;
  padding: 8px;
  color: var(--ink);
  border-radius: 10px;
}
.hamburger:hover { background: rgba(18, 22, 58, 0.06); }

/* =========================================================
   HERO
   ========================================================= */
.hero {
  position: relative;
  padding: 60px 32px 0;
  overflow: hidden;
}
.hero::before {
  content: '';
  position: absolute;
  top: -20%;
  right: -10%;
  width: 700px;
  height: 700px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 212, 179, 0.7), transparent 70%);
  filter: blur(60px);
  animation: floatBlob 18s ease-in-out infinite;
  z-index: 0;
  pointer-events: none;
}
.hero::after {
  content: '';
  position: absolute;
  bottom: -30%;
  left: -15%;
  width: 600px;
  height: 600px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(212, 204, 255, 0.6), transparent 70%);
  filter: blur(60px);
  animation: floatBlob 22s ease-in-out infinite reverse;
  z-index: 0;
  pointer-events: none;
}
@keyframes floatBlob {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50%      { transform: translate(-40px, 30px) scale(1.1); }
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
  backdrop-filter: blur(10px);
  box-shadow: var(--shadow-xs);
}
.hero-tagline::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--accent);
  box-shadow: 0 0 0 4px rgba(255, 138, 61, 0.2);
  animation: pulseDot 2s ease-in-out infinite;
}
@keyframes pulseDot {
  0%, 100% { box-shadow: 0 0 0 4px rgba(255, 138, 61, 0.2); }
  50%      { box-shadow: 0 0 0 8px rgba(255, 138, 61, 0.05); }
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
  background-size: 200% 100%;
  animation: gradientShift 6s ease-in-out infinite;
}
@keyframes gradientShift {
  0%, 100% { background-position: 0% 50%; }
  50%      { background-position: 100% 50%; }
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
  filter: drop-shadow(0 40px 60px rgba(79, 91, 255, 0.25));
  animation: floatImg 5s ease-in-out infinite;
  position: relative;
  z-index: 1;
}
@keyframes floatImg {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50%      { transform: translateY(-16px) rotate(-0.5deg); }
}

/* ---------- SEARCH BAR ---------- */
.search-bar {
  max-width: 760px;
  margin: -32px auto 0;
  padding: 8px;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.9);
  border-radius: var(--r-pill);
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: 8px;
  position: relative;
  z-index: 3;
  transition: box-shadow 0.3s var(--ease-soft);
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
  box-shadow: var(--shadow-accent);
  transition: all 0.3s var(--ease-out);
  position: relative;
  overflow: hidden;
}
.btn-search::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, transparent 40%, rgba(255,255,255,0.35) 50%, transparent 60%);
  transform: translateX(-100%);
  transition: transform 0.7s var(--ease-out);
}
.btn-search:hover {
  transform: translateY(-2px);
  box-shadow: 0 24px 60px rgba(255, 138, 61, 0.45);
}
.btn-search:hover::before { transform: translateX(100%); }
.btn-search:active { transform: translateY(0); }

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
  position: relative;
  overflow: hidden;
  transition: transform 0.4s var(--ease-out), box-shadow 0.4s var(--ease-out);
  box-shadow: var(--shadow-md);
  isolation: isolate;
}
.feature-card::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: conic-gradient(from 0deg, transparent 0%, rgba(79, 91, 255, 0.4) 25%, transparent 50%);
  opacity: 0;
  transition: opacity 0.5s;
  animation: rotate 6s linear infinite;
  z-index: -1;
}
.feature-card:hover::before { opacity: 0.5; }
@keyframes rotate { to { transform: rotate(360deg); } }
.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: var(--shadow-xl), var(--shadow-glow);
}
.feature-card .icon {
  width: 48px;
  height: 48px;
  margin: 0 auto 16px;
  border-radius: 14px;
  background: linear-gradient(135deg, rgba(79, 91, 255, 0.25), rgba(255, 138, 61, 0.15));
  border: 1px solid rgba(255, 255, 255, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  backdrop-filter: blur(10px);
  transition: transform 0.4s var(--ease-out);
}
.feature-card:hover .icon { transform: translateY(-2px) scale(1.05); }
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

/* Info panel (01) */
.info-panel {
  padding: 12px 4px;
}
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
  transition: transform 0.3s var(--ease-out);
}
.step-badge:hover { transform: scale(1.08) rotate(-5deg); }
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
  transition: all 0.3s var(--ease-out);
  position: relative;
  overflow: hidden;
  font-family: inherit;
}

.btn-primary {
  padding: 13px 28px;
  background: linear-gradient(135deg, var(--primary) 0%, var(--primary-2) 100%);
  color: white;
  box-shadow: 0 12px 28px rgba(79, 91, 255, 0.3);
}
.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 45px rgba(79, 91, 255, 0.4);
}

.btn-accent {
  padding: 11px 22px;
  background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 100%);
  color: white;
  box-shadow: 0 10px 24px rgba(255, 138, 61, 0.28);
}
.btn-accent:hover {
  transform: translateY(-2px);
  box-shadow: 0 18px 40px rgba(255, 138, 61, 0.4);
}

.btn-secondary {
  padding: 12px 24px;
  background: rgba(255, 255, 255, 0.7);
  border: 1.5px solid rgba(18, 22, 58, 0.1);
  color: var(--ink);
  backdrop-filter: blur(10px);
}
.btn-secondary:hover {
  border-color: var(--primary);
  color: var(--primary);
  background: white;
  transform: translateY(-2px);
  box-shadow: var(--shadow-sm);
}

/* =========================================================
   SECTION
   ========================================================= */
.section {
  max-width: 1240px;
  margin: 0 auto;
  padding: 100px 32px;
  position: relative;
}
.section-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 24px;
  margin-bottom: 48px;
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
  transition: transform 0.4s var(--ease-out), box-shadow 0.4s var(--ease-out);
  display: flex;
  flex-direction: column;
  position: relative;
  isolation: isolate;
}
.package-card::before {
  content: '';
  position: absolute;
  inset: -1px;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(135deg, rgba(79, 91, 255, 0.3), transparent 40%, transparent 60%, rgba(255, 138, 61, 0.3));
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
          mask-composite: exclude;
  opacity: 0;
  transition: opacity 0.4s;
  pointer-events: none;
  z-index: 2;
}
.package-card:hover::before { opacity: 1; }
.package-card:hover {
  transform: translateY(-8px);
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
.package-image::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 60%, rgba(18, 22, 58, 0.08) 100%);
  pointer-events: none;
}
.package-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.7s var(--ease-out);
}
.package-card:hover .package-image img {
  transform: scale(1.05);
}

.package-rating {
  position: absolute;
  top: 18px;
  right: 18px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
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
  background: linear-gradient(135deg, #4F5BFF 0%, #6B7BFF 40%, #FF8A3D 100%);
  background-size: 200% 200%;
  animation: gradientShift 12s ease-in-out infinite;
  box-shadow: var(--shadow-xl), var(--shadow-glow);
  isolation: isolate;
}
.featured-banner::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    radial-gradient(circle at 20% 20%, rgba(255, 255, 255, 0.15), transparent 40%),
    radial-gradient(circle at 80% 80%, rgba(255, 255, 255, 0.08), transparent 40%);
  pointer-events: none;
  z-index: -1;
}
.featured-banner .step-badge {
  background: rgba(255, 255, 255, 0.18);
  border-color: rgba(255, 255, 255, 0.3);
  color: white;
  backdrop-filter: blur(10px);
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
  transition: all 0.3s var(--ease-soft);
  backdrop-filter: blur(10px);
}
.tab:hover { background: rgba(255, 255, 255, 0.22); }
.tab.active {
  background: white;
  color: var(--primary);
  border-color: white;
  box-shadow: 0 8px 24px rgba(255, 255, 255, 0.3);
}

.featured-bottom {
  background: white;
  border-radius: var(--r-lg) var(--r-lg) 0 0;
  padding: 40px 40px 36px;
  display: grid;
  grid-template-columns: 1.2fr 1fr 64px;
  gap: 36px;
  align-items: center;
  color: var(--text);
  box-shadow: 0 -20px 60px rgba(18, 22, 58, 0.08);
}
.exclusive-img {
  max-height: 240px;
  object-fit: contain;
  margin: 0 auto;
  filter: drop-shadow(0 20px 40px rgba(79, 91, 255, 0.15));
  transition: transform 0.5s var(--ease-out);
}
.exclusive-img:hover { transform: translateY(-6px) scale(1.03); }

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
  color: var(--text);
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
  box-shadow: 0 4px 10px rgba(79, 91, 255, 0.3);
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
  transition: transform 0.4s var(--ease-out), box-shadow 0.4s var(--ease-out);
  position: relative;
  isolation: isolate;
}
.article-card:hover {
  transform: translateY(-8px);
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
  transition: transform 0.8s var(--ease-out);
}
.article-card:hover .article-image img {
  transform: scale(1.06);
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
  backdrop-filter: blur(10px);
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
  filter: blur(20px);
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
  position: relative;
  background: linear-gradient(120deg, var(--accent) 0%, var(--primary) 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}
.newsletter-form {
  max-width: 540px;
  margin: 0 auto;
  padding: 8px;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.9);
  border-radius: var(--r-pill);
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: 8px;
  transition: box-shadow 0.3s var(--ease-soft);
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
.newsletter-form .btn-accent {
  padding: 12px 26px;
}

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
  transition: color 0.25s;
  position: relative;
}
.footer-links a::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 0;
  height: 1.5px;
  background: var(--primary);
  transition: width 0.3s var(--ease-out);
}
.footer-links a:hover { color: var(--primary); }
.footer-links a:hover::after { width: 100%; }

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
  transition: all 0.3s var(--ease-out);
  box-shadow: var(--shadow-xs);
}
.footer-social a:hover {
  background: linear-gradient(135deg, var(--primary), var(--accent));
  color: white;
  transform: translateY(-3px) scale(1.05);
  box-shadow: var(--shadow-glow);
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
  letter-spacing: -0.01em;
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
  transition: all 0.25s var(--ease-soft);
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
   CARD
   ========================================================= */
.card {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.9);
  border-radius: var(--r-lg);
  padding: 32px;
  box-shadow: var(--shadow-md);
}
.card h3 { color: var(--ink); margin-bottom: 12px; }
.card p { color: var(--text-2); font-size: 0.92rem; }

/* =========================================================
   TABLE
   ========================================================= */
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
  letter-spacing: 0.02em;
}
.data-table tr:hover { background: rgba(79, 91, 255, 0.03); }

/* =========================================================
   REVEAL
   ========================================================= */
.reveal {
  opacity: 0;
  transform: translateY(28px);
  transition: opacity 0.8s var(--ease-out), transform 0.8s var(--ease-out);
  will-change: opacity, transform;
}
.reveal.active {
  opacity: 1;
  transform: translateY(0);
}
.no-js .reveal {
  opacity: 1;
  transform: none;
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
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    padding: 16px;
    border-radius: var(--r-md);
    box-shadow: var(--shadow-lg);
    margin: 0;
  }
  .nav-links.open { display: flex; }
  .hamburger { display: inline-flex; }
  .btn-logout span { display: none; }
  .features-row { grid-template-columns: 1fr; padding: 0 20px; }
  .section { padding: 70px 20px; }
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

echo "   ✅ style.css premium ditulis."
echo ""

# =========================================================
# 3. TAMBAH HERO DECOR (blob + sparkle) DI HOME VIEW
# =========================================================
echo "📝 Update HomeView.vue (tambah dekor halus)..."

cat > src/views/public/HomeView.vue << 'EOF'
<template>
  <PublicNavbar />

  <!-- ============ HERO ============ -->
  <section class="hero">
    <div class="hero-inner">
      <div class="hero-text">
        <p class="hero-tagline">#PastiBersih, PastiTerjangkau</p>
        <h1 class="hero-title">
          Cuci Mesin<br>
          <span class="accent">Kinclong.</span>
        </h1>
        <p class="hero-desc">
          Spesialis cuci mesin mobil dengan metode dry-wash dan masking
          elektrikal total. Aman, cepat, bergaransi.
        </p>
      </div>

      <div class="hero-image">
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
      <span class="search-icon">
        <AppIcon name="search" :size="18" />
      </span>
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
  <section class="features-row">
    <div class="feature-card">
      <div class="icon">
        <AppIcon name="location" :size="22" />
      </div>
      <h4>Banyak Pilihan</h4>
      <p>Paket cuci mesin dari reguler hingga showroom.</p>
    </div>
    <div class="feature-card">
      <div class="icon">
        <AppIcon name="calendar" :size="22" />
      </div>
      <h4>Booking Mudah</h4>
      <p>Booking online, konfirmasi cepat via WhatsApp.</p>
    </div>
    <div class="feature-card">
      <div class="icon">
        <AppIcon name="user-check" :size="22" />
      </div>
      <h4>Teknisi Ahli</h4>
      <p>Ditangani teknisi tersertifikasi ruang mesin.</p>
    </div>

    <div class="info-panel">
      <div class="step-badge">01</div>
      <h3>Layanan Kami</h3>
      <p>
        CuciMesin melayani perawatan ruang mesin mobil pribadi hingga showroom
        dengan standar kebersihan premium.
      </p>
      <router-link to="/layanan" class="btn-accent">
        Pelajari
        <AppIcon name="arrow-right" :size="14" />
      </router-link>
    </div>
  </section>

  <!-- ============ SPECIAL PACKAGE 02 ============ -->
  <section class="section">
    <div class="section-head">
      <div class="section-head-left">
        <div class="step-badge">02</div>
        <h2 class="section-title">Paket Spesial</h2>
        <p class="section-sub">
          Pilih paket sesuai kebutuhan kendaraan Anda. Semua paket sudah termasuk
          garansi aman kelistrikan.
        </p>
      </div>
      <router-link to="/layanan" class="btn-accent">
        Lihat Semua
        <AppIcon name="arrow-right" :size="14" />
      </router-link>
    </div>

    <div class="package-grid">
      <article class="package-card">
        <div class="package-image">
          <img :src="IMAGES.packages.grand" alt="Paket Showroom" @error="hideOnError" />
          <div class="package-rating">
            <AppIcon name="star" :size="14" />
            4.9
          </div>
        </div>
        <div class="package-body">
          <div>
            <h4>Paket Spesialis Showroom</h4>
            <p>Rp 450.000 / mobil — Deep cleaning & engine dressing</p>
          </div>
          <router-link to="/booking" class="btn-accent">
            Booking
            <AppIcon name="arrow-right" :size="14" />
          </router-link>
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
    <div class="featured-banner">
      <div class="step-badge">03</div>
      <h2>Dipercaya lebih dari<br>500+ pemilik mobil</h2>

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
          <router-link to="/booking" class="btn-accent">
            Booking
            <AppIcon name="arrow-right" :size="14" />
          </router-link>
        </div>
        <div class="exclusive-vertical">Cuci Mesin Pro</div>
      </div>
    </div>
  </section>

  <!-- ============ ARTICLES 04 ============ -->
  <section class="section" style="padding-top:0">
    <div class="section-head">
      <div class="section-head-left">
        <div class="step-badge">04</div>
        <h2 class="section-title">Artikel & Tips</h2>
      </div>
      <a href="#" class="btn-accent">
        Lihat Semua
        <AppIcon name="arrow-right" :size="14" />
      </a>
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
  <section class="newsletter">
    <h2>
      Mulai sekarang & dapatkan<br>
      <span class="highlight">update promo</span> dari kami
    </h2>
    <form class="newsletter-form" @submit.prevent="subscribe">
      <input type="email" v-model="email" placeholder="Masukkan email Anda" required />
      <button type="submit" class="btn-accent">
        Mulai
        <AppIcon name="arrow-right" :size="14" />
      </button>
    </form>
  </section>

  <!-- ============ FOOTER ============ -->
  <footer class="footer">
    <div class="logo">
      <span class="logo-mark">
        <AppIcon name="droplet" :size="14" :stroke-width="2.2" />
      </span>
      CuciMesin
    </div>
    <div class="footer-links">
      <router-link to="/beranda">Beranda</router-link>
      <router-link to="/layanan">Layanan</router-link>
      <router-link to="/booking">Booking</router-link>
      <router-link to="/status">Status</router-link>
    </div>
    <div class="footer-social">
      <a href="#" aria-label="Instagram"><AppIcon name="camera" :size="16" /></a>
      <a href="#" aria-label="Email"><AppIcon name="mail" :size="16" /></a>
      <a href="#" aria-label="Phone"><AppIcon name="phone" :size="16" /></a>
    </div>
    <small>© 2024 CuciMesin Carwash</small>
  </footer>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import PublicNavbar from '../../components/PublicNavbar.vue'
import AppIcon from '../../components/AppIcon.vue'
import { useReveal } from '../../composables/useReveal'
import { IMAGES } from '../../data/images'

useReveal()

const router = useRouter()
const search = ref('')
const email = ref('')

function doSearch() {
  if (search.value.trim()) router.push('/layanan')
}
function subscribe() {
  alert('Terima kasih! Email ' + email.value + ' sudah terdaftar.')
  email.value = ''
}
function hideOnError(e) { e.target.style.opacity = '0' }
</script>
EOF

echo "   ✅ HomeView.vue diperbarui."
echo ""

# =========================================================
# 4. SELESAI
# =========================================================
echo "========================================================"
echo "PREMIUM UPGRADE SELESAI"
echo "========================================================"
echo ""
echo "Yang berubah:"
echo ""
echo "  Warna & transisi:"
echo "   - Palette: cream -> peach -> lavender -> sky -> mint"
echo "   - Mesh gradient global bergerak halus (24s loop)"
echo "   - Blob dekor di hero (orange + lavender, blur 60px)"
echo "   - Gradient text accent (biru -> orange) dengan animasi"
echo "   - Featured banner gradient 3 warna bergerak"
echo ""
echo "  Material & depth:"
echo "   - Glassmorphism (backdrop-filter blur 20px)"
echo "   - Noise texture halus (opacity 3.5%)"
echo "   - Shadow berlapis (5 level: xs, sm, md, lg, xl)"
echo "   - Gradient border pada hover card"
echo ""
echo "  Micro-interaction:"
echo "   - Logo shine sweep saat hover"
echo "   - Search bar focus ring + glow"
echo "   - Button shine sweep + lift"
echo "   - Card conic-gradient rotate halus"
echo "   - Icon scale + rotate saat hover"
echo "   - Footer link underline animate"
echo "   - Step badge rotate saat hover"
echo ""
echo "  Tipography:"
echo "   - Font Plus Jakarta Sans (modern, mahal)"
echo "   - Letter-spacing negatif di heading (kelas agency)"
echo "   - Line-height rapat untuk hero"
echo ""
echo "▶️  Jalankan: npm run dev"
echo "   Buka: http://localhost:5173"
echo ""
echo "📌 Backup style lama: src/assets/style.backup.css"
echo ""