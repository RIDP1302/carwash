<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <h1 class="section-title">Pengaturan Sistem</h1>

    <h2 style="margin:30px 0 16px">💰 Harga & Layanan</h2>
    <div class="card">
      <div class="form-group"><label>Harga Cuci Mesin (Reguler)</label><input v-model="set.harga" /></div>
      <div class="form-group"><label>Diskon B2B</label><input v-model="set.diskon" /></div>
      <small style="color:var(--muted)">Sistem otomatis memotong harga reguler untuk klien B2B.</small>
    </div>

    <h2 style="margin:30px 0 16px">🏢 Profil Bisnis</h2>
    <div class="card">
      <div class="form-group"><label>Logo</label><input type="file" /></div>
      <div class="form-group"><label>Nama Bisnis</label><input v-model="set.nama" /></div>
      <div class="form-group"><label>Tagline</label><input v-model="set.tagline" /></div>
      <div class="form-group"><label>WhatsApp</label><input v-model="set.wa" /></div>
      <div class="form-group"><label>Alamat</label><input v-model="set.alamat" /></div>
    </div>

    <button class="btn-primary" style="margin-top:20px" @click="simpan">Simpan Pengaturan</button>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import AdminNavbar from '../../components/AdminNavbar.vue'

const set = reactive({
  harga: 'Rp 500.000', diskon: '15%',
  nama: 'CuciMesin Carwash', tagline: '#PastiBersih,PastiTerjangkau!',
  wa: '0812-3456-7890', alamat: 'Jl. Letda Sucipto, Tuban'
})

function simpan() { alert('✅ Pengaturan disimpan!') }
</script>
