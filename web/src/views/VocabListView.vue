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
        <div class="dir-section" v-for="freq in FREQ_ORDER" :key="freq">
          <button class="dir-header" @click="toggleSection(freq)">
            <span class="dir-icon">{{ openSections[freq] ? '▼' : '›' }}</span>
            <span class="freq-dot" :class="freqClass(freq)"></span>
            <span class="dir-title">{{ freq }}</span>
            <span class="dir-count">{{ freqGroups[freq]?.length ?? 0 }} 条</span>
          </button>
          <ul v-if="openSections[freq]" class="vocab-list dir-list">
            <li v-for="item in freqGroups[freq]" :key="item.id">
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
        </div>
      </template>

      <!-- ===== 列表视图 ===== -->
      <template v-else>
        <!-- 搜索框 -->
        <input
          v-model="query"
          class="search-input"
          placeholder="搜索英文单词或中文释义…"
          @input="currentPage = 1"
        />

        <!-- 频率 Tab 过滤 -->
        <div class="freq-tabs">
          <button
            class="freq-tab"
            :class="{ active: activeFreq === 'all' }"
            @click="activeFreq = 'all'; currentPage = 1"
          >全部 ({{ store.vocabulary.length }})</button>
          <button
            v-for="f in FREQ_ORDER.filter(f => f !== '未标注')"
            :key="f"
            class="freq-tab"
            :class="[{ active: activeFreq === f }, freqClass(f)]"
            @click="activeFreq = f; currentPage = 1"
          >{{ f }} ({{ freqGroups[f]?.length ?? 0 }})</button>
        </div>

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
              <span class="freq-dot" :class="freqClass(normalizeFreq(item.frequency))"></span>
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
    </template>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useContentStore } from '@/store/content.js'
import { normalizeFreq, FREQ_ORDER } from '@/utils/normalize.js'

const store = useContentStore()
onMounted(() => store.loadContent())

// 视图模式
const viewMode = ref('directory')

// 目录视图：折叠状态（默认全展开）
const openSections = reactive({ '高频必会': true, '中频重点': false, '低频拓展': false, '未标注': false })
function toggleSection(freq) {
  openSections[freq] = !openSections[freq]
}

// 按频率分组
const freqGroups = computed(() => {
  const groups = {}
  FREQ_ORDER.forEach(f => { groups[f] = [] })
  store.vocabulary.forEach(v => {
    const f = normalizeFreq(v.frequency)
    if (!groups[f]) groups[f] = []
    groups[f].push(v)
  })
  return groups
})

// 频率颜色 class
function freqClass(freq) {
  if (freq === '高频必会') return 'freq-high'
  if (freq === '中频重点') return 'freq-mid'
  if (freq === '低频拓展') return 'freq-low'
  return 'freq-none'
}

// 列表视图
const query = ref('')
const activeFreq = ref('all')
const currentPage = ref(1)
const PAGE_SIZE = 30

const listBase = computed(() => {
  if (activeFreq.value === 'all') return store.vocabulary
  return freqGroups.value[activeFreq.value] ?? []
})

const filtered = computed(() => {
  if (!query.value.trim()) return listBase.value
  const q = query.value.trim().toLowerCase()
  return listBase.value.filter(v =>
    v.english?.toLowerCase().includes(q) ||
    v.chinese?.includes(q) ||
    v.ipa?.toLowerCase().includes(q)
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

/* 频率颜色点 */
.freq-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
.freq-high { background: #ef4444; }
.freq-mid  { background: #f59e0b; }
.freq-low  { background: #6b7280; }
.freq-none { background: #d1d5db; }

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
.dir-count {
  font-size: 0.8rem;
  color: var(--color-text-muted);
  font-weight: 400;
}
.dir-list {
  border-top: 1px solid var(--color-border);
}
.dir-list .vocab-item {
  border-radius: 0;
  border: none;
  border-bottom: 1px solid var(--color-border);
}
.dir-list li:last-child .vocab-item { border-bottom: none; }

/* 频率 Tab 过滤 */
.freq-tabs {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  margin-bottom: 1rem;
}
.freq-tab {
  padding: 0.3rem 0.8rem;
  border: 1px solid var(--color-border);
  border-radius: 999px;
  font-size: 0.82rem;
  background: var(--color-surface);
  color: var(--color-text-muted);
  transition: all 0.15s;
  white-space: nowrap;
}
.freq-tab.active, .freq-tab:hover {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: #fff;
}
.freq-tab.freq-high.active { background: #ef4444; border-color: #ef4444; }
.freq-tab.freq-mid.active  { background: #f59e0b; border-color: #f59e0b; }
.freq-tab.freq-low.active  { background: #6b7280; border-color: #6b7280; }

/* 词汇列表 */
.search-input { margin-bottom: 0.75rem; }

.vocab-list {
  list-style: none;
  display: flex;
  flex-direction: column;
}
.vocab-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 0.75rem 1rem;
  margin-bottom: 0.4rem;
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
  min-width: 130px;
}
.vocab-en { font-weight: 600; font-size: 0.97rem; }
.vocab-phonetic { font-size: 0.76rem; color: var(--color-text-muted); font-style: italic; }
.vocab-zh { flex: 1; font-size: 0.88rem; color: var(--color-text-muted); }
.vocab-arrow { font-size: 1.2rem; color: var(--color-text-muted); }
</style>
