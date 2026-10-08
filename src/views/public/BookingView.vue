<template>
  <PublicNavbar />
  <section class="section" style="max-width:700px">
    <h1 class="section-title">Booking Cuci Mesin Online</h1>
    <p class="section-sub">Isi data di bawah untuk melakukan booking.</p>

    <form @submit.prevent="submit" class="card">
      <div class="form-group">
        <label>Nama Lengkap / Instansi</label>
        <input v-model="form.nama" required />
      </div>
      <div class="form-group">
        <label>No. WhatsApp</label>
        <input type="tel" v-model="form.wa" required />
      </div>
      <div class="form-group">
        <label>Email</label>
        <input type="email" v-model="form.email" />
      </div>
      <div class="form-group">
        <label>Nomor Plat</label>
        <input v-model="form.plat" required />
      </div>
      <div class="form-group">
        <label>Merk & Tipe Mobil</label>
        <input v-model="form.tipe" required />
      </div>
      <div class="form-group">
        <label>Pilih Layanan</label>
        <select v-model="form.layanan" required>
          <option value="">-- Pilih Paket --</option>
          <option>Cuci Mesin Standard - Rp 95.000</option>
          <option>Cuci Mesin Premium - Rp 150.000</option>
          <option>Cuci Mesin + Detailing - Rp 350.000</option>
        </select>
      </div>
      <div class="form-group">
        <label>Tanggal</label>
        <input type="date" v-model="form.tanggal" required />
      </div>
      <div class="form-group">
        <label>Jam</label>
        <input type="time" v-model="form.jam" required />
      </div>
      <div class="form-group">
        <label>Catatan Tambahan</label>
        <textarea v-model="form.catatan" rows="3"></textarea>
      </div>
      <button type="submit" class="btn-primary" style="width:100%">BOOKING SEKARANG</button>
    </form>
  </section>
</template>

<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import PublicNavbar from '../../components/PublicNavbar.vue'

const router = useRouter()
const form = reactive({
  nama: '', wa: '', email: '', plat: '', tipe: '',
  layanan: '', tanggal: '', jam: '', catatan: ''
})

function submit() {
  alert('✅ Booking berhasil!\n\nTerima kasih, ' + form.nama + '.')
  router.push('/status')
}
</script>
