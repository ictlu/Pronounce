<template>
  <div class="container">
    <div class="page-header">
      <h1>文献阅读</h1>
      <span class="badge">{{ store.literature.length }} 篇</span>
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
        placeholder="搜索文章标题、分类或关键词…"
        @input="currentPage = 1"
      />

      <div v-if="paged.length === 0" class="empty-state">
        <div class="icon">🔍</div><p>没有匹配的文章</p>
      </div>

      <ul v-else class="lit-list">
        <li v-for="article in paged" :key="article.id">
          <RouterLink :to="`/literature/${article.id}`" class="lit-item">
            <div class="lit-meta">
              <span class="lit-category">{{ article.category }}</span>
              <span class="lit-year">{{ article.year }}</span>
            </div>
            <div class="lit-body">
              <div class="lit-title">{{ article.title }}</div>
              <div v-if="article.title_chinese" class="lit-title-zh">{{ article.title_chinese }}</div>
            </div>
            <span class="lit-arrow">›</span>
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
const PAGE_SIZE = 20

const filtered = computed(() => {
  if (!query.value.trim()) return store.literature
  const q = query.value.trim().toLowerCase()
  return store.literature.filter(a =>
    a.title?.toLowerCase().includes(q) ||
    a.title_chinese?.includes(q) ||
    a.category?.includes(q) ||
    a.topic?.toLowerCase().includes(q)
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

.lit-list {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.lit-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 0.9rem 1rem;
  color: var(--color-text);
  transition: border-color 0.15s, box-shadow 0.15s;
}
.lit-item:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow);
}
.lit-meta {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
  min-width: 72px;
  flex-shrink: 0;
}
.lit-category {
  font-weight: 700;
  font-size: 0.75rem;
  color: var(--color-primary);
  background: #eff6ff;
  border-radius: 4px;
  padding: 0.15rem 0.4rem;
  text-align: center;
  word-break: keep-all;
}
.lit-year {
  font-size: 0.75rem;
  color: var(--color-text-muted);
}
.lit-body { flex: 1; }
.lit-title {
  font-weight: 600;
  font-size: 0.92rem;
  line-height: 1.4;
}
.lit-title-zh {
  font-size: 0.82rem;
  color: var(--color-text-muted);
  margin-top: 0.2rem;
  line-height: 1.4;
}
.lit-arrow {
  font-size: 1.2rem;
  color: var(--color-text-muted);
  align-self: center;
}
</style>
