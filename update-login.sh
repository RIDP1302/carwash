#!/bin/bash
# =========================================================
#  update-login.sh
#  Tambahkan info akun test & admin di halaman Login
# =========================================================

set -e

echo "🔐 Update halaman Login dengan info akun test & admin..."
echo ""

# Pastikan kita di folder project Vue
if [ ! -f "package.json" ]; then
  echo "❌ Error: package.json tidak ditemukan!"
  echo "   Jalankan script ini di folder root project Vue."
  exit 1
fi

# =========================================================
# 1. BUAT FILE AKUN TERPUSAT
# =========================================================
echo "📁 Membuat src/data/accounts.js..."

mkdir -p src/data

cat > src/data/accounts.js << 'EOF'
// =========================================================
//  Daftar Akun Test & Admin CuciMesin
// =========================================================

export const ACCOUNTS = [
  {
    username: 'admin',
    password: 'admin123',
    nama: 'Administrator',
    role: 'admin',
    redirect: '/admin/dashboard',
    badge: 'ADMIN',
    color: '#ff4d6d'
  },
  {
    username: 'teknisi',
    password: 'teknisi123',
    nama: 'Dedi Setiadi',
    role: 'teknisi',
    redirect: '/admin/teknisi/tugas',
    badge: 'TEKNISI',
    color: '#00c2ff'
  },
  {
    username: 'kasir',
    password: 'kasir123',
    nama: 'Rina Kasir',
    role: 'kasir',
    redirect: '/admin/keuangan',
    badge: 'KASIR',
    color: '#00ffa3'
  },
  {
    username: 'pelanggan',
    password: 'pelanggan123',
    nama: 'Budi Santoso',
    role: 'pelanggan',
    redirect: '/beranda',
    badge: 'PELANGGAN',
    color: '#ffb703'
  }
]

/**
 * Cari akun berdasarkan username & password.
 * @returns {object|null} akun kalau cocok, null kalau tidak.
 */
export function findAccount(username, password) {
  return ACCOUNTS.find(
    (a) => a.username === username.trim().toLowerCase() && a.password === password
  ) || null
}
EOF

echo "   ✅ src/data/accounts.js dibuat."
echo ""

# =========================================================
# 2. UPDATE LOGIN VIEW
# =========================================================
echo "📝 Update src/views/public/LoginView.vue..."

cat > src/views/public/LoginView.vue << 'EOF'
<template>
  <section class="hero" style="min-height:100vh">
    <div class="hero-bg"></div>
    <div class="hero-content reveal" style="max-width:480px;width:100%">
      <h1 class="hero-title" style="font-size:2.2rem">#CuciMesin</h1>
      <p class="tagline"><strong>#PASTIBERSIH, PASTITERJANGKAU!</strong></p>

      <!-- ===== FORM LOGIN ===== -->
      <form @submit.prevent="login" class="card" style="margin-top:24px;text-align:left">
        <h2 style="margin-bottom:20px;text-align:center">Masuk Aplikasi</h2>

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

        <button type="submit" class="btn-primary" style="width:100%">
          Masuk Aplikasi
        </button>

        <p style="text-align:center;margin-top:16px;color:var(--muted)">
          Belum punya akun?
          <router-link to="/daftar" style="color:var(--primary)">Daftar</router-link>
        </p>
      </form>

      <!-- ===== INFO AKUN TEST & ADMIN ===== -->
      <div class="card" style="margin-top:20px;text-align:left">
        <h3 style="margin-bottom:14px;display:flex;align-items:center;gap:8px">
          🔑 Akun Test & Admin
        </h3>
        <p style="color:var(--muted);font-size:0.85rem;margin-bottom:14px">
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

      <p style="margin-top:16px;color:var(--muted);font-size:0.8rem;text-align:center">
        <router-link to="/beranda" style="color:var(--primary)">
          → Masuk sebagai tamu (tanpa login)
        </router-link>
      </p>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useReveal } from '../../composables/useReveal'
import { ACCOUNTS, findAccount } from '../../data/accounts'

useReveal()

const router = useRouter()

const username = ref('')
const password = ref('')
const errorMsg = ref('')
const copied = ref(false)
const accounts = ACCOUNTS

// Isi form otomatis saat kartu akun diklik
function fillAccount(acc) {
  username.value = acc.username
  password.value = acc.password
  errorMsg.value = ''
}

// Proses login
function login() {
  errorMsg.value = ''
  const acc = findAccount(username.value, password.value)

  if (!acc) {
    errorMsg.value = '❌ Username atau password salah!'
    return
  }

  // Simpan session sederhana
  localStorage.setItem('cucimesin_user', JSON.stringify({
    username: acc.username,
    nama: acc.nama,
    role: acc.role
  }))

  router.push(acc.redirect)
}

