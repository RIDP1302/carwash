#!/bin/bash
# =========================================================
#  fix-refresh-and-icons.sh
#  1. Fix tampilan yang baru muncul setelah refresh
#  2. Ganti semua emoji kaku → icon SVG minimalis
# =========================================================

set -e

echo "🔧 Fix refresh + ganti emoji ke SVG..."
echo ""

if [ ! -f "package.json" ]; then
  echo "❌ Error: package.json tidak ditemukan!"
  exit 1
fi

# =========================================================
# 1. FIX REVEAL — pakai nextTick & fallback
# =========================================================
echo "📝 Fix src/composables/useReveal.js..."

mkdir -p src/composables

cat > src/composables/useReveal.js << 'EOF'
import { onMounted, nextTick } from 'vue'

/**
 * Reveal on scroll — fix supaya elemen langsung terlihat
 * tanpa harus refresh / scroll dulu.
 */
export function useReveal() {
  onMounted(async () => {
    await nextTick()

    const els = document.querySelectorAll('.reveal')

    // Kalau browser tidak support IntersectionObserver → tampil semua
    if (!('IntersectionObserver' in window)) {
      els.forEach((el) => el.classList.add('active'))
      return
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('active')
            observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.05, rootMargin: '0px 0px -40px 0px' }
    )

    els.forEach((el) => {
      // Kalau elemen sudah di viewport saat mount → langsung tampil
      const rect = el.getBoundingClientRect()
      if (rect.top < window.innerHeight && rect.bottom > 0) {
        el.classList.add('active')
      } else {
        observer.observe(el)
      }
    })

    // Failsafe: kalau setelah 800ms masih ada yang belum aktif, paksa tampil
    setTimeout(() => {
      document.querySelectorAll('.reveal:not(.active)').forEach((el) => {
        const rect = el.getBoundingClientRect()
        if (rect.top < window.innerHeight * 1.2) {
          el.classList.add('active')
        }
      })
    }, 800)
  })
}
EOF

echo "   ✅ useReveal.js diperbaiki."
echo ""

# =========================================================
# 2. FIX APP.VUE — hapus loader delay, langsung render
# =========================================================
echo "📝 Fix src/App.vue (hilangkan delay loader)..."

cat > src/App.vue << 'EOF'
<template>
  <router-view v-slot="{ Component }">
    <transition name="fade" mode="out-in">
      <component :is="Component" />
    </transition>
  </router-view>
</template>

<script setup>
</script>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.25s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
EOF

echo "   ✅ App.vue diperbaiki (tanpa loader delay)."
echo ""

# =========================================================
# 3. KOMPONEN ICON SVG
# =========================================================
echo "📝 Buat src/components/AppIcon.vue..."

