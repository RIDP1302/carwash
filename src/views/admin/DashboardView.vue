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
