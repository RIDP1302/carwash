#!/bin/bash
# =========================================================
#  migrate-to-vue.sh
#  Migrasi CuciMesin dari HTML statis → Vue 3 + Vite
# =========================================================

set -e  # Stop kalau ada error

echo "🚗 Mulai migrasi CuciMesin ke Vue 3..."
echo ""

# =========================================================
# 1. HAPUS FILE LAMA
# =========================================================
echo "🗑️  Menghapus file HTML lama..."

# Backup dulu (opsional, kalau mau aman)
if [ ! -d "_backup_html" ]; then
  mkdir -p _backup_html
  cp *.html _backup_html/ 2>/dev/null || true
  echo "   📦 Backup file lama disimpan di ./_backup_html/"
fi

# Hapus file HTML lama
rm -f *.html
rm -f *.css
rm -f *.js
echo "   ✅ File lama dihapus."
echo ""

# =========================================================
# 2. INIT PROJECT VUE 3 + VITE
# =========================================================
echo "📦 Menginisialisasi project Vue 3 + Vite..."

# Buat package.json
cat > package.json << 'EOF'
{
  "name": "cucimesin-app",
  "private": true,
  "version": "2.4.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.21",
    "vue-router": "^4.3.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.4",
    "vite": "^5.2.0"
  }
}
EOF

echo "   ✅ package.json dibuat."
echo ""

# =========================================================
# 3. BUAT STRUKTUR FOLDER
# =========================================================
echo "📁 Membuat struktur folder..."

mkdir -p src/assets
mkdir -p src/components
mkdir -p src/views/public
mkdir -p src/views/admin
mkdir -p src/router
mkdir -p src/composables
mkdir -p public

echo "   ✅ Struktur folder dibuat."
echo ""

# =========================================================
# 4. FILE ROOT: vite.config.js
# =========================================================
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    open: true
  }
})
EOF

# =========================================================
# 5. FILE ROOT: index.html
# =========================================================
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CuciMesin — #PastiBersih, PastiTerjangkau!</title>
</head>
<body>
  <div id="app"></div>
  <script type="module" src="/src/main.js"></script>
</body>
</html>
EOF

# =========================================================
# 6. main.js
# =========================================================
cat > src/main.js << 'EOF'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/style.css'

createApp(App).use(router).mount('#app')
EOF

# =========================================================
# 7. App.vue
# =========================================================
cat > src/App.vue << 'EOF'
<template>
  <div class="app-wrapper">
    <div v-if="loading" class="loader">
      <div class="loader-bubble"></div>
      <p>CuciMesin</p>
    </div>
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const loading = ref(true)

onMounted(() => {
  setTimeout(() => (loading.value = false), 900)
})
</script>

