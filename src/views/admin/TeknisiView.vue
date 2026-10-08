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
