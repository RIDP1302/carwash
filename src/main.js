import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/style.css'

// Failsafe: hapus class no-js dan tambahkan js-ready
document.documentElement.classList.remove('no-js')

// js-ready ditambahkan setelah mount supaya reveal baru aktif
const app = createApp(App)
app.use(router)
app.mount('#app')

// Baru tambahkan js-ready setelah render
requestAnimationFrame(() => {
  document.documentElement.classList.add('js-ready')
})
