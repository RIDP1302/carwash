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
