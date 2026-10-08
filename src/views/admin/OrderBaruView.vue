<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/order" style="color:var(--primary)">← Kembali ke Order</router-link>
    <h1 class="section-title" style="margin-top:16px">Buat SPK Baru</h1>

    <form @submit.prevent="simpan" class="card">
      <h2 style="margin-bottom:16px">1. Data Pelanggan</h2>
      <div class="form-group"><label>Nama Pelanggan</label><input v-model="form.nama" required /></div>
      <div class="form-group"><label>Nomor WhatsApp</label><input type="tel" v-model="form.wa" required /></div>
      <div class="form-group">
        <label>Kategori Member</label>
        <select v-model="form.kategori"><option>Normal</option><option>Member B2B</option></select>
      </div>

      <h2 style="margin:24px 0 16px">2. Detail Kendaraan</h2>
      <div class="form-group"><label>Plat Nomor</label><input v-model="form.plat" required /></div>
      <div class="form-group"><label>Merk / Tipe</label><input v-model="form.tipe" required /></div>

      <h2 style="margin:24px 0 16px">3. Layanan & Penugasan</h2>
      <div class="form-group">
        <label>Paket Layanan</label>
        <select v-model="form.layanan">
          <option>Cuci Mesin Standard — Rp 95.000</option>
          <option>Cuci Mesin Premium — Rp 150.000</option>
          <option>Engine Detailing — Rp 350.000</option>
        </select>
      </div>
      <div class="form-group">
        <label>Tugaskan Teknisi</label>
        <select v-model="form.teknisi">
          <option>Dedi Setiadi</option><option>Ahmad Subarjo</option><option>Rian Hidayat</option>
        </select>
      </div>

      <p style="margin:20px 0">Total: <strong style="color:var(--accent)">Rp 0</strong></p>

      <div style="display:flex;gap:12px">
        <router-link to="/admin/order" class="btn-secondary">Batal</router-link>
        <button type="submit" class="btn-primary">Simpan & Buat SPK</button>
      </div>
    </form>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavbar from '../../components/AdminNavbar.vue'

const router = useRouter()
const form = reactive({ nama: '', wa: '', kategori: 'Normal', plat: '', tipe: '', layanan: '', teknisi: '' })

function simpan() {
  alert('✅ SPK berhasil dibuat!')
  router.push('/admin/order')
}
</script>
