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
      <!-- 视图切换 Tab -->
      <div class="view-tabs">
        <button
          v-for="tab in ['directory', 'list']"
          :key="tab"
          class="view-tab"
          :class="{ active: viewMode === tab }"
          @click="viewMode = tab; query = ''"
        >
          {{ tab === 'directory' ? '📂 目录视图' : '📋 列表视图' }}
        </button>
      </div>

      <!-- ===== 目录视图 ===== -->
      <template v-if="viewMode === 'directory'">
        <div class="dir-section" v-for="cat in categoryOrder" :key="cat">
          <button class="dir-header" @click="toggleSection(cat)">
            <span class="dir-icon">{{ openSections[cat] ? '▼' : '›' }}</span>
            <span class="dir-title">{{ cat }}</span>
            <span class="dir-count">{{ categoryGroups[cat]?.length ?? 0 }} 篇</span>
          </button>
          <ul v-if="openSections[cat]" class="lit-list dir-list">
            <li v-for="article in categoryGroups[cat]" :key="article.id">
              <RouterLink :to="`/literature/${article.id}`" class="lit-item">
                <div class="lit-body">
                  <div class="lit-title">{{ article.title }}</div>
                  <div v-if="article.title_chinese" class="lit-title-zh">{{ article.title_chinese }}</div>
                </div>
                <div class="lit-year" v-if="article.year">{{ article.year }}</div>
                <span class="lit-arrow">›</span>
              </RouterLink>
            </li>
          </ul>
        </div>
      </template>

      <!-- ===== 列表视图 ===== -->
      <template v-else>
        <!-- 搜索 + 分类筛选 -->
        <input
          v-model="query"
          class="search-input"
          placeholder="搜索文章标题或关键词…"
          @input="currentPage = 1; activeCategory = 'all'"
        />

        <!-- 分类快捷筛选 -->
        <div class="cat-chips">
          <button
            class="cat-chip"
            :class="{ active: activeCategory === 'all' }"
            @click="activeCategory = 'all'; currentPage = 1"
          >全部</button>
          <button
            v-for="cat in categoryOrder"
            :key="cat"
            class="cat-chip"
            :class="{ active: activeCategory === cat }"
            @click="activeCategory = cat; currentPage = 1"
          >{{ cat }} ({{ categoryGroups[cat]?.length ?? 0 }})</button>
        </div>

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
    </template>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useContentStore } from '@/store/content.js'

const store = useContentStore()
onMounted(() => store.loadContent())

const viewMode = ref('directory')

// 按 category 分组
const categoryGroups = computed(() => {
  const groups = {}
  store.literature.forEach(a => {
    if (!groups[a.category]) groups[a.category] = []
    groups[a.category].push(a)
  })
  return groups
})

// 按文章数量降序排列的分类顺序
const categoryOrder = computed(() =>
  Object.keys(categoryGroups.value).sort(
    (a, b) => (categoryGroups.value[b]?.length ?? 0) - (categoryGroups.value[a]?.length ?? 0)
  )
)

// 目录折叠状态（默认展开第一个）
const openSections = reactive({})
function toggleSection(cat) {
  openSections[cat] = !openSections[cat]
}
// 在 categoryOrder 首次计算后自动展开第一个
import { watch } from 'vue'
watch(categoryOrder, (order) => {
  if (order.length > 0 && !openSections[order[0]]) {
    openSections[order[0]] = true
  }
}, { immediate: true })

// 列表视图
const query = ref('')
const activeCategory = ref('all')
const currentPage = ref(1)
const PAGE_SIZE = 20

const listBase = computed(() => {
  if (activeCategory.value === 'all') return store.literature
  return categoryGroups.value[activeCategory.value] ?? []
})

const filtered = computed(() => {
  if (!query.value.trim()) return listBase.value
  const q = query.value.trim().toLowerCase()
  return listBase.value.filter(a =>
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

/* 视图切换 */
.view-tabs {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
  background: var(--color-bg);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 0.25rem;
}
.view-tab {
  flex: 1;
  padding: 0.45rem 0.75rem;
  border-radius: calc(var(--radius) - 2px);
  font-size: 0.88rem;
  font-weight: 500;
  color: var(--color-text-muted);
  transition: background 0.15s, color 0.15s;
}
.view-tab.active {
  background: var(--color-surface);
  color: var(--color-primary);
  box-shadow: var(--shadow);
}

/* 目录视图 */
.dir-section {
  margin-bottom: 0.5rem;
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  overflow: hidden;
}
.dir-header {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.8rem 1rem;
  background: var(--color-surface);
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.15s;
}
.dir-header:hover { background: var(--color-bg); }
.dir-icon { font-size: 0.8rem; color: var(--color-text-muted); width: 1em; }
.dir-title { flex: 1; text-align: left; }
.dir-count { font-size: 0.8rem; color: var(--color-text-muted); font-weight: 400; }
.dir-list { border-top: 1px solid var(--color-border); }

/* 分类 chips */
.cat-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 0.35rem;
  margin-bottom: 1rem;
}
.cat-chip {
  padding: 0.25rem 0.7rem;
  border: 1px solid var(--color-border);
  border-radius: 999px;
  font-size: 0.78rem;
  background: var(--color-surface);
  color: var(--color-text-muted);
  transition: all 0.15s;
  white-space: nowrap;
}
.cat-chip.active, .cat-chip:hover {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: #fff;
}

/* 文献列表 */
.lit-list { list-style: none; }
.lit-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 0.9rem 1rem;
  margin-bottom: 0.4rem;
  color: var(--color-text);
  transition: border-color 0.15s, box-shadow 0.15s;
}
.dir-list .lit-item {
  border-radius: 0;
  border: none;
  border-bottom: 1px solid var(--color-border);
  margin-bottom: 0;
}
.dir-list li:last-child .lit-item { border-bottom: none; }
.lit-item:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow);
}
.lit-meta {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.2rem;
  min-width: 72px;
  flex-shrink: 0;
}
.lit-category {
  font-weight: 700;
  font-size: 0.72rem;
  color: var(--color-primary);
  background: #eff6ff;
  border-radius: 4px;
  padding: 0.12rem 0.35rem;
  text-align: center;
  word-break: keep-all;
}
.lit-year { font-size: 0.72rem; color: var(--color-text-muted); }
.lit-body { flex: 1; }
.lit-title { font-weight: 600; font-size: 0.9rem; line-height: 1.4; }
.lit-title-zh { font-size: 0.8rem; color: var(--color-text-muted); margin-top: 0.15rem; line-height: 1.4; }
.lit-arrow { font-size: 1.2rem; color: var(--color-text-muted); flex-shrink: 0; }
</style>