cat > src/components/AppIcon.vue << 'EOF'
<template>
  <svg
    :width="size"
    :height="size"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    :stroke-width="strokeWidth"
    stroke-linecap="round"
    stroke-linejoin="round"
    class="app-icon"
    aria-hidden="true"
  >
    <!-- location / pilihan -->
    <template v-if="name === 'location'">
      <path d="M12 22s7-6.5 7-12a7 7 0 1 0-14 0c0 5.5 7 12 7 12z" />
      <circle cx="12" cy="10" r="2.5" />
    </template>

    <!-- calendar / booking -->
    <template v-else-if="name === 'calendar'">
      <rect x="3" y="4.5" width="18" height="16" rx="2" />
      <path d="M3 9h18M8 3v3M16 3v3" />
      <circle cx="12" cy="14.5" r="1.2" fill="currentColor" stroke="none" />
    </template>

    <!-- user-check / teknisi -->
    <template v-else-if="name === 'user-check'">
      <circle cx="9" cy="8" r="3.5" />
      <path d="M3 20c0-3.3 2.7-6 6-6s6 2.7 6 6" />
      <path d="M16 11l2 2 4-4" />
    </template>

    <!-- droplet / wash -->
    <template v-else-if="name === 'droplet'">
      <path d="M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z" />
    </template>

    <!-- shield / garansi -->
    <template v-else-if="name === 'shield'">
      <path d="M12 3l8 3v6c0 4.5-3.4 8.3-8 9-4.6-.7-8-4.5-8-9V6l8-3z" />
      <path d="M9 12l2 2 4-4" />
    </template>

    <!-- gear / pengaturan -->
    <template v-else-if="name === 'settings'">
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1-1.5 1.7 1.7 0 0 0-1.9.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.9 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1 1.7 1.7 0 0 0-.3-1.9l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.9.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.9-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.9V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z" />
    </template>

    <!-- search -->
    <template v-else-if="name === 'search'">
      <circle cx="11" cy="11" r="7" />
      <path d="M21 21l-4.3-4.3" />
    </template>

    <!-- arrow-right -->
    <template v-else-if="name === 'arrow-right'">
      <path d="M5 12h14M13 6l6 6-6 6" />
    </template>

    <!-- check -->
    <template v-else-if="name === 'check'">
      <path d="M5 12l5 5L20 7" />
    </template>

    <!-- star -->
    <template v-else-if="name === 'star'">
      <path d="M12 3l2.9 6 6.6.9-4.8 4.6 1.1 6.5L12 18l-5.8 3 1.1-6.5L2.5 9.9 9.1 9z" fill="currentColor" stroke="none" />
    </template>

    <!-- mail -->
    <template v-else-if="name === 'mail'">
      <rect x="3" y="5" width="18" height="14" rx="2" />
      <path d="M3 7l9 6 9-6" />
    </template>

    <!-- phone -->
    <template v-else-if="name === 'phone'">
      <path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .3 2 .6 2.9a2 2 0 0 1-.4 2.1L8 10a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4c.9.3 1.9.5 2.9.6a2 2 0 0 1 1.7 2z" />
    </template>

    <!-- key -->
    <template v-else-if="name === 'key'">
      <circle cx="8" cy="14" r="4" />
      <path d="M10.8 11.2L21 1M17 5l3 3M15 7l3 3" />
    </template>

    <!-- logout -->
    <template v-else-if="name === 'logout'">
      <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
      <path d="M16 17l5-5-5-5M21 12H9" />
    </template>

    <!-- dashboard -->
    <template v-else-if="name === 'dashboard'">
      <rect x="3" y="3" width="7" height="9" rx="1.5" />
      <rect x="14" y="3" width="7" height="5" rx="1.5" />
      <rect x="14" y="12" width="7" height="9" rx="1.5" />
      <rect x="3" y="16" width="7" height="5" rx="1.5" />
    </template>

    <!-- clipboard / order -->
    <template v-else-if="name === 'clipboard'">
      <rect x="5" y="4" width="14" height="18" rx="2" />
      <path d="M9 4h6v3H9zM9 12h6M9 16h4" />
    </template>

    <!-- users -->
    <template v-else-if="name === 'users'">
      <circle cx="9" cy="8" r="3.5" />
      <path d="M2.5 20c0-3.3 2.9-6 6.5-6s6.5 2.7 6.5 6" />
      <path d="M17 11a3 3 0 1 0 0-6M22 20c0-2.5-1.6-4.6-3.8-5.4" />
    </template>

    <!-- chart / laporan -->
    <template v-else-if="name === 'chart'">
      <path d="M4 20V10M10 20V4M16 20v-8M22 20H2" />
    </template>

    <!-- wallet / keuangan -->
    <template v-else-if="name === 'wallet'">
      <rect x="3" y="6" width="18" height="14" rx="2.5" />
      <path d="M3 10h18" />
      <circle cx="17" cy="15" r="1.3" fill="currentColor" stroke="none" />
    </template>

    <!-- plus -->
    <template v-else-if="name === 'plus'">
      <path d="M12 5v14M5 12h14" />
    </template>

    <!-- menu -->
    <template v-else-if="name === 'menu'">
      <path d="M4 7h16M4 12h16M4 17h16" />
    </template>

    <!-- x -->
    <template v-else-if="name === 'x'">
      <path d="M6 6l12 12M18 6L6 18" />
    </template>

    <!-- camera -->
    <template v-else-if="name === 'camera'">
      <path d="M4 8h3l2-3h6l2 3h3v11H4z" />
      <circle cx="12" cy="13" r="3.5" />
    </template>

    <!-- clock -->
    <template v-else-if="name === 'clock'">
      <circle cx="12" cy="12" r="9" />
      <path d="M12 7v5l3 2" />
    </template>

    <!-- download -->
    <template v-else-if="name === 'download'">
      <path d="M12 3v12M7 10l5 5 5-5M5 21h14" />
    </template>

    <!-- copy -->
    <template v-else-if="name === 'copy'">
      <rect x="9" y="9" width="12" height="12" rx="2" />
      <path d="M5 15V5a2 2 0 0 1 2-2h10" />
    </template>

    <!-- fallback -->
    <template v-else>
      <circle cx="12" cy="12" r="9" />
    </template>
  </svg>
