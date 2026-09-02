<template>
  <div class="container">
    <button class="back-btn btn btn-outline" @click="router.back()">‹ 返回</button>

    <div v-if="store.loading" class="empty-state">
      <div class="icon">⏳</div><p>加载中…</p>
    </div>
    <div v-else-if="!article" class="empty-state">
      <div class="icon">❓</div><p>未找到文章</p>
    </div>
    <div v-else>
      <!-- 文章头部 -->
      <div class="article-header card">
        <div class="article-meta">
          <span class="badge">{{ article.category }}</span>
          <span class="meta-journal" v-if="article.journal">{{ article.journal }}</span>
          <span class="meta-year" v-if="article.year">{{ article.year }}</span>
        </div>
        <h1 class="article-title">{{ article.title }}</h1>
        <p v-if="article.title_chinese" class="article-title-zh">{{ article.title_chinese }}</p>
      </div>

      <!-- 段落列表 -->
      <div class="paragraphs">
        <div
          v-for="(para, idx) in article.paragraphs"
          :key="para.id"
          class="para-card card"
        >
          <div class="para-num">段落 {{ idx + 1 }}</div>

          <!-- 英文段落 + 朗读 -->
          <div class="para-en-row">
            <p class="para-en">{{ para.english }}</p>
            <SpeakButton :text="para.english" label="朗读" :rate="0.88" />
          </div>

          <!-- 中文翻译 -->
          <div class="para-toggle">
            <button class="btn btn-outline toggle-btn" @click="toggleZh(para.id)">
              {{ showZh[para.id] ? '▲ 收起中文' : '▼ 显示中文翻译' }}
            </button>
          </div>
          <p v-if="showZh[para.id]" class="para-zh">{{ para.chinese }}</p>

          <!-- 段落词汇 -->
          <div v-if="para.vocabulary?.length" class="para-vocab">
            <span class="vocab-label">段落词汇：</span>
            <span
              v-for="word in para.vocabulary"
              :key="word"
              class="vocab-chip"
              @click="speakWord(word)"
              title="点击发音"
            >{{ word }}</span>
          </div>
        </div>
      </div>

      <!-- 文章词汇表 -->
      <div v-if="article.vocabulary?.length" class="article-vocab-section card">
        <h2 class="section-title">文章词汇表</h2>
        <ul class="article-vocab-list">
          <li v-for="v in article.vocabulary" :key="v.id" class="article-vocab-item">
            <div class="av-en-row">
              <span class="av-en">{{ v.english }}</span>
              <span v-if="v.ipa" class="av-ipa">{{ v.ipa }}</span>
              <SpeakButton :text="v.english" label="" />
            </div>
            <span class="av-zh">{{ v.chinese }}</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useContentStore } from '@/store/content.js'
import SpeakButton from '@/components/SpeakButton.vue'
import { speak } from '@/services/speech.js'

const props = defineProps({ id: { type: String, required: true } })
const store = useContentStore()
const router = useRouter()

onMounted(() => store.loadContent())

const article = computed(() => store.litById[props.id])

// 每段中文显示状态
const showZh = reactive({})
function toggleZh(paraId) {
  showZh[paraId] = !showZh[paraId]
}

function speakWord(word) {
  speak(word, 'en-US', 0.85)
}
</script>

<style scoped>
.back-btn { margin-bottom: 1rem; }

.article-header { margin-bottom: 1.25rem; }

.article-meta {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  flex-wrap: wrap;
  margin-bottom: 0.6rem;
}
.meta-journal {
  font-size: 0.82rem;
  color: var(--color-text-muted);
  font-style: italic;
}
.meta-year {
  font-size: 0.82rem;
  color: var(--color-text-muted);
}
.article-title {
  font-size: 1.2rem;
  font-weight: 700;
  line-height: 1.5;
}
.article-title-zh {
  font-size: 0.95rem;
  color: var(--color-text-muted);
  margin-top: 0.4rem;
  line-height: 1.5;
}

.paragraphs {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 1.25rem;
}

.para-card { }

.para-num {
  font-size: 0.75rem;
  color: var(--color-text-muted);
  font-weight: 700;
  margin-bottom: 0.5rem;
}
.para-en-row {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
}
.para-en {
  flex: 1;
  line-height: 1.8;
  font-size: 0.95rem;
}
.para-toggle { margin-top: 0.75rem; }
.toggle-btn { font-size: 0.82rem; padding: 0.3rem 0.7rem; }

.para-zh {
  margin-top: 0.75rem;
  line-height: 1.8;
  font-size: 0.9rem;
  color: var(--color-text-muted);
  border-left: 3px solid var(--color-primary);
  padding-left: 0.75rem;
  background: #f0f9ff;
  border-radius: 0 4px 4px 0;
  padding: 0.5rem 0.75rem;
}

.para-vocab {
  margin-top: 0.75rem;
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  align-items: center;
}
.vocab-label {
  font-size: 0.78rem;
  color: var(--color-text-muted);
  font-weight: 600;
}
.vocab-chip {
  font-size: 0.8rem;
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  color: #166534;
  border-radius: 4px;
  padding: 0.15rem 0.5rem;
  cursor: pointer;
  transition: background 0.15s;
}
.vocab-chip:hover { background: #dcfce7; }

.article-vocab-section { }
.section-title {
  font-size: 0.78rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--color-text-muted);
  margin-bottom: 0.75rem;
}
.article-vocab-list {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}
.article-vocab-item {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
  padding: 0.5rem 0;
  border-bottom: 1px solid var(--color-border);
}
.article-vocab-item:last-child { border-bottom: none; }
.av-en-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}
.av-en {
  font-weight: 600;
  font-size: 0.95rem;
}
.av-ipa {
  font-style: italic;
  color: var(--color-text-muted);
  font-size: 0.82rem;
}
.av-zh {
  font-size: 0.88rem;
  color: var(--color-text-muted);
}
</style>
