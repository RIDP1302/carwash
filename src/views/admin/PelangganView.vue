<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Daftar Pelanggan</h1>
    <p class="section-sub">Kelola data pelanggan CuciMesin.</p>
    <router-link to="/admin/pelanggan/form" class="btn-primary">+ Pelanggan Baru</router-link>

    <p style="color:var(--muted);margin-top:30px"><em>Belum ada pelanggan terdaftar.</em></p>
  </section>
</template>

<script setup>
import AdminNavbar from '../../components/AdminNavbar.vue'
</script>
