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
function hideOnError(e) {
  console.warn("[Image failed]", e.target.src);
  e.target.style.opacity = "0.3";
  e.target.style.background = "rgba(255, 138, 61, 0.1)";
}
</script>
