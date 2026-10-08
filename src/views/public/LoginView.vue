<template>
  <section class="login-page">
    <div class="login-grid">
      <div class="login-left">
        <p class="hero-tagline">#PASTIBERSIH, PASTITERJANGKAU</p>
        <h1 class="hero-title">
          SELAMAT<br>
          <span class="accent">DATANG.</span>
        </h1>
        <p class="hero-desc">
          Login untuk mulai booking cuci mesin, atau kelola dashboard admin
          CuciMesin.
        </p>
      </div>

      <div class="login-right">
        <form @submit.prevent="login" class="login-card">
          <h2>Masuk Aplikasi</h2>

          <div class="form-group">
            <label>Username</label>
            <input
              type="text"
              v-model="username"
              placeholder="admin / teknisi / kasir / pelanggan"
              required
              autocomplete="username"
            />
          </div>

          <div class="form-group">
            <label>Password</label>
            <input
              type="password"
              v-model="password"
              placeholder="Masukkan password"
              required
              autocomplete="current-password"
            />
          </div>

          <p v-if="errorMsg" class="error-msg">{{ errorMsg }}</p>

          <button type="submit" class="btn-primary" style="width:100%;justify-content:center">
            Masuk Aplikasi
          </button>

          <p class="login-footer">
            Belum punya akun?
            <router-link to="/daftar">Daftar</router-link>
          </p>
        </form>

        <div class="accounts-card">
          <h3>
            <AppIcon name="key" :size="18" />
            Akun Test & Admin
          </h3>
          <p class="accounts-hint">Klik kartu akun untuk mengisi form otomatis.</p>

          <div class="account-list">
            <button
              v-for="acc in accounts"
              :key="acc.username"
              type="button"
              class="account-item"
              @click="fillAccount(acc)"
            >
              <div class="account-left">
                <span class="account-badge" :style="{ background: acc.color }">
                  {{ acc.badge }}
                </span>
                <div>
                  <div class="account-username">{{ acc.username }}</div>
                  <div class="account-password">{{ acc.password }}</div>
                </div>
              </div>
              <AppIcon name="arrow-right" :size="16" class="account-arrow" />
            </button>
          </div>

          <div class="copy-section">
            <button type="button" class="btn-copy" @click="copyAll">
              <AppIcon name="copy" :size="14" />
              Salin Semua Akun
            </button>
            <span v-if="copied" class="copied-text">Tersalin!</span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AppIcon from '../../components/AppIcon.vue'
import { ACCOUNTS, findAccount } from '../../data/accounts'

const router = useRouter()
const username = ref('')
const password = ref('')
const errorMsg = ref('')
const copied = ref(false)
const accounts = ACCOUNTS

function fillAccount(acc) {
  username.value = acc.username
  password.value = acc.password
  errorMsg.value = ''
}

function login() {
  errorMsg.value = ''
  const acc = findAccount(username.value, password.value)

  if (!acc) {
    errorMsg.value = 'Username atau password salah.'
    return
  }

  localStorage.setItem('cucimesin_user', JSON.stringify({
    username: acc.username,
    nama: acc.nama,
    role: acc.role
  }))

  router.push(acc.redirect)
}

async function copyAll() {
  const text = accounts
    .map((a) => `${a.role.padEnd(10)} | ${a.username.padEnd(12)} | ${a.password}`)
    .join('\n')

  try {
    await navigator.clipboard.writeText(text)
  } catch (e) {
    const ta = document.createElement('textarea')
    ta.value = text
    document.body.appendChild(ta)
    ta.select()
    document.execCommand('copy')
    ta.remove()
  }
  copied.value = true
  setTimeout(() => (copied.value = false), 2000)
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  padding: 40px 32px;
  background: linear-gradient(180deg, #ffffff 0%, var(--cream) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}
.login-grid {
  max-width: 1200px;
  width: 100%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
  align-items: center;
}
.login-left { max-width: 480px; }

.login-card {
  background: white;
  border-radius: var(--radius);
  padding: 40px;
  box-shadow: var(--shadow-md);
}
.login-card h2 {
  color: var(--navy);
  font-size: 1.4rem;
  margin-bottom: 24px;
  text-align: center;
}
.login-footer {
  text-align: center;
  margin-top: 16px;
  color: var(--text-light);
  font-size: 0.88rem;
}
.login-footer a {
  color: var(--primary);
  font-weight: 600;
}

.accounts-card {
  background: white;
  border-radius: var(--radius);
  padding: 28px;
  box-shadow: var(--shadow-sm);
  margin-top: 20px;
}
.accounts-card h3 {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--navy);
  font-size: 1rem;
  margin-bottom: 8px;
}
.accounts-hint {
  color: var(--text-light);
  font-size: 0.82rem;
  margin-bottom: 14px;
}

.account-list { display: flex; flex-direction: column; gap: 8px; }

.account-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 14px;
  background: var(--cream);
  border: 1.5px solid rgba(15, 21, 53, 0.06);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
  text-align: left;
  color: var(--text);
  width: 100%;
  font-family: inherit;
}
.account-item:hover {
  background: var(--primary-light);
  border-color: var(--primary);
}

.account-left { display: flex; align-items: center; gap: 12px; }
.account-badge {
  font-size: 0.65rem;
  font-weight: 800;
  letter-spacing: 1px;
  padding: 4px 10px;
  border-radius: 6px;
  color: white;
  min-width: 72px;
  text-align: center;
}
.account-username { font-weight: 700; font-size: 0.9rem; color: var(--navy); }
.account-password { font-family: monospace; color: var(--text-light); font-size: 0.78rem; }
.account-arrow { color: var(--primary); transition: transform 0.2s; }
.account-item:hover .account-arrow { transform: translateX(4px); }

.copy-section {
  display: flex; align-items: center; gap: 10px;
  margin-top: 14px;
}
.btn-copy {
  flex: 1;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 10px;
  border-radius: 10px;
  border: 1.5px dashed rgba(79, 107, 255, 0.4);
  background: transparent;
  color: var(--primary);
  font-size: 0.85rem;
  font-weight: 600;
  transition: 0.2s;
  font-family: inherit;
}
.btn-copy:hover {
  background: var(--primary-light);
  border-style: solid;
}
.copied-text {
  color: #16a34a;
  font-size: 0.82rem;
  font-weight: 700;
}

.error-msg {
  color: #e11d48;
  font-size: 0.85rem;
  margin-bottom: 12px;
  padding: 10px 14px;
  background: #ffe4e8;
  border-radius: 10px;
  border: 1px solid #ffc9d3;
}

@media (max-width: 900px) {
  .login-grid { grid-template-columns: 1fr; gap: 32px; }
  .login-left { text-align: center; margin: 0 auto; }
  .login-page { padding: 60px 20px; }
}
</style>
