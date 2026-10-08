<template>
  <section class="section" style="max-width:500px">
    <h1 class="section-title">Daftar Akun Baru</h1>
    <form @submit.prevent="daftar" class="card">
      <div class="form-group"><label>Nama Lengkap</label><input v-model="nama" required /></div>
      <div class="form-group"><label>Nomor WhatsApp</label><input type="tel" v-model="wa" required /></div>
      <div class="form-group"><label>Kata Sandi</label><input type="password" v-model="pass" required /></div>
      <div class="form-group"><label>Konfirmasi Kata Sandi</label><input type="password" v-model="pass2" required /></div>
      <label style="display:flex;gap:8px;color:var(--muted);margin-bottom:16px">
        <input type="checkbox" v-model="setuju" required /> Saya setuju dengan S&K.
      </label>
      <button type="submit" class="btn-primary" style="width:100%">Buat Akun</button>
      <p style="text-align:center;margin-top:16px;color:var(--muted)">
        Sudah punya akun? <router-link to="/login" style="color:var(--primary)">Masuk</router-link>
      </p>
    </form>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const nama = ref(''), wa = ref(''), pass = ref(''), pass2 = ref(''), setuju = ref(false)

function daftar() {
  if (pass.value !== pass2.value) return alert('❌ Password tidak sama!')
  alert('✅ Akun berhasil dibuat!')
  router.push('/login')
}
</script>
