<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/teknisi/tugas" style="color:var(--primary)">← Kembali</router-link>
    <h1 class="section-title" style="margin-top:16px">SPK-XXXXXX</h1>

    <div class="card">
      <h2>📋 Checklist Pengerjaan</h2>
      <ul style="list-style:none;color:var(--muted);margin-top:12px">
        <li><label><input type="checkbox"> Masking ECU & Kabel Elektrikal</label></li>
        <li><label><input type="checkbox"> Cek Kondisi Aki & Alternator</label></li>
        <li><label><input type="checkbox"> Penyemprotan Chemical Khusus</label></li>
        <li><label><input type="checkbox"> Bilas & Pengeringan Detail</label></li>
      </ul>

      <h2 style="margin-top:24px">⏱️ Durasi</h2>
      <p><strong style="color:var(--accent)">00:00:00</strong></p>

      <router-link to="/admin/teknisi/tugas" class="btn-primary" style="margin-top:20px">Selesai Pengerjaan ✓</router-link>
    </div>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
