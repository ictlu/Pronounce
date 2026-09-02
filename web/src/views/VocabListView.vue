<template>
  <div class="container">
    <div class="page-header">
      <h1>核心词汇</h1>
      <span class="badge">{{ store.vocabulary.length }} 条</span>
    </div>

    <div v-if="store.loading" class="empty-state">
      <div class="icon">⏳</div><p>加载中…</p>
    </div>
    <div v-else-if="store.error" class="empty-state">
      <div class="icon">❌</div><p>加载失败：{{ store.error }}</p>
    </div>
    <template v-else>
      <input
        v-model="query"
        class="search-input"
        placeholder="搜索英文单词或中文释义…"
        @input="currentPage = 1"
      />

      <div v-if="paged.length === 0" class="empty-state">
        <div class="icon">🔍</div><p>没有匹配的词条</p>
      </div>

      <ul v-else class="vocab-list">
        <li v-for="item in paged" :key="item.id">
          <RouterLink :to="`/vocab/${item.id}`" class="vocab-item">
            <div class="vocab-left">
              <span class="vocab-en">{{ item.english }}</span>
              <span v-if="item.ipa" class="vocab-phonetic">{{ item.ipa }}</span>
            </div>
            <div class="vocab-zh">{{ item.chinese }}</div>
            <span class="vocab-arrow">›</span>
          </RouterLink>
        </li>
      </ul>

      <div class="pagination" v-if="totalPages > 1">
        <button @click="currentPage--" :disabled="currentPage <= 1">‹ 上一页</button>
        <span>{{ currentPage }} / {{ totalPages }}</span>
        <button @click="currentPage++" :disabled="currentPage >= totalPages">下一页 ›</button>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useContentStore } from '@/store/content.js'

const store = useContentStore()
onMounted(() => store.loadContent())

const query = ref('')
const currentPage = ref(1)
const PAGE_SIZE = 30

const filtered = computed(() => {
  if (!query.value.trim()) return store.vocabulary
  const q = query.value.trim().toLowerCase()
  return store.vocabulary.filter(v =>
    v.english?.toLowerCase().includes(q) ||
    v.chinese?.includes(q) ||
    v.phonetic?.toLowerCase().includes(q)
  )
})

const totalPages = computed(() => Math.max(1, Math.ceil(filtered.value.length / PAGE_SIZE)))
const paged = computed(() => {
  const start = (currentPage.value - 1) * PAGE_SIZE
  return filtered.value.slice(start, start + PAGE_SIZE)
})
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
}
.page-header h1 { font-size: 1.5rem; font-weight: 800; }

.search-input { margin-bottom: 1rem; }

.vocab-list {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.vocab-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 0.75rem 1rem;
  color: var(--color-text);
  transition: border-color 0.15s, box-shadow 0.15s;
}
.vocab-item:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow);
}
.vocab-left {
  display: flex;
  flex-direction: column;
  min-width: 140px;
}
.vocab-en {
  font-weight: 600;
  font-size: 1rem;
}
.vocab-phonetic {
  font-size: 0.78rem;
  color: var(--color-text-muted);
  font-style: italic;
}
.vocab-zh {
  flex: 1;
  font-size: 0.9rem;
  color: var(--color-text-muted);
}
.vocab-arrow {
  font-size: 1.2rem;
  color: var(--color-text-muted);
}
</style>
