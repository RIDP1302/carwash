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
