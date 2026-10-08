export const ACCOUNTS = [
  { username: 'admin',     password: 'admin123',     nama: 'Administrator', role: 'admin',     redirect: '/admin/dashboard',      badge: 'ADMIN',     color: '#e11d48' },
  { username: 'teknisi',   password: 'teknisi123',   nama: 'Dedi Setiadi',  role: 'teknisi',   redirect: '/admin/teknisi/tugas',  badge: 'TEKNISI',   color: '#4f6bff' },
  { username: 'kasir',     password: 'kasir123',     nama: 'Rina Kasir',    role: 'kasir',     redirect: '/admin/keuangan',       badge: 'KASIR',     color: '#16a34a' },
  { username: 'pelanggan', password: 'pelanggan123', nama: 'Budi Santoso',  role: 'pelanggan', redirect: '/beranda',              badge: 'PELANGGAN', color: '#f59e0b' }
]

export function findAccount(username, password) {
  return ACCOUNTS.find(
    (a) => a.username === username.trim().toLowerCase() && a.password === password
  ) || null
}
