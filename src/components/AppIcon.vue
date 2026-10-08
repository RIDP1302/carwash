<template>
  <svg
    :width="size"
    :height="size"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    :stroke-width="strokeWidth"
    stroke-linecap="round"
    stroke-linejoin="round"
    class="app-icon"
    aria-hidden="true"
  >
    <!-- location / pilihan -->
    <template v-if="name === 'location'">
      <path d="M12 22s7-6.5 7-12a7 7 0 1 0-14 0c0 5.5 7 12 7 12z" />
      <circle cx="12" cy="10" r="2.5" />
    </template>

    <!-- calendar / booking -->
    <template v-else-if="name === 'calendar'">
      <rect x="3" y="4.5" width="18" height="16" rx="2" />
      <path d="M3 9h18M8 3v3M16 3v3" />
      <circle cx="12" cy="14.5" r="1.2" fill="currentColor" stroke="none" />
    </template>

    <!-- user-check / teknisi -->
    <template v-else-if="name === 'user-check'">
      <circle cx="9" cy="8" r="3.5" />
      <path d="M3 20c0-3.3 2.7-6 6-6s6 2.7 6 6" />
      <path d="M16 11l2 2 4-4" />
    </template>

    <!-- droplet / wash -->
    <template v-else-if="name === 'droplet'">
      <path d="M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z" />
    </template>

    <!-- shield / garansi -->
    <template v-else-if="name === 'shield'">
      <path d="M12 3l8 3v6c0 4.5-3.4 8.3-8 9-4.6-.7-8-4.5-8-9V6l8-3z" />
      <path d="M9 12l2 2 4-4" />
    </template>

    <!-- gear / pengaturan -->
    <template v-else-if="name === 'settings'">
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1-1.5 1.7 1.7 0 0 0-1.9.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.9 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1 1.7 1.7 0 0 0-.3-1.9l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.9.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.9-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.9V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z" />
    </template>

    <!-- search -->
    <template v-else-if="name === 'search'">
      <circle cx="11" cy="11" r="7" />
      <path d="M21 21l-4.3-4.3" />
    </template>

    <!-- arrow-right -->
    <template v-else-if="name === 'arrow-right'">
      <path d="M5 12h14M13 6l6 6-6 6" />
    </template>

    <!-- check -->
    <template v-else-if="name === 'check'">
      <path d="M5 12l5 5L20 7" />
    </template>

    <!-- star -->
    <template v-else-if="name === 'star'">
      <path d="M12 3l2.9 6 6.6.9-4.8 4.6 1.1 6.5L12 18l-5.8 3 1.1-6.5L2.5 9.9 9.1 9z" fill="currentColor" stroke="none" />
    </template>

    <!-- mail -->
    <template v-else-if="name === 'mail'">
      <rect x="3" y="5" width="18" height="14" rx="2" />
      <path d="M3 7l9 6 9-6" />
    </template>

    <!-- phone -->
    <template v-else-if="name === 'phone'">
      <path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .3 2 .6 2.9a2 2 0 0 1-.4 2.1L8 10a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4c.9.3 1.9.5 2.9.6a2 2 0 0 1 1.7 2z" />
    </template>

    <!-- key -->
    <template v-else-if="name === 'key'">
      <circle cx="8" cy="14" r="4" />
      <path d="M10.8 11.2L21 1M17 5l3 3M15 7l3 3" />
    </template>

    <!-- logout -->
    <template v-else-if="name === 'logout'">
      <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
      <path d="M16 17l5-5-5-5M21 12H9" />
    </template>

    <!-- dashboard -->
    <template v-else-if="name === 'dashboard'">
      <rect x="3" y="3" width="7" height="9" rx="1.5" />
      <rect x="14" y="3" width="7" height="5" rx="1.5" />
      <rect x="14" y="12" width="7" height="9" rx="1.5" />
      <rect x="3" y="16" width="7" height="5" rx="1.5" />
    </template>

    <!-- clipboard / order -->
    <template v-else-if="name === 'clipboard'">
      <rect x="5" y="4" width="14" height="18" rx="2" />
      <path d="M9 4h6v3H9zM9 12h6M9 16h4" />
    </template>

    <!-- users -->
    <template v-else-if="name === 'users'">
      <circle cx="9" cy="8" r="3.5" />
      <path d="M2.5 20c0-3.3 2.9-6 6.5-6s6.5 2.7 6.5 6" />
      <path d="M17 11a3 3 0 1 0 0-6M22 20c0-2.5-1.6-4.6-3.8-5.4" />
    </template>

    <!-- chart / laporan -->
    <template v-else-if="name === 'chart'">
      <path d="M4 20V10M10 20V4M16 20v-8M22 20H2" />
    </template>

    <!-- wallet / keuangan -->
    <template v-else-if="name === 'wallet'">
      <rect x="3" y="6" width="18" height="14" rx="2.5" />
      <path d="M3 10h18" />
      <circle cx="17" cy="15" r="1.3" fill="currentColor" stroke="none" />
    </template>

    <!-- plus -->
    <template v-else-if="name === 'plus'">
      <path d="M12 5v14M5 12h14" />
    </template>

    <!-- menu -->
    <template v-else-if="name === 'menu'">
      <path d="M4 7h16M4 12h16M4 17h16" />
    </template>

    <!-- x -->
    <template v-else-if="name === 'x'">
      <path d="M6 6l12 12M18 6L6 18" />
    </template>

    <!-- camera -->
    <template v-else-if="name === 'camera'">
      <path d="M4 8h3l2-3h6l2 3h3v11H4z" />
      <circle cx="12" cy="13" r="3.5" />
    </template>

    <!-- clock -->
    <template v-else-if="name === 'clock'">
      <circle cx="12" cy="12" r="9" />
      <path d="M12 7v5l3 2" />
    </template>

    <!-- download -->
    <template v-else-if="name === 'download'">
      <path d="M12 3v12M7 10l5 5 5-5M5 21h14" />
    </template>

    <!-- copy -->
    <template v-else-if="name === 'copy'">
      <rect x="9" y="9" width="12" height="12" rx="2" />
      <path d="M5 15V5a2 2 0 0 1 2-2h10" />
    </template>

    <!-- fallback -->
    <template v-else>
      <circle cx="12" cy="12" r="9" />
    </template>
  </svg>
</template>

<script setup>
defineProps({
  name:        { type: String, required: true },
  size:        { type: [Number, String], default: 20 },
  strokeWidth: { type: [Number, String], default: 1.8 }
})
</script>

<style scoped>
.app-icon {
  display: inline-block;
  vertical-align: middle;
  flex-shrink: 0;
}
</style>