</template>

<script setup>
defineProps({
  name:        { type: String, required: true },
  size:        { type: [Number, String], default: 20 },
  strokeWidth: { type: [Number, String], default: 1.8 }
})
</script>

<style scoped>
.app-icon {
  display: inline-block;
  vertical-align: middle;
  flex-shrink: 0;
}
</style>
EOF

echo "   ✅ AppIcon.vue dibuat (25+ icon SVG)."
echo ""

# =========================================================
# 4. PUBLIC NAVBAR — pakai icon SVG
# =========================================================
echo "📝 Update PublicNavbar.vue..."

cat > src/components/PublicNavbar.vue << 'EOF'
<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/beranda" class="logo">
        <span class="logo-mark">
          <AppIcon name="droplet" :size="16" :stroke-width="2.2" />
        </span>
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
        <button class="btn-logout" @click="logout">
          <AppIcon name="logout" :size="16" />
          <span>Logout</span>
        </button>
        <button class="hamburger" @click="menuOpen = !menuOpen" aria-label="Menu">
          <AppIcon :name="menuOpen ? 'x' : 'menu'" :size="22" />
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AppIcon from './AppIcon.vue'

const router = useRouter()
const menuOpen = ref(false)

function closeMenu() { menuOpen.value = false }

function logout() {
  if (!confirm('Yakin mau keluar?')) return
  localStorage.removeItem('cucimesin_user')
  router.push('/login')
}
</script>

<style scoped>
.btn-logout {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}
.hamburger {
  display: none;
  align-items: center;
  justify-content: center;
  padding: 8px;
  color: var(--text);
}
@media (max-width: 640px) {
  .hamburger { display: inline-flex; }
  .btn-logout span { display: none; }
}
</style>
EOF

echo "   ✅ PublicNavbar.vue diperbarui."
echo ""

# =========================================================
# 5. ADMIN NAVBAR — pakai icon SVG
# =========================================================
echo "📝 Update AdminNavbar.vue..."

cat > src/components/AdminNavbar.vue << 'EOF'
<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/admin/dashboard" class="logo">
        <span class="logo-mark">
          <AppIcon name="settings" :size="16" :stroke-width="2.2" />
        </span>
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
          <span class="user-name">{{ user.nama }}</span>
        </span>
        <button class="btn-logout" @click="logout">
          <AppIcon name="logout" :size="16" />
          <span>Keluar</span>
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AppIcon from './AppIcon.vue'

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
.btn-logout {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}
@media (max-width: 768px) {
  .user-name { display: none; }
  .btn-logout span { display: none; }
}
</style>
EOF

echo "   ✅ AdminNavbar.vue diperbarui."
echo ""

# =========================================================
# 6. HOME VIEW — hapus emoji, pakai icon SVG
# =========================================================
echo "📝 Update HomeView.vue (icon SVG, tanpa emoji)..."

cat > src/views/public/HomeView.vue << 'EOF'
<template>
  <PublicNavbar />

  <!-- ============ HERO ============ -->
  <section class="hero">
    <div class="hero-inner">
      <div class="hero-text">
        <p class="hero-tagline">#PASTIBERSIH, PASTITERJANGKAU</p>
        <h1 class="hero-title">
          CUCI MESIN<br>
          <span class="accent">KINCLONG.</span>
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
      <h3>LAYANAN KAMI</h3>
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
        <h2 class="section-title">PAKET SPESIAL</h2>
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
          <router-link to="/booking" class="btn-accent">
            Booking
            <AppIcon name="arrow-right" :size="14" />
          </router-link>
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
      MULAI SEKARANG & DAPATKAN<br>
      <span class="highlight">UPDATE PROMO</span> DARI KAMI
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
      <a href="#" aria-label="Instagram">
        <AppIcon name="camera" :size="16" />
      </a>
      <a href="#" aria-label="Email">
        <AppIcon name="mail" :size="16" />
      </a>
      <a href="#" aria-label="Phone">
        <AppIcon name="phone" :size="16" />
      </a>
    </div>
    <small>© 2024 CuciMesin Carwash</small>
  </footer>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import PublicNavbar from '../../components/PublicNavbar.vue'
import AppIcon from '../../components/AppIcon.vue'
import { IMAGES } from '../../data/images'

const router = useRouter()
const search = ref('')
const email = ref('')

function doSearch() {
  if (search.value.trim()) {
    router.push('/layanan')
  }
}

