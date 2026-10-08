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
