<template>
  <div class="container practice">
    <div class="page-header">
      <h1>发音练习</h1>
      <p class="subtitle">随机抽取词条，跟读后点击"显示答案"检查</p>
    </div>

    <div v-if="store.loading" class="empty-state">
      <div class="icon">⏳</div><p>加载中…</p>
    </div>
    <div v-else-if="store.vocabulary.length === 0" class="empty-state">
      <div class="icon">📭</div><p>暂无词汇数据</p>
    </div>
    <template v-else>
      <!-- 练习卡片 -->
      <div class="practice-card card" v-if="current">
        <div class="card-top">
          <span class="badge freq-badge" v-if="current.frequency">{{ current.frequency }}</span>
          <span class="counter">{{ practiceCount }} 题已练习</span>
        </div>

        <!-- 当前词 -->
        <div class="word-area">
          <div class="word-en">{{ current.english }}</div>
          <div class="speak-row">
            <SpeakButton :text="current.english" label="朗读单词" />
            <button class="btn btn-outline" @click="next">换一个</button>
          </div>
        </div>

        <!-- 答案区（可折叠） -->
        <div class="answer-section">
          <button class="btn btn-outline reveal-btn" @click="revealed = !revealed">
            {{ revealed ? '▲ 隐藏答案' : '▼ 显示答案' }}
          </button>

          <div v-if="revealed" class="answer-body">
            <!-- 音标 -->
            <p v-if="current.ipa" class="ans-phonetic">{{ current.ipa }}</p>

            <!-- 中文 -->
            <p class="ans-chinese">{{ current.chinese }}</p>

            <!-- 定义 -->
            <p v-if="current.definition" class="ans-definition">{{ current.definition }}</p>

            <!-- 例句 -->
            <div v-if="current.example_english" class="ans-example">
              <p class="ex-en">{{ current.example_english }}</p>
              <SpeakButton :text="current.example_english" label="朗读例句" :rate="0.85" />
              <p v-if="current.example_chinese" class="ex-zh">{{ current.example_chinese }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- 快速导航 -->
      <div class="quick-nav">
        <button class="btn btn-primary" @click="next">下一题 →</button>
        <RouterLink to="/vocab" class="btn btn-outline">浏览全部词汇</RouterLink>
      </div>

      <!-- 最近练习记录 -->
      <div class="history-section" v-if="history.length > 0">
        <h2 class="history-title">最近练习</h2>
        <ul class="history-list">
          <li v-for="item in history" :key="item.id" class="history-item">
            <RouterLink :to="`/vocab/${item.id}`" class="history-link">
              <span class="h-en">{{ item.english }}</span>
              <span class="h-zh">{{ item.chinese }}</span>
            </RouterLink>
            <SpeakButton :text="item.english" label="" />
          </li>
        </ul>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useContentStore } from '@/store/content.js'
import SpeakButton from '@/components/SpeakButton.vue'

const store = useContentStore()
onMounted(async () => {
  await store.loadContent()
  if (store.vocabulary.length > 0) pickRandom()
})

const current = ref(null)
const revealed = ref(false)
const practiceCount = ref(0)
const history = ref([])

function pickRandom() {
  const vocab = store.vocabulary
  if (!vocab.length) return
  const idx = Math.floor(Math.random() * vocab.length)
  current.value = vocab[idx]
  revealed.value = false
}

function next() {
  if (current.value) {
    history.value.unshift(current.value)
    if (history.value.length > 5) history.value.pop()
    practiceCount.value++
  }
  pickRandom()
}
</script>

<style scoped>
.practice { max-width: 680px; }

.page-header { margin-bottom: 1.5rem; }
.page-header h1 { font-size: 1.5rem; font-weight: 800; }
.subtitle { color: var(--color-text-muted); font-size: 0.9rem; margin-top: 0.25rem; }

.practice-card { margin-bottom: 1rem; }

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}
.freq-badge { background: var(--color-accent); }
.counter { font-size: 0.82rem; color: var(--color-text-muted); }

.word-area { text-align: center; padding: 1.5rem 0 1rem; }
.word-en {
  font-size: 2.5rem;
  font-weight: 900;
  color: var(--color-primary);
  letter-spacing: -0.02em;
  margin-bottom: 1rem;
}
.speak-row {
  display: flex;
  justify-content: center;
  gap: 0.75rem;
}

.answer-section { margin-top: 1rem; border-top: 1px solid var(--color-border); padding-top: 1rem; }
.reveal-btn { width: 100%; justify-content: center; }

.answer-body { margin-top: 1rem; display: flex; flex-direction: column; gap: 0.75rem; }
.ans-phonetic {
  font-style: italic;
  color: var(--color-text-muted);
  font-size: 1.05rem;
}
.ans-chinese {
  font-size: 1.2rem;
  font-weight: 600;
}
.ans-definition {
  font-size: 0.9rem;
  color: var(--color-text-muted);
  line-height: 1.7;
}
.ans-example {
  background: var(--color-bg);
  border-radius: var(--radius);
  padding: 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.ex-en {
  font-style: italic;
  font-size: 0.92rem;
  line-height: 1.6;
}
.ex-zh {
  font-size: 0.88rem;
  color: var(--color-text-muted);
}

.quick-nav {
  display: flex;
  gap: 0.75rem;
  margin-bottom: 2rem;
}

.history-section { }
.history-title {
  font-size: 0.82rem;
  font-weight: 700;
  color: var(--color-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.75rem;
}
.history-list { list-style: none; display: flex; flex-direction: column; gap: 0.5rem; }
.history-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0;
  border-bottom: 1px solid var(--color-border);
}
.history-link { flex: 1; display: flex; gap: 0.75rem; align-items: baseline; }
.h-en { font-weight: 600; font-size: 0.95rem; }
.h-zh { font-size: 0.85rem; color: var(--color-text-muted); }
</style>