// Salin semua akun ke clipboard
async function copyAll() {
  const text = accounts
    .map((a) => `${a.role.padEnd(10)} | ${a.username.padEnd(12)} | ${a.password}`)
    .join('\n')

  try {
    await navigator.clipboard.writeText(text)
    copied.value = true
    setTimeout(() => (copied.value = false), 2000)
  } catch (e) {
    // Fallback untuk browser lama
    const ta = document.createElement('textarea')
    ta.value = text
    document.body.appendChild(ta)
    ta.select()
    document.execCommand('copy')
    ta.remove()
    copied.value = true
    setTimeout(() => (copied.value = false), 2000)
  }
}
</script>

<style scoped>
.error-msg {
  color: #ff4d6d;
  font-size: 0.85rem;
  margin-bottom: 12px;
  padding: 8px 12px;
  background: rgba(255, 77, 109, 0.1);
  border-radius: 8px;
  border: 1px solid rgba(255, 77, 109, 0.3);
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
  background: rgba(0, 194, 255, 0.05);
  border: 1px solid rgba(0, 194, 255, 0.15);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.25s;
  text-align: left;
  color: var(--text);
  width: 100%;
  font-family: inherit;
}
.account-item:hover {
  background: rgba(0, 194, 255, 0.12);
  border-color: var(--primary);
  transform: translateX(4px);
}

.account-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.account-badge {
  font-size: 0.65rem;
  font-weight: 700;
  letter-spacing: 1px;
  padding: 4px 8px;
  border-radius: 6px;
  color: #0a0e1a;
  min-width: 70px;
  text-align: center;
}

.account-username {
  font-weight: 600;
  font-size: 0.9rem;
}

.account-password {
  font-family: monospace;
  color: var(--muted);
  font-size: 0.8rem;
}

.account-arrow {
  color: var(--primary);
  font-weight: 700;
  transition: transform 0.25s;
}
.account-item:hover .account-arrow {
  transform: translateX(4px);
}

.copy-section {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 14px;
}

.btn-copy {
  flex: 1;
  padding: 10px;
  border-radius: 8px;
  border: 1px dashed rgba(0, 194, 255, 0.4);
  background: transparent;
  color: var(--primary);
  font-size: 0.85rem;
  cursor: pointer;
  transition: 0.25s;
}
.btn-copy:hover {
  background: rgba(0, 194, 255, 0.1);
  border-style: solid;
}

.copied-text {
  color: var(--accent);
  font-size: 0.85rem;
  font-weight: 600;
}
</style>
EOF

echo "   ✅ LoginView.vue diperbarui."
echo ""

