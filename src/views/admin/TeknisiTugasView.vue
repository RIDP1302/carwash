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