function subscribe() {
  alert('Terima kasih! Email ' + email.value + ' sudah terdaftar.')
  email.value = ''
}

function hideOnError(e) {
  e.target.style.opacity = '0'
}
</script>
EOF

echo "   ✅ HomeView.vue diperbarui (tanpa emoji)."
echo ""

# =========================================================
# 7. LOGIN VIEW — hapus emoji
# =========================================================
echo "📝 Update LoginView.vue (tanpa emoji)..."

cat > src/views/public/LoginView.vue << 'EOF'
<template>
  <section class="login-page">
    <div class="login-grid">
      <div class="login-left">
        <p class="hero-tagline">#PASTIBERSIH, PASTITERJANGKAU</p>
        <h1 class="hero-title">
          SELAMAT<br>
          <span class="accent">DATANG.</span>
        </h1>
        <p class="hero-desc">
          Login untuk mulai booking cuci mesin, atau kelola dashboard admin
          CuciMesin.
        </p>
      </div>

      <div class="login-right">
        <form @submit.prevent="login" class="login-card">
          <h2>Masuk Aplikasi</h2>

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
              placeholder="Masukkan password"
              required
              autocomplete="current-password"
            />
          </div>

          <p v-if="errorMsg" class="error-msg">{{ errorMsg }}</p>

          <button type="submit" class="btn-primary" style="width:100%;justify-content:center">
            Masuk Aplikasi
          </button>

          <p class="login-footer">
            Belum punya akun?
            <router-link to="/daftar">Daftar</router-link>
          </p>
        </form>

        <div class="accounts-card">
          <h3>
            <AppIcon name="key" :size="18" />
            Akun Test & Admin
          </h3>
          <p class="accounts-hint">Klik kartu akun untuk mengisi form otomatis.</p>

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
              <AppIcon name="arrow-right" :size="16" class="account-arrow" />
            </button>
          </div>

          <div class="copy-section">
            <button type="button" class="btn-copy" @click="copyAll">
              <AppIcon name="copy" :size="14" />
              Salin Semua Akun
            </button>
            <span v-if="copied" class="copied-text">Tersalin!</span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AppIcon from '../../components/AppIcon.vue'
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
    errorMsg.value = 'Username atau password salah.'
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
.login-page {
  min-height: 100vh;
  padding: 40px 32px;
  background: linear-gradient(180deg, #ffffff 0%, var(--cream) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}
.login-grid {
  max-width: 1200px;
  width: 100%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
  align-items: center;
}
.login-left { max-width: 480px; }

.login-card {
  background: white;
  border-radius: var(--radius);
  padding: 40px;
  box-shadow: var(--shadow-md);
}
.login-card h2 {
  color: var(--navy);
  font-size: 1.4rem;
  margin-bottom: 24px;
  text-align: center;
}
.login-footer {
  text-align: center;
  margin-top: 16px;
  color: var(--text-light);
  font-size: 0.88rem;
}
.login-footer a {
  color: var(--primary);
  font-weight: 600;
}

.accounts-card {
  background: white;
  border-radius: var(--radius);
  padding: 28px;
  box-shadow: var(--shadow-sm);
  margin-top: 20px;
}
.accounts-card h3 {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--navy);
  font-size: 1rem;
  margin-bottom: 8px;
}
.accounts-hint {
  color: var(--text-light);
  font-size: 0.82rem;
  margin-bottom: 14px;
}

.account-list { display: flex; flex-direction: column; gap: 8px; }

.account-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 14px;
  background: var(--cream);
  border: 1.5px solid rgba(15, 21, 53, 0.06);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
  text-align: left;
  color: var(--text);
  width: 100%;
  font-family: inherit;
}
.account-item:hover {
  background: var(--primary-light);
  border-color: var(--primary);
}

.account-left { display: flex; align-items: center; gap: 12px; }
.account-badge {
  font-size: 0.65rem;
  font-weight: 800;
  letter-spacing: 1px;
  padding: 4px 10px;
  border-radius: 6px;
  color: white;
  min-width: 72px;
  text-align: center;
}
.account-username { font-weight: 700; font-size: 0.9rem; color: var(--navy); }
.account-password { font-family: monospace; color: var(--text-light); font-size: 0.78rem; }
.account-arrow { color: var(--primary); transition: transform 0.2s; }
.account-item:hover .account-arrow { transform: translateX(4px); }

