// ===== Loader =====
window.addEventListener('load', () => {
  const loader = document.getElementById('loader');
  setTimeout(() => loader.classList.add('hidden'), 900);
});

// ===== Scroll Reveal =====
const observerOptions = {
  threshold: 0.15,
  rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('active');

      // Trigger counter jika elemen stat
      if (entry.target.querySelector('.counter')) {
        startCounters(entry.target);
      }
    }
  });
}, observerOptions);

document.querySelectorAll('.reveal, .reveal-card').forEach((el, i) => {
  el.style.transitionDelay = `${i * 0.08}s`;
  observer.observe(el);
});

// ===== Counter Animation =====
function startCounters(container) {
  container.querySelectorAll('.counter').forEach(counter => {
    if (counter.dataset.done) return;
    counter.dataset.done = 'true';

    const target = +counter.dataset.target;
    const duration = 1500;
    const startTime = performance.now();

    function update(now) {
      const progress = Math.min((now - startTime) / duration, 1);
      // easeOutQuart
      const eased = 1 - Math.pow(1 - progress, 4);
      counter.textContent = Math.floor(eased * target);
      if (progress < 1) requestAnimationFrame(update);
      else counter.textContent = target;
    }
    requestAnimationFrame(update);
  });
}

// ===== Hamburger Menu =====
const hamburger = document.getElementById('hamburger');
const navLinks = document.querySelector('.nav-links');

hamburger.addEventListener('click', () => {
  navLinks.classList.toggle('open');
  hamburger.classList.toggle('active');
});

// Tutup menu saat link diklik
document.querySelectorAll('.nav-links a').forEach(link => {
  link.addEventListener('click', () => {
    navLinks.classList.remove('open');
    hamburger.classList.remove('active');
  });
});

// ===== Parallax Hero Bg =====
document.addEventListener('mousemove', (e) => {
  const bg = document.querySelector('.hero-bg');
  if (!bg) return;
  const x = (e.clientX / window.innerWidth - 0.5) * 30;
  const y = (e.clientY / window.innerHeight - 0.5) * 30;
  bg.style.transform = `translate(${x}px, ${y}px) scale(1.05)`;
});

// ===== Floating Bubbles Background =====
function createBubble() {
  const bubble = document.createElement('div');
  bubble.style.cssText = `
    position: fixed;
    bottom: -50px;
    left: ${Math.random() * 100}vw;
    width: ${Math.random() * 20 + 8}px;
    height: ${Math.random() * 20 + 8}px;
    border-radius: 50%;
    background: radial-gradient(circle at 30% 30%, rgba(0,255,163,0.8), rgba(0,194,255,0.2));
    pointer-events: none;
    z-index: 0;
    opacity: 0.5;
    animation: rise ${Math.random() * 8 + 8}s linear forwards;
  `;
  document.body.appendChild(bubble);
  setTimeout(() => bubble.remove(), 16000);
}

// Tambah keyframes rise secara dinamis
const styleSheet = document.createElement('style');
styleSheet.textContent = `
  @keyframes rise {
    to {
      transform: translateY(-110vh) translateX(${Math.random() * 100 - 50}px);
      opacity: 0;
    }
  }
`;
document.head.appendChild(styleSheet);

// Spawn bubble tiap 800ms
setInterval(createBubble, 800);