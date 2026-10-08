<template>
  <header class="navbar">
    <div class="nav-container">
      <router-link to="/beranda" class="logo">
        <span class="logo-mark">
          <AppIcon name="droplet" :size="16" :stroke-width="2.2" />
        </span>
        CuciMesin
      </router-link>

      <nav>
        <ul class="nav-links" :class="{ open: menuOpen }">
          <li><router-link to="/beranda" @click="closeMenu">Beranda</router-link></li>
          <li><router-link to="/layanan" @click="closeMenu">Layanan</router-link></li>
          <li><router-link to="/booking" @click="closeMenu">Booking</router-link></li>
          <li><router-link to="/status" @click="closeMenu">Status</router-link></li>
          <li><router-link to="/profil" @click="closeMenu">Profil</router-link></li>
        </ul>
      </nav>

      <div class="nav-actions">
        <button class="btn-logout" @click="logout">
          <AppIcon name="logout" :size="16" />
          <span>Logout</span>
        </button>
        <button class="hamburger" @click="menuOpen = !menuOpen" aria-label="Menu">
          <AppIcon :name="menuOpen ? 'x' : 'menu'" :size="22" />
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AppIcon from './AppIcon.vue'

const router = useRouter()
const menuOpen = ref(false)

function closeMenu() { menuOpen.value = false }

function logout() {
  if (!confirm('Yakin mau keluar?')) return
  localStorage.removeItem('cucimesin_user')
  router.push('/login')
}
</script>

<style scoped>
.btn-logout {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}
.hamburger {
  display: none;
  align-items: center;
  justify-content: center;
  padding: 8px;
  color: var(--text);
}
@media (max-width: 640px) {
  .hamburger { display: inline-flex; }
  .btn-logout span { display: none; }
}
</style>
