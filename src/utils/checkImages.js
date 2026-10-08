// Debug helper — cek PNG mana yang ada & mana yang tidak
// Pakai di console browser: import { checkImages } from '@/utils/checkImages'
import { IMAGES } from '../data/images'

export async function checkImages() {
  const results = []

  async function test(path, label) {
    try {
      const res = await fetch(path, { method: 'HEAD' })
      results.push({ label, path, ok: res.ok, status: res.status })
    } catch (e) {
      results.push({ label, path, ok: false, status: 'error' })
    }
  }

  for (const [k, v] of Object.entries(IMAGES.hero)) await test(v, `hero/${k}`)
  for (const [k, v] of Object.entries(IMAGES.cards)) await test(v, `cards/${k}`)
  for (const [k, v] of Object.entries(IMAGES.packages)) await test(v, `packages/${k}`)
  for (const [k, v] of Object.entries(IMAGES.articles)) await test(v, `articles/${k}`)

  console.table(results)
  return results
}
