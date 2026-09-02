<template>
  <NavBar />
  <main class="main-content">
    <RouterView />
  </main>
</template>

<script setup>
import NavBar from '@/components/NavBar.vue'
import { RouterView } from 'vue-router'
</script>

<style scoped>
.main-content {
  padding: 1.5rem 0 3rem;
}
</style>