<style scoped>
.app-wrapper { min-height: 100vh; }
.fade-enter-active, .fade-leave-active { transition: opacity 0.35s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
EOF

echo "   ✅ File root Vue dibuat."
echo ""

# =========================================================
# 8. ASSETS: style.css (global + animasi)
# =========================================================
cat > src/assets/style.css << 'EOF'
/* ===== RESET & BASE ===== */
* { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --primary: #00c2ff;
  --primary-dark: #0088b3;
  --accent: #00ffa3;
  --dark: #0a0e1a;
  --dark-2: #131a2b;
  --text: #e6f1ff;
  --muted: #8ba3c7;
  --glow: 0 0 20px rgba(0, 194, 255, 0.5);
}

html { scroll-behavior: smooth; }

body {
  font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  background: var(--dark);
  color: var(--text);
  overflow-x: hidden;
  line-height: 1.6;
}

a { color: inherit; text-decoration: none; }
button { font-family: inherit; cursor: pointer; }

/* ===== LOADER ===== */
.loader {
  position: fixed;
  inset: 0;
  background: var(--dark);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}
.loader-bubble {
  width: 60px; height: 60px;
  border-radius: 50%;
  background: radial-gradient(circle at 30% 30%, var(--accent), var(--primary));
  animation: bubble 1.2s ease-in-out infinite;
  box-shadow: var(--glow);
}
.loader p {
  margin-top: 20px;
  letter-spacing: 4px;
  font-weight: 600;
  color: var(--primary);
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
  background: rgba(10, 14, 26, 0.75);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(0, 194, 255, 0.15);
}
.nav-container {
  max-width: 1200px; margin: 0 auto;
  padding: 14px 24px;
  display: flex; align-items: center; justify-content: space-between;
  gap: 20px;
}
.logo {
  font-weight: 700; font-size: 1.3rem;
  color: var(--text);
  text-shadow: var(--glow);
  transition: transform 0.3s;
}
.logo:hover { transform: scale(1.05); }
.nav-links { display: flex; list-style: none; gap: 8px; }
.nav-links a {
  color: var(--muted);
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 0.95rem;
  position: relative;
  transition: color 0.3s;
}
.nav-links a::after {
  content: '';
  position: absolute; left: 50%; bottom: 4px;
  width: 0; height: 2px;
  background: linear-gradient(90deg, var(--primary), var(--accent));
  transform: translateX(-50%);
  transition: width 0.3s;
}
.nav-links a:hover, .nav-links a.active { color: var(--text); }
.nav-links a:hover::after, .nav-links a.active::after { width: 60%; }

.btn-logout {
  padding: 8px 20px;
  border-radius: 8px;
  border: 1px solid var(--primary);
  color: var(--primary);
  background: transparent;
  font-size: 0.9rem;
  transition: all 0.3s;
}
.btn-logout:hover {
  background: var(--primary);
  color: var(--dark);
  box-shadow: var(--glow);
}

/* ===== HERO ===== */
.hero {
  position: relative;
  min-height: 90vh;
  display: flex; align-items: center; justify-content: center;
  overflow: hidden; padding: 60px 24px;
}
.hero-bg {
  position: absolute; inset: -50%;
  background:
    radial-gradient(circle at 20% 30%, rgba(0, 194, 255, 0.35), transparent 45%),
    radial-gradient(circle at 80% 70%, rgba(0, 255, 163, 0.25), transparent 45%),
    radial-gradient(circle at 50% 50%, rgba(120, 0, 255, 0.2), transparent 60%);
  animation: floatBg 12s ease-in-out infinite alternate;
  z-index: 0;
}
@keyframes floatBg {
  0% { transform: translate(0, 0) rotate(0deg); }
  100% { transform: translate(-4%, -4%) rotate(8deg); }
}
.hero-content { position: relative; z-index: 1; max-width: 800px; text-align: center; }
.hero-title {
  font-size: clamp(2rem, 5vw, 3.5rem);
  font-weight: 800; margin-bottom: 12px;
  background: linear-gradient(90deg, #fff, var(--primary), var(--accent), #fff);
  background-size: 300% 100%;
  -webkit-background-clip: text; background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: shine 5s linear infinite;
}
@keyframes shine {
  0% { background-position: 0% 50%; }
  100% { background-position: 300% 50%; }
}
.tagline { color: var(--accent); font-size: 1.15rem; margin-bottom: 20px; }
.hero-desc { color: var(--muted); margin-bottom: 12px; font-size: 1rem; }

/* ===== BUTTON ===== */
.btn-primary {
  display: inline-flex; align-items: center; gap: 10px;
  margin-top: 28px; padding: 14px 32px;
  border-radius: 50px;
  background: linear-gradient(135deg, var(--primary), var(--accent));
  color: var(--dark); font-weight: 700;
  position: relative; overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 194, 255, 0.4);
  transition: transform 0.3s, box-shadow 0.3s;
  border: none;
}
.btn-primary:hover {
  transform: translateY(-4px) scale(1.03);
  box-shadow: 0 15px 40px rgba(0, 255, 163, 0.6);
}
.btn-secondary {
  padding: 10px 24px; border-radius: 10px;
  border: 1px solid var(--primary);
  background: transparent; color: var(--primary);
  transition: 0.3s;
}
.btn-secondary:hover { background: var(--primary); color: var(--dark); }

/* ===== SECTION ===== */
.section {
  max-width: 1100px; margin: 0 auto;
  padding: 80px 24px;
}
.section-title {
  font-size: clamp(1.5rem, 3vw, 2.2rem);
  margin-bottom: 12px; text-align: center;
  background: linear-gradient(90deg, var(--primary), var(--accent));
  -webkit-background-clip: text; background-clip: text;
  -webkit-text-fill-color: transparent;
}
.section-sub { text-align: center; color: var(--muted); margin-bottom: 48px; }

/* ===== CARDS ===== */
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 24px;
}
.card {
  background: linear-gradient(145deg, var(--dark-2), rgba(19, 26, 43, 0.5));
  border: 1px solid rgba(0, 194, 255, 0.15);
  border-radius: 18px; padding: 32px 24px;
  transition: transform 0.4s, box-shadow 0.4s, border-color 0.4s;
}
.card:hover {
  transform: translateY(-8px);
  border-color: var(--primary);
  box-shadow: 0 20px 45px rgba(0, 194, 255, 0.25);
}
.card-icon {
  font-size: 2.5rem; margin-bottom: 16px;
  display: inline-block;
  animation: bounce 2.5s ease-in-out infinite;
}
@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}
.card h3 { color: var(--text); margin-bottom: 10px; font-size: 1.15rem; }
.card p { color: var(--muted); font-size: 0.95rem; }

/* ===== TABLE ===== */
.data-table {
  width: 100%; border-collapse: collapse;
  background: var(--dark-2); border-radius: 12px; overflow: hidden;
}
.data-table th, .data-table td {
  padding: 14px 16px; text-align: left;
  border-bottom: 1px solid rgba(0, 194, 255, 0.1);
}
.data-table th {
  background: rgba(0, 194, 255, 0.08);
  color: var(--primary); font-weight: 600;
}
.data-table tr:hover { background: rgba(0, 194, 255, 0.04); }

/* ===== FORM ===== */
.form-group { margin-bottom: 16px; }
.form-group label {
  display: block; margin-bottom: 6px;
  color: var(--muted); font-size: 0.9rem;
}
.form-group input,
.form-group select,
.form-group textarea {
  width: 100%; padding: 12px 14px;
  background: var(--dark-2);
  border: 1px solid rgba(0, 194, 255, 0.2);
  border-radius: 10px;
  color: var(--text);
  font-size: 0.95rem;
  transition: border-color 0.3s, box-shadow 0.3s;
}
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(0, 194, 255, 0.15);
}

/* ===== FOOTER ===== */
.footer {
  text-align: center; padding: 30px 24px;
  border-top: 1px solid rgba(0, 194, 255, 0.15);
  color: var(--muted);
}

/* ===== REVEAL ===== */
.reveal {
  opacity: 0; transform: translateY(40px);
  transition: opacity 0.8s ease, transform 0.8s ease;
}
.reveal.active { opacity: 1; transform: translateY(0); }

