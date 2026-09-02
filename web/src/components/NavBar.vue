<template>
  <header class="navbar">
    <div class="container navbar-inner">
      <RouterLink to="/" class="navbar-brand">🩺 医学英语发音</RouterLink>
      <nav class="navbar-links">
        <RouterLink to="/vocab" active-class="active">词汇</RouterLink>
        <RouterLink to="/literature" active-class="active">文献</RouterLink>
        <RouterLink to="/practice" active-class="active">练习</RouterLink>
      </nav>
    </div>
  </header>
</template>

<script setup>
import { RouterLink } from 'vue-router'
</script>

<style scoped>
.navbar {
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
  box-shadow: var(--shadow);
  position: sticky;
  top: 0;
  z-index: 100;
}
.navbar-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 56px;
}
.navbar-brand {
  font-weight: 700;
  font-size: 1.1rem;
  color: var(--color-primary);
  letter-spacing: -0.01em;
}
.navbar-links {
  display: flex;
  gap: 1.5rem;
}
.navbar-links a {
  color: var(--color-text-muted);
  font-weight: 500;
  font-size: 0.95rem;
  padding: 0.25rem 0;
  border-bottom: 2px solid transparent;
  transition: color 0.15s, border-color 0.15s;
}
.navbar-links a:hover,
.navbar-links a.active {
  color: var(--color-primary);
  border-bottom-color: var(--color-primary);
}
</style>
