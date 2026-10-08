<template>
  <PublicNavbar />
  <section class="section" style="max-width:700px">
    <h1 class="section-title">Profil Saya</h1>
    <div class="card">
      <p>Nama: <strong>—</strong></p>
      <p>WhatsApp: <strong>—</strong></p>
      <p>Email: <strong>—</strong></p>
      <p>Kategori: <strong>Normal</strong></p>
    </div>

    <h2 style="margin:30px 0 16px">Ubah Password</h2>
    <form @submit.prevent="ubah" class="card">
      <div class="form-group"><label>Password Lama</label><input type="password" v-model="oldPass" required /></div>
      <div class="form-group"><label>Password Baru</label><input type="password" v-model="newPass" required /></div>
      <div class="form-group"><label>Konfirmasi Password</label><input type="password" v-model="confirm" required /></div>
      <button type="submit" class="btn-primary">Simpan Password</button>
    </form>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import PublicNavbar from '../../components/PublicNavbar.vue'

const oldPass = ref(''), newPass = ref(''), confirm = ref('')
function ubah() {
  if (newPass.value !== confirm.value) return alert('❌ Password tidak sama!')
  alert('✅ Password berhasil diubah!')
}
</script>