/* ===== RESPONSIVE ===== */
@media (max-width: 768px) {
  .nav-links {
    position: absolute;
    top: 100%; right: 0;
    flex-direction: column;
    background: rgba(10, 14, 26, 0.98);
    padding: 20px; border-radius: 0 0 16px 16px;
    border: 1px solid rgba(0, 194, 255, 0.2);
    min-width: 200px;
  }
}
EOF

echo "   ✅ style.css dibuat."
echo ""

# =========================================================
# 9. ROUTER
# =========================================================
cat > src/router/index.js << 'EOF'
import { createRouter, createWebHistory } from 'vue-router'

// Public
import HomeView from '../views/public/HomeView.vue'
import LayananView from '../views/public/LayananView.vue'
import BookingView from '../views/public/BookingView.vue'
import StatusView from '../views/public/StatusView.vue'
import ProfilView from '../views/public/ProfilView.vue'
import LoginView from '../views/public/LoginView.vue'
import DaftarView from '../views/public/DaftarView.vue'

// Admin
import DashboardView from '../views/admin/DashboardView.vue'
import OrderView from '../views/admin/OrderView.vue'
import OrderBaruView from '../views/admin/OrderBaruView.vue'
import OrderDetailView from '../views/admin/OrderDetailView.vue'
import PelangganView from '../views/admin/PelangganView.vue'
import PelangganFormView from '../views/admin/PelangganFormView.vue'
import TeknisiView from '../views/admin/TeknisiView.vue'
import TeknisiTugasView from '../views/admin/TeknisiTugasView.vue'
import TeknisiDetailView from '../views/admin/TeknisiDetailView.vue'
import LaporanView from '../views/admin/LaporanView.vue'
import KeuanganView from '../views/admin/KeuanganView.vue'
import PengaturanView from '../views/admin/PengaturanView.vue'

const routes = [
  // ===== PUBLIC =====
  { path: '/', redirect: '/login' },
  { path: '/login', name: 'login', component: LoginView },
  { path: '/daftar', name: 'daftar', component: DaftarView },
  { path: '/beranda', name: 'beranda', component: HomeView },
  { path: '/layanan', name: 'layanan', component: LayananView },
  { path: '/booking', name: 'booking', component: BookingView },
  { path: '/status', name: 'status', component: StatusView },
  { path: '/profil', name: 'profil', component: ProfilView },

  // ===== ADMIN =====
  { path: '/admin/dashboard', name: 'dashboard', component: DashboardView },
  { path: '/admin/order', name: 'order', component: OrderView },
  { path: '/admin/order/baru', name: 'order-baru', component: OrderBaruView },
  { path: '/admin/order/:id', name: 'order-detail', component: OrderDetailView },
  { path: '/admin/pelanggan', name: 'pelanggan', component: PelangganView },
  { path: '/admin/pelanggan/form', name: 'pelanggan-form', component: PelangganFormView },
  { path: '/admin/teknisi', name: 'teknisi', component: TeknisiView },
  { path: '/admin/teknisi/tugas', name: 'teknisi-tugas', component: TeknisiTugasView },
  { path: '/admin/teknisi/detail', name: 'teknisi-detail', component: TeknisiDetailView },
  { path: '/admin/laporan', name: 'laporan', component: LaporanView },
  { path: '/admin/keuangan', name: 'keuangan', component: KeuanganView },
  { path: '/admin/pengaturan', name: 'pengaturan', component: PengaturanView },

  { path: '/:pathMatch(.*)*', redirect: '/login' }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
EOF

echo "   ✅ Router dibuat."
echo ""

# =========================================================
# 10. COMPONENTS: Navbar.vue (Public)
# =========================================================
cat > src/components/PublicNavbar.vue << 'EOF'
<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/beranda" class="logo">💧 CuciMesin</router-link>
      <nav>
        <ul class="nav-links">
          <li><router-link to="/beranda">Beranda</router-link></li>
          <li><router-link to="/layanan">Layanan</router-link></li>
          <li><router-link to="/booking">Booking Online</router-link></li>
          <li><router-link to="/status">Status</router-link></li>
          <li><router-link to="/profil">Profil</router-link></li>
        </ul>
      </nav>
      <router-link to="/login" class="btn-logout">Logout</router-link>
    </div>
  </header>
</template>

<script setup>
</script>
EOF

# =========================================================
# 11. COMPONENTS: AdminNavbar.vue
# =========================================================
cat > src/components/AdminNavbar.vue << 'EOF'
<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/admin/dashboard" class="logo">⚙️ Admin CuciMesin</router-link>
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
      <router-link to="/login" class="btn-logout">Keluar</router-link>
    </div>
  </header>
</template>

<script setup>
</script>
EOF

# =========================================================
# 12. COMPOSABLES: useReveal.js
# =========================================================
cat > src/composables/useReveal.js << 'EOF'
import { onMounted } from 'vue'

export function useReveal() {
  onMounted(() => {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) entry.target.classList.add('active')
      })
    }, { threshold: 0.15 })

    document.querySelectorAll('.reveal').forEach((el) => observer.observe(el))
  })
}
EOF

echo "   ✅ Components & composables dibuat."
echo ""

# =========================================================
# 13. VIEWS PUBLIC
# =========================================================