.copy-section {
  display: flex; align-items: center; gap: 10px;
  margin-top: 14px;
}
.btn-copy {
  flex: 1;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 10px;
  border-radius: 10px;
  border: 1.5px dashed rgba(79, 107, 255, 0.4);
  background: transparent;
  color: var(--primary);
  font-size: 0.85rem;
  font-weight: 600;
  transition: 0.2s;
  font-family: inherit;
}
.btn-copy:hover {
  background: var(--primary-light);
  border-style: solid;
}
.copied-text {
  color: #16a34a;
  font-size: 0.82rem;
  font-weight: 700;
}

.error-msg {
  color: #e11d48;
  font-size: 0.85rem;
  margin-bottom: 12px;
  padding: 10px 14px;
  background: #ffe4e8;
  border-radius: 10px;
  border: 1px solid #ffc9d3;
}

@media (max-width: 900px) {
  .login-grid { grid-template-columns: 1fr; gap: 32px; }
  .login-left { text-align: center; margin: 0 auto; }
  .login-page { padding: 60px 20px; }
}
</style>
EOF

echo "   ✅ LoginView.vue diperbarui."
echo ""

# =========================================================
# 8. UPDATE STYLE — perbaiki reveal & search icon
# =========================================================
echo "📝 Update style.css (search icon + reveal fix)..."

# Tambahkan style baru tanpa menimpa yang lama
cat >> src/assets/style.css << 'EOF'

/* =========================================================
   FIX: Search icon + Reveal fallback
   ========================================================= */

/* Search bar dengan icon di kiri */
.search-bar {
  position: relative;
}
.search-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-left: 22px;
  color: var(--text-light);
  flex-shrink: 0;
}
.search-bar input {
  padding-left: 14px;
}

/* Icon di feature-card */
.feature-card .icon {
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--white);
}

/* Icon di package-rating */
.package-rating {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: var(--accent);
}

/* Icon di btn-accent / btn-primary (arrow) */
.btn-accent,
.btn-primary,
.btn-secondary {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

/* Footer social icon */
.footer-social a {
  color: var(--text);
}

/* Reveal — pakai will-change biar smooth */
.reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.6s ease, transform 0.6s ease;
  will-change: opacity, transform;
}
.reveal.active {
  opacity: 1;
  transform: translateY(0);
}

/* Kalau JS gagal / disabled → tampil semua */
.no-js .reveal {
  opacity: 1;
  transform: none;
}
EOF

echo "   ✅ style.css diperbarui."
echo ""

# =========================================================
# 9. MAIN.JS — tambahkan fallback no-js & fonts
# =========================================================
echo "📝 Update src/main.js..."

cat > src/main.js << 'EOF'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/style.css'

// Failsafe: pastikan tidak ada class .no-js di body
document.documentElement.classList.remove('no-js')

createApp(App).use(router).mount('#app')
EOF

echo "   ✅ main.js diperbarui."
echo ""

# =========================================================
# 10. INDEX.HTML — tambahkan no-js class
# =========================================================
echo "📝 Update index.html (no-js fallback)..."

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="id" class="no-js">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CuciMesin — #PastiBersih, PastiTerjangkau!</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <style>
    /* Failsafe: kalau JS belum load, sembunyikan dulu biar tidak flicker */
    html.no-js body { visibility: hidden; }
  </style>
</head>
<body>
  <div id="app"></div>
  <script type="module" src="/src/main.js"></script>
</body>
</html>
EOF

echo "   ✅ index.html diperbarui."
echo ""

# =========================================================
# 11. SELESAI
# =========================================================
echo "========================================================"
echo "SELESAI!"
echo "========================================================"
echo ""
echo "Yang sudah diperbaiki:"
echo ""
echo "  1. Refresh bug"
echo "     - useReveal pakai nextTick + cek posisi elemen"
echo "     - Failsafe 800ms: paksa tampil kalau di viewport"
echo "     - Loader App.vue dihapus (langsung render)"
echo "     - no-js fallback di index.html"
echo ""
echo "  2. Emoji dihapus, ganti icon SVG"
echo "     - Buat AppIcon.vue dengan 25+ icon (outline, mirip mockup)"
echo "     - Semua emoji di HomeView, Login, Navbar diganti"
echo "     - Icon: droplet, shield, calendar, user-check, star,"
echo "       arrow-right, search, mail, phone, key, logout, dll"
echo ""
echo "Jalankan:"
echo "  npm run dev"
echo ""
echo "Buka: http://localhost:5173"
echo ""
echo "Kalau masih ada yang error, kirim pesan error-nya."
echo ""