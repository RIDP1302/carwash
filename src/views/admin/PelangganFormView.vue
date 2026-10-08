<template>
  <AdminNavbar />
  <section class="section" style="max-width:800px">
    <router-link to="/admin/pelanggan" style="color:var(--primary)">← Kembali</router-link>
    <h1 class="section-title" style="margin-top:16px">Informasi Pelanggan</h1>

    <form @submit.prevent="simpan" class="card">
      <div class="form-group"><label>Nama</label><input v-model="form.nama" required /></div>
      <div class="form-group"><label>WhatsApp</label><input type="tel" v-model="form.wa" required /></div>
      <div class="form-group"><label>Kategori</label>
        <select v-model="form.kategori"><option>Normal</option><option>Member B2B</option></select>
      </div>
      <div class="form-group"><label>Plat</label><input v-model="form.plat" /></div>
      <div class="form-group"><label>Tipe</label><input v-model="form.tipe" /></div>
      <div style="display:flex;gap:12px;margin-top:20px">
        <router-link to="/admin/pelanggan" class="btn-secondary">Batal</router-link>
        <button type="submit" class="btn-primary">Simpan</button>
      </div>
    </form>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavbar from '../../components/AdminNavbar.vue'

const router = useRouter()
const form = reactive({ nama: '', wa: '', kategori: 'Normal', plat: '', tipe: '' })

function simpan() {
  alert('✅ Data pelanggan disimpan!')
  router.push('/admin/pelanggan')
}
</script>