# HomeView
cat > src/views/public/HomeView.vue << 'EOF'
<template>
  <PublicNavbar />
  <section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-content reveal">
      <h1 class="hero-title">CuciMesin Carwash</h1>
      <p class="tagline"><strong>#PastiBersih, PastiTerjangkau!</strong></p>
      <p class="hero-desc">Spesialis cuci mesin mobil — aman, cepat, bergaransi.</p>
      <p class="hero-desc">
        Mengembalikan performa dan estetika ruang mesin kendaraan Anda dengan
        metode kering (dry-wash) dan masking elektrikal total.
      </p>
      <router-link to="/booking" class="btn-primary">Booking Sekarang →</router-link>
    </div>
  </section>

  <section class="section reveal">
    <h2 class="section-title">Mengapa Memilih CuciMesin?</h2>
    <p class="section-sub">Standar pelayanan showroom kini hadir untuk kendaraan pribadi Anda.</p>
    <div class="cards">
      <div class="card" v-for="f in features" :key="f.title">
        <div class="card-icon">{{ f.icon }}</div>
        <h3>{{ f.title }}</h3>
        <p>{{ f.desc }}</p>
      </div>
    </div>
  </section>

  <section class="section reveal">
    <h2 class="section-title">Tentang Kami</h2>
    <p style="text-align:center;color:var(--muted)">
      CuciMesin spesialis cuci mesin mobil dengan metode <strong>dry-wash</strong> dan
      <strong>masking elektrikal total</strong>. Berpusat di Tuban, sudah menangani
      <strong>500+ mesin</strong>, bekerja sama dengan <strong>15+ mitra showroom</strong>,
      dengan <strong>0% insiden kerusakan kelistrikan</strong>.
    </p>
  </section>

  <section class="section reveal">
    <h2 class="section-title">Kontak</h2>
    <div class="cards">
      <div class="card"><h3>📍 Alamat</h3><p>Jl. Letda Sucipto, Tuban, Jawa Timur</p></div>
      <div class="card"><h3>📱 WhatsApp</h3><p>0812-3456-7890</p></div>
      <div class="card"><h3>✉️ Email</h3><p>cs@cucimesin.id</p></div>
    </div>
  </section>

  <footer class="footer">
    <small>CuciMesin Carwash © 2024 — Engine Wash Specialist v2.4</small>
  </footer>
</template>

<script setup>
import PublicNavbar from '../../components/PublicNavbar.vue'
import { useReveal } from '../../composables/useReveal'

useReveal()

const features = [
  { icon: '🛡️', title: 'Garansi Aman 100%', desc: 'Teknik masking elektrikal ketat pada ECU, alternator, dan kabel busi.' },
  { icon: '🧪', title: 'Chemical Khusus Mesin', desc: 'Engine degreaser & dresser premium, tanpa merusak karet atau selang.' },
  { icon: '👨‍🔧', title: 'Teknisi Tersertifikasi', desc: 'Spesialis ruang mesin mobil Asia hingga Eropa.' }
]
</script>
EOF

# LayananView
cat > src/views/public/LayananView.vue << 'EOF'
<template>
  <PublicNavbar />
  <section class="section">
    <h1 class="section-title">Solusi Detailing Sesuai Kebutuhan Anda</h1>
    <p class="section-sub">Transparan, tanpa biaya tersembunyi. Semua paket bergaransi.</p>
    <div class="cards">
      <div class="card" v-for="p in paket" :key="p.nama">
        <h3>{{ p.nama }}</h3>
        <p style="color:var(--accent);font-size:1.2rem;margin:8px 0">{{ p.harga }}</p>
        <p>{{ p.desc }}</p>
        <ul style="margin:14px 0;color:var(--muted);padding-left:20px">
          <li v-for="f in p.fitur" :key="f">{{ f }}</li>
        </ul>
        <router-link to="/booking" class="btn-secondary">Pilih Paket</router-link>
      </div>
    </div>
  </section>
</template>

<script setup>
import PublicNavbar from '../../components/PublicNavbar.vue'

const paket = [
  { nama: 'Spesialis Showroom', harga: 'Rp 450k', desc: 'Restorasi nilai jual untuk B2B/Showroom.', fitur: ['Semua fitur Reguler Wash', 'Deep cleaning kerak oli', 'Engine dressing premium', 'Sertifikat garansi digital'] },
  { nama: 'Reguler Wash', harga: 'Rp 250k', desc: 'Perawatan harian kendaraan pribadi.', fitur: ['Masking sensor & ECU', 'Cuci kering (Dry-wash)', 'Pembersihan debu & oli'] },
  { nama: 'Ultimate Detail', harga: 'Rp 850k', desc: 'Paket sultan untuk Car Enthusiast.', fitur: ['Semua fitur Showroom', 'Pembersihan total', 'Coating blok mesin'] }
]
</script>
EOF

# BookingView
cat > src/views/public/BookingView.vue << 'EOF'
<template>
  <PublicNavbar />
  <section class="section" style="max-width:700px">
    <h1 class="section-title">Booking Cuci Mesin Online</h1>
    <p class="section-sub">Isi data di bawah untuk melakukan booking.</p>

    <form @submit.prevent="submit" class="card">
      <div class="form-group">
        <label>Nama Lengkap / Instansi</label>
        <input v-model="form.nama" required />
      </div>
      <div class="form-group">
        <label>No. WhatsApp</label>
        <input type="tel" v-model="form.wa" required />
      </div>
      <div class="form-group">
        <label>Email</label>
        <input type="email" v-model="form.email" />
      </div>
      <div class="form-group">
        <label>Nomor Plat</label>
        <input v-model="form.plat" required />
      </div>
      <div class="form-group">
        <label>Merk & Tipe Mobil</label>
        <input v-model="form.tipe" required />
      </div>
      <div class="form-group">
        <label>Pilih Layanan</label>
        <select v-model="form.layanan" required>
          <option value="">-- Pilih Paket --</option>
          <option>Cuci Mesin Standard - Rp 95.000</option>
          <option>Cuci Mesin Premium - Rp 150.000</option>
          <option>Cuci Mesin + Detailing - Rp 350.000</option>
        </select>
      </div>
      <div class="form-group">
        <label>Tanggal</label>
        <input type="date" v-model="form.tanggal" required />
      </div>
      <div class="form-group">
        <label>Jam</label>
        <input type="time" v-model="form.jam" required />
      </div>
      <div class="form-group">
        <label>Catatan Tambahan</label>
        <textarea v-model="form.catatan" rows="3"></textarea>
      </div>
      <button type="submit" class="btn-primary" style="width:100%">BOOKING SEKARANG</button>
    </form>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import PublicNavbar from '../../components/PublicNavbar.vue'

