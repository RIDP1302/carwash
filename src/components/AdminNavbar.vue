<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/admin/dashboard" class="logo">
        <span class="logo-mark">
          <AppIcon name="settings" :size="16" :stroke-width="2.2" />
        </span>
        Admin CuciMesin
      </router-link>

      <nav>
        <ul class="nav-links">
          <li><router-link to="/admin/dashboard">Dashboard</router-link></li>
          <li><router-link to="/admin/order">Order</router-link></li>
          <li><router-link to="/admin/pelanggan">Pelanggan</router-link></li>
          <li><router-link to="/admin/teknisi">Teknisi</router-link></li>
          <li><router-link to="/admin/laporan">Laporan</router-link></li>
          <li><router-link to="/admin/keuangan">Keuangan</router-link></li>
          <li><router-link to="/admin/pengaturan">Pengaturan</router-link></li>
        </ul>
      </nav>

      <div class="nav-actions">
        <span v-if="user" class="user-info">
          <span class="user-badge">{{ user.role }}</span>
          <span class="user-name">{{ user.nama }}</span>
        </span>
        <button class="btn-logout" @click="logout">
          <AppIcon name="logout" :size="16" />
          <span>Keluar</span>
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AppIcon from './AppIcon.vue'

const router = useRouter()
const user = ref(null)

onMounted(() => {
  const raw = localStorage.getItem('cucimesin_user')
  if (raw) user.value = JSON.parse(raw)
})

function logout() {
  if (!confirm('Yakin mau keluar?')) return
  localStorage.removeItem('cucimesin_user')
  router.push('/login')
}
</script>

<style scoped>
.nav-actions { display: flex; align-items: center; gap: 12px; }
.user-info {
  display: flex; align-items: center; gap: 8px;
  color: var(--text-light); font-size: 0.85rem;
}
.user-badge {
  background: linear-gradient(135deg, var(--primary), var(--accent));
  color: white;
  font-weight: 800;
  padding: 3px 10px;
  border-radius: 999px;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.btn-logout {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}
@media (max-width: 768px) {
  .user-name { display: none; }
  .btn-logout span { display: none; }
}
</style>
