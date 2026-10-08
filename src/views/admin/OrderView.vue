<template>
  <AdminNavbar />
  <section class="section">
    <h1 class="section-title">Manajemen Order & SPK</h1>
    <p class="section-sub">Buat, cetak, dan pantau Surat Perintah Kerja.</p>

    <div class="card" style="display:flex;gap:16px;flex-wrap:wrap;align-items:end">
      <div class="form-group" style="flex:1;min-width:150px">
        <label>Tanggal</label><input type="date" v-model="filter.tanggal" />
      </div>
      <div class="form-group" style="flex:1;min-width:150px">
        <label>Status</label>
        <select v-model="filter.status">
          <option>Semua Status</option><option>Menunggu</option>
          <option>Dikerjakan</option><option>Selesai</option>
        </select>
      </div>
      <div class="form-group" style="flex:1;min-width:150px">
        <label>Kategori</label>
        <select v-model="filter.kategori">
          <option>Semua Kategori</option><option>Normal</option><option>Member B2B</option>
        </select>
      </div>
      <router-link to="/admin/order/baru" class="btn-primary" style="margin-bottom:16px">+ SPK Baru</router-link>
    </div>

    <p style="color:var(--muted);margin-top:30px"><em>Belum ada SPK. Klik "+ SPK Baru" untuk membuat order pertama.</em></p>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import AdminNavbar from '../../components/AdminNavbar.vue'

const filter = reactive({ tanggal: '', status: 'Semua Status', kategori: 'Semua Kategori' })
</script>