const router = useRouter()
const form = reactive({
  nama: '', wa: '', email: '', plat: '', tipe: '',
  layanan: '', tanggal: '', jam: '', catatan: ''
})

function submit() {
  alert('✅ Booking berhasil!\n\nTerima kasih, ' + form.nama + '.')
  router.push('/status')
}
</script>
EOF

# StatusView
cat > src/views/public/StatusView.vue << 'EOF'
<template>
  <PublicNavbar />
  <section class="section">
    <h1 class="section-title">Status Order Saya</h1>
    <p class="section-sub">Pantau status cuci mobil Anda secara real-time.</p>

    <h2 style="margin:30px 0 16px">📋 Sedang Dikerjakan</h2>
    <div class="card" v-if="aktif">
      <h3>{{ aktif.plat }} — {{ aktif.tipe }}</h3>
      <p>Status: <strong style="color:var(--accent)">{{ aktif.status }}</strong></p>
    </div>
    <p v-else style="color:var(--muted)"><em>Belum ada cuci yang sedang dikerjakan.</em></p>

    <h2 style="margin:30px 0 16px">📜 Riwayat Order</h2>
    <table class="data-table" v-if="riwayat.length">
      <thead><tr><th>Tanggal</th><th>Plat</th><th>Layanan</th><th>Status</th></tr></thead>
      <tbody>
        <tr v-for="r in riwayat" :key="r.id">
          <td>{{ r.tanggal }}</td><td>{{ r.plat }}</td><td>{{ r.layanan }}</td><td>{{ r.status }}</td>
        </tr>
      </tbody>
    </table>
    <p v-else style="color:var(--muted)"><em>Belum ada riwayat order.</em></p>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import PublicNavbar from '../../components/PublicNavbar.vue'

const aktif = ref(null)
const riwayat = ref([])
</script>
EOF

# ProfilView
cat > src/views/public/ProfilView.vue << 'EOF'
<template>
  <PublicNavbar />
  <section class="section" style="max-width:700px">
    <h1 class="section-title">Profil Saya</h1>
    <div class="card">
      <p>Nama: <strong>—</strong></p>
      <p>WhatsApp: <strong>—</strong></p>
      <p>Email: <strong>—</strong></p>
      <p>Kategori: <strong>Normal</strong></p>
    </div>

    <h2 style="margin:30px 0 16px">Ubah Password</h2>
    <form @submit.prevent="ubah" class="card">
      <div class="form-group"><label>Password Lama</label><input type="password" v-model="oldPass" required /></div>
      <div class="form-group"><label>Password Baru</label><input type="password" v-model="newPass" required /></div>
      <div class="form-group"><label>Konfirmasi Password</label><input type="password" v-model="confirm" required /></div>
      <button type="submit" class="btn-primary">Simpan Password</button>
    </form>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import PublicNavbar from '../../components/PublicNavbar.vue'

const oldPass = ref(''), newPass = ref(''), confirm = ref('')
function ubah() {
  if (newPass.value !== confirm.value) return alert('❌ Password tidak sama!')
  alert('✅ Password berhasil diubah!')
}
</script>
EOF

# LoginView
cat > src/views/public/LoginView.vue << 'EOF'
<template>
  <section class="hero" style="min-height:100vh">
    <div class="hero-bg"></div>
    <div class="hero-content reveal" style="max-width:420px">
      <h1 class="hero-title" style="font-size:2.2rem">#CuciMesin</h1>
      <p class="tagline"><strong>#PASTIBERSIH, PASTITERJANGKAU!</strong></p>

      <form @submit.prevent="login" class="card" style="margin-top:24px;text-align:left">
        <h2 style="margin-bottom:20px;text-align:center">Masuk Aplikasi</h2>
        <div class="form-group">
          <label>Nomor Handphone</label>
          <input type="tel" v-model="wa" placeholder="081234567890" required />
        </div>
        <div class="form-group">
          <label>Password</label>
          <input type="password" v-model="password" required />
        </div>
        <button type="submit" class="btn-primary" style="width:100%">Masuk Aplikasi</button>
        <p style="text-align:center;margin-top:16px;color:var(--muted)">
          Belum punya akun? <router-link to="/daftar" style="color:var(--primary)">Daftar</router-link>
        </p>
      </form>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useReveal } from '../../composables/useReveal'

useReveal()

const router = useRouter()
const wa = ref(''), password = ref('')

function login() {
  // Simulasi login: kalau username mengandung "admin" → ke dashboard
  if (wa.value.toLowerCase().includes('admin')) {
    router.push('/admin/dashboard')
  } else {
    router.push('/beranda')
  }
}
</script>
EOF

