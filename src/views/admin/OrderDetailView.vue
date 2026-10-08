<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/order" style="color:var(--primary)">← Kembali ke Order</router-link>
    <h1 class="section-title" style="margin-top:16px">SPK-XXXXXX</h1>

    <div class="card">
      <h2>Info Pelanggan</h2>
      <p style="color:var(--muted)">Data pelanggan dimuat dari database.</p>

      <h2 style="margin-top:20px">Detail Kendaraan</h2>
      <p style="color:var(--muted)">Data kendaraan dimuat dari database.</p>

      <h2 style="margin-top:20px">Checklist Teknisi</h2>
      <ul style="list-style:none;color:var(--muted)">
        <li><label><input type="checkbox"> Masking ECU & Kabel Elektrikal</label></li>
        <li><label><input type="checkbox"> Cek Kondisi Aki & Alternator</label></li>
        <li><label><input type="checkbox"> Penyemprotan Chemical Khusus</label></li>
        <li><label><input type="checkbox"> Bilas & Pengeringan Detail</label></li>
      </ul>

      <div style="display:flex;gap:12px;margin-top:20px;flex-wrap:wrap">
        <button class="btn-secondary">Cetak SPK</button>
        <button class="btn-secondary">Kirim Invoice</button>
        <router-link to="/admin/teknisi/detail" class="btn-primary">Proses Teknisi →</router-link>
      </div>
    </div>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
