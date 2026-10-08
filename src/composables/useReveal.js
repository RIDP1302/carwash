import { onMounted } from 'vue'

/**
 * Reveal ringan — langsung tampil, tidak perlu refresh.
 * Kalau browser lambat / tidak support observer → tampil semua.
 */
export function useReveal() {
  onMounted(() => {
    const els = document.querySelectorAll('.reveal')

    // Failsafe 1: tidak ada observer → langsung tampil
    if (!('IntersectionObserver' in window)) {
      els.forEach((el) => el.classList.add('active'))
      return
    }

    // Failsafe 2: kalau elemen sudah di viewport → langsung aktif
    els.forEach((el) => {
      const rect = el.getBoundingClientRect()
      if (rect.top < window.innerHeight && rect.bottom > 0) {
        el.classList.add('active')
      }
    })

    // Observer untuk yang belum kelihatan
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('active')
            observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.05, rootMargin: '0px 0px -30px 0px' }
    )

    els.forEach((el) => {
      if (!el.classList.contains('active')) observer.observe(el)
    })

    // Failsafe 3: 500ms kemudian, paksa tampil yang masih dekat viewport
    setTimeout(() => {
      document.querySelectorAll('.reveal:not(.active)').forEach((el) => {
        const rect = el.getBoundingClientRect()
        if (rect.top < window.innerHeight * 1.5) {
          el.classList.add('active')
        }
      })
    }, 500)
  })
}