# DaftarView
cat > src/views/public/DaftarView.vue << 'EOF'
<template>
  <section class="section" style="max-width:500px">
    <h1 class="section-title">Daftar Akun Baru</h1>
    <form @submit.prevent="daftar" class="card">
      <div class="form-group"><label>Nama Lengkap</label><input v-model="nama" required /></div>
      <div class="form-group"><label>Nomor WhatsApp</label><input type="tel" v-model="wa" required /></div>
      <div class="form-group"><label>Kata Sandi</label><input type="password" v-model="pass" required /></div>
      <div class="form-group"><label>Konfirmasi Kata Sandi</label><input type="password" v-model="pass2" required /></div>
      <label style="display:flex;gap:8px;color:var(--muted);margin-bottom:16px">
        <input type="checkbox" v-model="setuju" required /> Saya setuju dengan S&K.
      </label>
      <button type="submit" class="btn-primary" style="width:100%">Buat Akun</button>
      <p style="text-align:center;margin-top:16px;color:var(--muted)">
        Sudah punya akun? <router-link to="/login" style="color:var(--primary)">Masuk</router-link>
      </p>
    </form>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const nama = ref(''), wa = ref(''), pass = ref(''), pass2 = ref(''), setuju = ref(false)

function daftar() {
  if (pass.value !== pass2.value) return alert('❌ Password tidak sama!')
  alert('✅ Akun berhasil dibuat!')
  router.push('/login')
}
</script>
EOF

echo "   ✅ Views Public dibuat."
echo ""

# =========================================================
# 14. VIEWS ADMIN
# =========================================================

# DashboardView
cat > src/views/admin/DashboardView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Dashboard Utama</h1>
    <p class="section-sub">Ikhtisar performa CuciMesin Carwash hari ini.</p>

    <p>Selamat datang, <strong style="color:var(--accent)">Admin</strong></p>

    <div class="cards" style="margin-top:30px">
      <div class="card"><h3>Total Order</h3><p style="font-size:2rem;color:var(--primary)">0 SPK</p></div>
      <div class="card"><h3>Dalam Pengerjaan</h3><p style="font-size:2rem;color:var(--primary)">0 Unit</p></div>
      <div class="card"><h3>Selesai Hari Ini</h3><p style="font-size:2rem;color:var(--accent)">0 Unit</p></div>
      <div class="card"><h3>Revenue Hari Ini</h3><p style="font-size:2rem;color:var(--accent)">Rp 0</p></div>
    </div>

    <h2 style="margin:40px 0 16px">Antrian & Live SPK</h2>
    <p style="color:var(--muted)"><em>Belum ada order hari ini.</em></p>

    <router-link to="/admin/order/baru" class="btn-primary" style="margin-top:20px">
      + Buat SPK Baru
    </router-link>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# OrderView
cat > src/views/admin/OrderView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Manajemen Order & SPK</h1>
    <p class="section-sub">Buat, cetak, dan pantau Surat Perintah Kerja.</p>

    <div class="card" style="display:flex;gap:16px;flex-wrap:wrap;align-items:end">
      <div class="form-group" style="flex:1;min-width:150px">
        <label>Tanggal</label><input type="date" v-model="filter.tanggal" />
      </div>
      <div class="form-group" style="flex:1;min-width:150px">
        <label>Status</label>
        <select v-model="filter.status">
          <option>Semua Status</option><option>Menunggu</option>
          <option>Dikerjakan</option><option>Selesai</option>
        </select>
      </div>
      <div class="form-group" style="flex:1;min-width:150px">
        <label>Kategori</label>
        <select v-model="filter.kategori">
          <option>Semua Kategori</option><option>Normal</option><option>Member B2B</option>
        </select>
      </div>
      <router-link to="/admin/order/baru" class="btn-primary" style="margin-bottom:16px">+ SPK Baru</router-link>
    </div>

    <p style="color:var(--muted);margin-top:30px"><em>Belum ada SPK. Klik "+ SPK Baru" untuk membuat order pertama.</em></p>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import AdminNavbar from '../../components/AdminNavbar.vue'

const filter = reactive({ tanggal: '', status: 'Semua Status', kategori: 'Semua Kategori' })
</script>
EOF

# OrderBaruView
cat > src/views/admin/OrderBaruView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/order" style="color:var(--primary)">← Kembali ke Order</router-link>
    <h1 class="section-title" style="margin-top:16px">Buat SPK Baru</h1>

    <form @submit.prevent="simpan" class="card">
      <h2 style="margin-bottom:16px">1. Data Pelanggan</h2>
      <div class="form-group"><label>Nama Pelanggan</label><input v-model="form.nama" required /></div>
      <div class="form-group"><label>Nomor WhatsApp</label><input type="tel" v-model="form.wa" required /></div>
      <div class="form-group">
        <label>Kategori Member</label>
        <select v-model="form.kategori"><option>Normal</option><option>Member B2B</option></select>
      </div>

      <h2 style="margin:24px 0 16px">2. Detail Kendaraan</h2>
      <div class="form-group"><label>Plat Nomor</label><input v-model="form.plat" required /></div>
      <div class="form-group"><label>Merk / Tipe</label><input v-model="form.tipe" required /></div>

      <h2 style="margin:24px 0 16px">3. Layanan & Penugasan</h2>
      <div class="form-group">
        <label>Paket Layanan</label>
        <select v-model="form.layanan">
          <option>Cuci Mesin Standard — Rp 95.000</option>
          <option>Cuci Mesin Premium — Rp 150.000</option>
          <option>Engine Detailing — Rp 350.000</option>
        </select>
      </div>
      <div class="form-group">
        <label>Tugaskan Teknisi</label>
        <select v-model="form.teknisi">
          <option>Dedi Setiadi</option><option>Ahmad Subarjo</option><option>Rian Hidayat</option>
        </select>
      </div>

      <p style="margin:20px 0">Total: <strong style="color:var(--accent)">Rp 0</strong></p>

      <div style="display:flex;gap:12px">
        <router-link to="/admin/order" class="btn-secondary">Batal</router-link>
        <button type="submit" class="btn-primary">Simpan & Buat SPK</button>
      </div>
    </form>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavbar from '../../components/AdminNavbar.vue'