# =========================================================
# 3. TAMBAHKAN TOMBOL LOGOUT YANG BENAR DI NAVBAR
# =========================================================
echo "📝 Update AdminNavbar.vue (tombol logout)..."

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
      <div class="nav-right">
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
.nav-right {
  display: flex;
  align-items: center;
  gap: 12px;
}
.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--muted);
  font-size: 0.85rem;
}
.user-badge {
  background: linear-gradient(135deg, var(--primary), var(--accent));
  color: var(--dark);
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 6px;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.btn-logout {
  padding: 8px 20px;
  border-radius: 8px;
  border: 1px solid var(--primary);
  color: var(--primary);
  background: transparent;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.3s;
  font-family: inherit;
}
.btn-logout:hover {
  background: var(--primary);
  color: var(--dark);
  box-shadow: var(--glow);
}
</style>
EOF

echo "   ✅ AdminNavbar.vue diperbarui."
echo ""

# =========================================================
# 4. UPDATE PUBLIC NAVBAR (juga pakai logout)
# =========================================================
echo "📝 Update PublicNavbar.vue..."

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
      <button class="btn-logout" @click="logout">Logout</button>
    </div>
  </header>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

function logout() {
  if (!confirm('Yakin mau keluar?')) return
  localStorage.removeItem('cucimesin_user')
  router.push('/login')
}
</script>

<style scoped>
.btn-logout {
  padding: 8px 20px;
  border-radius: 8px;
  border: 1px solid var(--primary);
  color: var(--primary);
  background: transparent;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.3s;
  font-family: inherit;
}
.btn-logout:hover {
  background: var(--primary);
  color: var(--dark);
  box-shadow: var(--glow);
}
</style>
EOF

echo "   ✅ PublicNavbar.vue diperbarui."
echo ""

# =========================================================
# 5. TAMBAHKAN ROUTE GUARD (opsional tapi penting)
# =========================================================
echo "📝 Update src/router/index.js (tambah route guard)..."

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
  { path: '/login', name: 'login', component: LoginView, meta: { public: true } },
  { path: '/daftar', name: 'daftar', component: DaftarView, meta: { public: true } },
  { path: '/beranda', name: 'beranda', component: HomeView },
  { path: '/layanan', name: 'layanan', component: LayananView },
  { path: '/booking', name: 'booking', component: BookingView },
  { path: '/status', name: 'status', component: StatusView },
  { path: '/profil', name: 'profil', component: ProfilView },

  // ===== ADMIN =====
  { path: '/admin/dashboard', name: 'dashboard', component: DashboardView, meta: { role: ['admin'] } },
  { path: '/admin/order', name: 'order', component: OrderView, meta: { role: ['admin'] } },
  { path: '/admin/order/baru', name: 'order-baru', component: OrderBaruView, meta: { role: ['admin'] } },
  { path: '/admin/order/:id', name: 'order-detail', component: OrderDetailView, meta: { role: ['admin'] } },
  { path: '/admin/pelanggan', name: 'pelanggan', component: PelangganView, meta: { role: ['admin'] } },
  { path: '/admin/pelanggan/form', name: 'pelanggan-form', component: PelangganFormView, meta: { role: ['admin'] } },
  { path: '/admin/teknisi', name: 'teknisi', component: TeknisiView, meta: { role: ['admin'] } },
  { path: '/admin/teknisi/tugas', name: 'teknisi-tugas', component: TeknisiTugasView, meta: { role: ['admin', 'teknisi'] } },
  { path: '/admin/teknisi/detail', name: 'teknisi-detail', component: TeknisiDetailView, meta: { role: ['admin', 'teknisi'] } },
  { path: '/admin/laporan', name: 'laporan', component: LaporanView, meta: { role: ['admin'] } },
  { path: '/admin/keuangan', name: 'keuangan', component: KeuanganView, meta: { role: ['admin', 'kasir'] } },
  { path: '/admin/pengaturan', name: 'pengaturan', component: PengaturanView, meta: { role: ['admin'] } },

  { path: '/:pathMatch(.*)*', redirect: '/login' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// ===== ROUTE GUARD =====
router.beforeEach((to, from, next) => {
  const raw = localStorage.getItem('cucimesin_user')
  const user = raw ? JSON.parse(raw) : null

  // Halaman publik → bebas
  if (to.meta.public) {
    // Kalau sudah login, redirect ke halaman sesuai role
    if (user && to.path === '/login') {
      const redirect = user.role === 'admin' ? '/admin/dashboard'
        : user.role === 'teknisi' ? '/admin/teknisi/tugas'
        : user.role === 'kasir' ? '/admin/keuangan'
        : '/beranda'
      return next(redirect)
    }
    return next()
  }

  // Butuh login
  if (!user) {
    return next('/login')
  }

  // Cek role
  if (to.meta.role && !to.meta.role.includes(user.role)) {
    alert('⛔ Akses ditolak! Role Anda: ' + user.role)
    return next(false)
  }

  next()
})

export default router
EOF

echo "   ✅ Router dengan guard diperbarui."
echo ""

# =========================================================
# 6. SELESAI
# =========================================================
echo "========================================================"
echo "🎉 SELESAI!"
echo "========================================================"
echo ""
echo "🔑 AKUN TEST & ADMIN:"
echo ""
echo "   ┌──────────────┬───────────────┬──────────────────┐"
echo "   │ ROLE         │ USERNAME      │ PASSWORD         │"
echo "   ├──────────────┼───────────────┼──────────────────┤"
echo "   │ ADMIN        │ admin         │ admin123         │"
echo "   │ TEKNISI      │ teknisi       │ teknisi123       │"
echo "   │ KASIR        │ kasir         │ kasir123         │"
echo "   │ PELANGGAN    │ pelanggan     │ pelanggan123     │"
echo "   └──────────────┴───────────────┴──────────────────┘"
echo ""
echo "🎯 Akses per role:"
echo "   • admin      → Dashboard admin (semua menu)"
echo "   • teknisi    → Halaman tugas teknisi"
echo "   • kasir      → Halaman keuangan"
echo "   • pelanggan  → Beranda pelanggan"
echo ""
echo "▶️  Jalankan: npm run dev"
echo "   Buka: http://localhost:5173"
echo ""
echo "💡 Di halaman login:"
echo "   - Klik salah satu kartu akun → form terisi otomatis"
echo "   - Atau ketik manual"
echo "   - Tombol 'Salin Semua Akun' untuk copy list ke clipboard"
echo ""