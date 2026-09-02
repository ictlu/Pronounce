<template>
  <div class="container">
    <button class="back-btn btn btn-outline" @click="router.back()">‹ 返回</button>

    <div v-if="store.loading" class="empty-state">
      <div class="icon">⏳</div><p>加载中…</p>
    </div>
    <div v-else-if="!item" class="empty-state">
      <div class="icon">❓</div><p>未找到词条</p>
    </div>
    <div v-else class="detail-card card">
      <!-- 编号 -->
      <div class="detail-num" v-if="item.number">No.{{ item.number }}</div>

      <!-- 英文 + 发音 -->
      <div class="detail-en-row">
        <h1 class="detail-en">{{ item.english }}</h1>
        <SpeakButton :text="item.english" label="发音" />
      </div>

      <!-- 音标 (IPA) -->
      <p v-if="item.ipa" class="detail-phonetic">{{ item.ipa }}</p>

      <!-- 频率标签 -->
      <p v-if="item.frequency" class="detail-freq">
        <span class="badge">{{ item.frequency }}</span>
      </p>

      <!-- 中文释义 -->
      <div class="detail-section">
        <h2 class="section-title">中文释义</h2>
        <p class="detail-chinese">{{ item.chinese }}</p>
      </div>

      <!-- 详细定义 -->
      <div v-if="item.definition" class="detail-section">
        <h2 class="section-title">定义说明</h2>
        <p class="detail-definition">{{ item.definition }}</p>
      </div>

      <!-- 例句 -->
      <div v-if="item.example_english || item.example_chinese" class="detail-section">
        <h2 class="section-title">例句</h2>
        <div v-if="item.example_english" class="example-row">
          <p class="example-en">{{ item.example_english }}</p>
          <SpeakButton :text="item.example_english" label="朗读例句" :rate="0.85" />
        </div>
        <p v-if="item.example_chinese" class="example-zh">{{ item.example_chinese }}</p>
      </div>

      <!-- 导航 -->
      <div class="nav-row">
        <RouterLink v-if="prevItem" :to="`/vocab/${prevItem.id}`" class="btn btn-outline">
          ‹ {{ prevItem.english }}
        </RouterLink>
        <span v-else />
        <RouterLink v-if="nextItem" :to="`/vocab/${nextItem.id}`" class="btn btn-outline">
          {{ nextItem.english }} ›
        </RouterLink>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { useContentStore } from '@/store/content.js'
import SpeakButton from '@/components/SpeakButton.vue'

const props = defineProps({ id: { type: String, required: true } })
const store = useContentStore()
const router = useRouter()

onMounted(() => store.loadContent())

const item = computed(() => store.vocabById[props.id])

const currentIndex = computed(() =>
  store.vocabulary.findIndex(v => v.id === props.id)
)
const prevItem = computed(() =>
  currentIndex.value > 0 ? store.vocabulary[currentIndex.value - 1] : null
)
const nextItem = computed(() =>
  currentIndex.value < store.vocabulary.length - 1
    ? store.vocabulary[currentIndex.value + 1]
    : null
)
</script>

<style scoped>
.back-btn { margin-bottom: 1rem; }

.detail-card { max-width: 680px; margin: 0 auto; }

.detail-num {
  font-size: 0.8rem;
  color: var(--color-text-muted);
  margin-bottom: 0.5rem;
}
.detail-en-row {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
  margin-bottom: 0.25rem;
}
.detail-en {
  font-size: 2rem;
  font-weight: 800;
  color: var(--color-primary);
}
.detail-phonetic {
  font-style: italic;
  color: var(--color-text-muted);
  font-size: 1.05rem;
  margin-bottom: 0.4rem;
}
.detail-freq { margin-bottom: 0.5rem; }

.detail-section {
  margin-top: 1.25rem;
  border-top: 1px solid var(--color-border);
  padding-top: 1rem;
}
.section-title {
  font-size: 0.78rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--color-text-muted);
  margin-bottom: 0.5rem;
}
.detail-chinese {
  font-size: 1.1rem;
  line-height: 1.8;
}
.detail-definition {
  font-size: 0.92rem;
  color: var(--color-text-muted);
  line-height: 1.8;
}
.example-row {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  flex-wrap: wrap;
  margin-bottom: 0.5rem;
}
.example-en {
  flex: 1;
  font-style: italic;
  font-size: 0.95rem;
  line-height: 1.7;
}
.example-zh {
  font-size: 0.9rem;
  color: var(--color-text-muted);
}
.nav-row {
  display: flex;
  justify-content: space-between;
  margin-top: 1.5rem;
  border-top: 1px solid var(--color-border);
  padding-top: 1rem;
}
</style>
