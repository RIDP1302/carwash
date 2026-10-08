<template>
  <PublicNavbar />
  <section class="section">
    <h1 class="section-title">Status Order Saya</h1>
    <p class="section-sub">Pantau status cuci mobil Anda secara real-time.</p>

    <h2 style="margin:30px 0 16px">📋 Sedang Dikerjakan</h2>
    <div class="card" v-if="aktif">
      <h3>{{ aktif.plat }} — {{ aktif.tipe }}</h3>
      <p>Status: <strong style="color:var(--accent)">{{ aktif.status }}</strong></p>
    </div>
    <p v-else style="color:var(--muted)"><em>Belum ada cuci yang sedang dikerjakan.</em></p>

    <h2 style="margin:30px 0 16px">📜 Riwayat Order</h2>
    <table class="data-table" v-if="riwayat.length">
      <thead><tr><th>Tanggal</th><th>Plat</th><th>Layanan</th><th>Status</th></tr></thead>
      <tbody>
        <tr v-for="r in riwayat" :key="r.id">
          <td>{{ r.tanggal }}</td><td>{{ r.plat }}</td><td>{{ r.layanan }}</td><td>{{ r.status }}</td>
        </tr>
      </tbody>
    </table>
    <p v-else style="color:var(--muted)"><em>Belum ada riwayat order.</em></p>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import PublicNavbar from '../../components/PublicNavbar.vue'

const aktif = ref(null)
const riwayat = ref([])
</script>
