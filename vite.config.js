import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    open: true,
    // Matikan cache untuk file di public/ biar PNG baru langsung muncul
    headers: {
      'Cache-Control': 'no-store, no-cache, must-revalidate'
    }
  },
  // Pastikan asset public tidak di-hash
  publicDir: 'public',
  build: {
    assetsInlineLimit: 0
  }
})
