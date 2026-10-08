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