const router = useRouter()
const form = reactive({ nama: '', wa: '', kategori: 'Normal', plat: '', tipe: '', layanan: '', teknisi: '' })

function simpan() {
  alert('✅ SPK berhasil dibuat!')
  router.push('/admin/order')
}
</script>
EOF

# OrderDetailView
cat > src/views/admin/OrderDetailView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/order" style="color:var(--primary)">← Kembali ke Order</router-link>
    <h1 class="section-title" style="margin-top:16px">SPK-XXXXXX</h1>

    <div class="card">
      <h2>Info Pelanggan</h2>
      <p style="color:var(--muted)">Data pelanggan dimuat dari database.</p>

      <h2 style="margin-top:20px">Detail Kendaraan</h2>
      <p style="color:var(--muted)">Data kendaraan dimuat dari database.</p>

      <h2 style="margin-top:20px">Checklist Teknisi</h2>
      <ul style="list-style:none;color:var(--muted)">
        <li><label><input type="checkbox"> Masking ECU & Kabel Elektrikal</label></li>
        <li><label><input type="checkbox"> Cek Kondisi Aki & Alternator</label></li>
        <li><label><input type="checkbox"> Penyemprotan Chemical Khusus</label></li>
        <li><label><input type="checkbox"> Bilas & Pengeringan Detail</label></li>
      </ul>

      <div style="display:flex;gap:12px;margin-top:20px;flex-wrap:wrap">
        <button class="btn-secondary">Cetak SPK</button>
        <button class="btn-secondary">Kirim Invoice</button>
        <router-link to="/admin/teknisi/detail" class="btn-primary">Proses Teknisi →</router-link>
      </div>
    </div>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# PelangganView
cat > src/views/admin/PelangganView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Daftar Pelanggan</h1>
    <p class="section-sub">Kelola data pelanggan CuciMesin.</p>
    <router-link to="/admin/pelanggan/form" class="btn-primary">+ Pelanggan Baru</router-link>

    <p style="color:var(--muted);margin-top:30px"><em>Belum ada pelanggan terdaftar.</em></p>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# PelangganFormView
cat > src/views/admin/PelangganFormView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/pelanggan" style="color:var(--primary)">← Kembali</router-link>
    <h1 class="section-title" style="margin-top:16px">Informasi Pelanggan</h1>

    <form @submit.prevent="simpan" class="card">
      <div class="form-group"><label>Nama</label><input v-model="form.nama" required /></div>
      <div class="form-group"><label>WhatsApp</label><input type="tel" v-model="form.wa" required /></div>
      <div class="form-group"><label>Kategori</label>
        <select v-model="form.kategori"><option>Normal</option><option>Member B2B</option></select>
      </div>
      <div class="form-group"><label>Plat</label><input v-model="form.plat" /></div>
      <div class="form-group"><label>Tipe</label><input v-model="form.tipe" /></div>
      <div style="display:flex;gap:12px;margin-top:20px">
        <router-link to="/admin/pelanggan" class="btn-secondary">Batal</router-link>
        <button type="submit" class="btn-primary">Simpan</button>
      </div>
    </form>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavbar from '../../components/AdminNavbar.vue'

const router = useRouter()
const form = reactive({ nama: '', wa: '', kategori: 'Normal', plat: '', tipe: '' })

function simpan() {
  alert('✅ Data pelanggan disimpan!')
  router.push('/admin/pelanggan')
}
</script>
EOF

# TeknisiView
cat > src/views/admin/TeknisiView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Status Teknisi & SPK</h1>

    <div class="cards">
      <div class="card"><h3>Teknisi Aktif</h3><p style="font-size:2rem;color:var(--primary)">0 Orang</p></div>
      <div class="card"><h3>Rata-rata Pengerjaan</h3><p style="font-size:2rem;color:var(--accent)">0 Menit</p></div>
    </div>

    <p style="color:var(--muted);margin-top:30px"><em>Belum ada teknisi terdaftar.</em></p>

    <router-link to="/admin/teknisi/tugas" class="btn-primary" style="margin-top:20px">Lihat Tugas Saya →</router-link>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# TeknisiTugasView
cat > src/views/admin/TeknisiTugasView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Tugas Saya</h1>
    <p class="section-sub">Halo <strong style="color:var(--accent)">Teknisi</strong>, berikut tugas cuci hari ini.</p>

    <h2 style="margin:30px 0 16px">🕐 Menunggu Dikerjakan</h2>
    <p style="color:var(--muted)"><em>Belum ada tugas menunggu.</em></p>

    <h2 style="margin:30px 0 16px">✅ Selesai Hari Ini</h2>
    <p style="color:var(--muted)"><em>Belum ada tugas selesai.</em></p>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# TeknisiDetailView
cat > src/views/admin/TeknisiDetailView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/teknisi/tugas" style="color:var(--primary)">← Kembali</router-link>
    <h1 class="section-title" style="margin-top:16px">SPK-XXXXXX</h1>

    <div class="card">
      <h2>📋 Checklist Pengerjaan</h2>
      <ul style="list-style:none;color:var(--muted);margin-top:12px">
        <li><label><input type="checkbox"> Masking ECU & Kabel Elektrikal</label></li>
        <li><label><input type="checkbox"> Cek Kondisi Aki & Alternator</label></li>
        <li><label><input type="checkbox"> Penyemprotan Chemical Khusus</label></li>
        <li><label><input type="checkbox"> Bilas & Pengeringan Detail</label></li>
      </ul>

      <h2 style="margin-top:24px">⏱️ Durasi</h2>
      <p><strong style="color:var(--accent)">00:00:00</strong></p>

      <router-link to="/admin/teknisi/tugas" class="btn-primary" style="margin-top:20px">Selesai Pengerjaan ✓</router-link>
    </div>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# LaporanView
cat > src/views/admin/LaporanView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Laporan Kinerja</h1>
    <p class="section-sub">Pantau performa bisnis CuciMesin.</p>

    <button class="btn-secondary">Bulan Ini</button>

    <h2 style="margin:30px 0 16px">Tren Antrean Harian</h2>
    <p style="color:var(--muted)"><em>Belum ada data.</em></p>

    <h2 style="margin:30px 0 16px">Kategori Pelanggan</h2>
    <p style="color:var(--muted)"><em>Belum ada data.</em></p>

    <h2 style="margin:30px 0 16px">Total Unit Dikerjakan</h2>
    <p><strong style="color:var(--accent)">0 Kendaraan</strong></p>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# KeuanganView
cat > src/views/admin/KeuanganView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Arus Kas Keuangan</h1>

    <table class="data-table" style="margin-top:30px">
      <thead><tr><th>Total Pendapatan</th><th>Total Pengeluaran</th><th>Laba Bersih</th></tr></thead>
      <tbody><tr><td>Rp 0</td><td>Rp 0</td><td>Rp 0</td></tr></tbody>
    </table>

    <h2 style="margin:30px 0 16px">Riwayat Transaksi Terbaru</h2>
    <p style="color:var(--muted)"><em>Belum ada transaksi.</em></p>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
EOF

# PengaturanView
cat > src/views/admin/PengaturanView.vue << 'EOF'
<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <h1 class="section-title">Pengaturan Sistem</h1>

    <h2 style="margin:30px 0 16px">💰 Harga & Layanan</h2>
    <div class="card">
      <div class="form-group"><label>Harga Cuci Mesin (Reguler)</label><input v-model="set.harga" /></div>
      <div class="form-group"><label>Diskon B2B</label><input v-model="set.diskon" /></div>
      <small style="color:var(--muted)">Sistem otomatis memotong harga reguler untuk klien B2B.</small>
    </div>

    <h2 style="margin:30px 0 16px">🏢 Profil Bisnis</h2>
    <div class="card">
      <div class="form-group"><label>Logo</label><input type="file" /></div>
      <div class="form-group"><label>Nama Bisnis</label><input v-model="set.nama" /></div>
      <div class="form-group"><label>Tagline</label><input v-model="set.tagline" /></div>
      <div class="form-group"><label>WhatsApp</label><input v-model="set.wa" /></div>
      <div class="form-group"><label>Alamat</label><input v-model="set.alamat" /></div>
    </div>

    <button class="btn-primary" style="margin-top:20px" @click="simpan">Simpan Pengaturan</button>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import AdminNavbar from '../../components/AdminNavbar.vue'

const set = reactive({
  harga: 'Rp 500.000', diskon: '15%',
  nama: 'CuciMesin Carwash', tagline: '#PastiBersih,PastiTerjangkau!',
  wa: '0812-3456-7890', alamat: 'Jl. Letda Sucipto, Tuban'
})

function simpan() { alert('✅ Pengaturan disimpan!') }
</script>
EOF

echo "   ✅ Views Admin dibuat."
echo ""

# =========================================================
# 15. INSTALL DEPENDENCIES
# =========================================================
echo "📥 Menginstall dependencies (npm install)..."
echo "   (Butuh koneksi internet, sabar ya...)"
echo ""

npm install

echo ""
echo "========================================================"
echo "🎉 MIGRASI SELESAI!"
echo "========================================================"
echo ""
echo "📁 Struktur project baru:"
echo "   ├── index.html"
echo "   ├── package.json"
echo "   ├── vite.config.js"
echo "   ├── _backup_html/       (file lama kamu)"
echo "   └── src/"
echo "       ├── main.js"
echo "       ├── App.vue"
echo "       ├── assets/style.css"
echo "       ├── components/"
echo "       │   ├── PublicNavbar.vue"
echo "       │   └── AdminNavbar.vue"
echo "       ├── composables/useReveal.js"
echo "       ├── router/index.js"
echo "       └── views/"
echo "           ├── public/  (Home, Layanan, Booking, Status, Profil, Login, Daftar)"
echo "           └── admin/   (Dashboard, Order, Pelanggan, Teknisi, Laporan, Keuangan, Pengaturan)"
echo ""
echo "▶️  Jalankan aplikasi dengan:"
echo ""
echo "     npm run dev"
echo ""
echo "   Lalu buka: http://localhost:5173"
echo ""
echo "🔑 Login demo:"
echo "   - Ketik 'admin' di field No. HP → masuk ke Dashboard Admin"
echo "   - Isi selain 'admin' → masuk ke Beranda Pelanggan"
echo ""