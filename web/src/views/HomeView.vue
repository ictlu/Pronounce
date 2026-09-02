<template>
  <div class="container home">
    <div class="hero">
      <div class="hero-icon">🩺</div>
      <h1 class="hero-title">医学英语发音学习</h1>
      <p class="hero-subtitle">内分泌科核心词汇 · 经典文献阅读 · 发音练习</p>
    </div>

    <div class="cards">
      <RouterLink to="/vocab" class="entry-card">
        <div class="entry-icon">📖</div>
        <div class="entry-body">
          <h2>核心词汇</h2>
          <p>513 个内分泌科复试核心词条，含音标、释义与发音</p>
        </div>
        <div class="entry-arrow">›</div>
      </RouterLink>

      <RouterLink to="/literature" class="entry-card">
        <div class="entry-icon">📄</div>
        <div class="entry-body">
          <h2>文献阅读</h2>
          <p>199 篇经典文献，英文原文与中文翻译对照，可逐句发音</p>
        </div>
        <div class="entry-arrow">›</div>
      </RouterLink>

      <RouterLink to="/practice" class="entry-card">
        <div class="entry-icon">🎙️</div>
        <div class="entry-body">
          <h2>发音练习</h2>
          <p>随机抽取词条，跟读练习，点击检查答案</p>
        </div>
        <div class="entry-arrow">›</div>
      </RouterLink>
    </div>

    <p class="data-note">数据来源：内分泌科复试核心词汇表 &amp; 文献翻译合集（PDF 结构化提取）</p>
  </div>
</template>

<script setup>
import { RouterLink } from 'vue-router'
</script>

<style scoped>
.home { padding-top: 2rem; }

.hero {
  text-align: center;
  margin-bottom: 2.5rem;
}
.hero-icon { font-size: 3.5rem; }
.hero-title {
  font-size: 2rem;
  font-weight: 800;
  margin-top: 0.5rem;
  background: linear-gradient(135deg, var(--color-primary), var(--color-accent));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.hero-subtitle {
  color: var(--color-text-muted);
  margin-top: 0.5rem;
  font-size: 1.05rem;
}

.cards {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.entry-card {
  display: flex;
  align-items: center;
  gap: 1.2rem;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow);
  padding: 1.2rem 1.5rem;
  color: var(--color-text);
  transition: box-shadow 0.2s, transform 0.15s, border-color 0.2s;
}
.entry-card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
  border-color: var(--color-primary);
}
.entry-icon { font-size: 2.2rem; flex-shrink: 0; }
.entry-body { flex: 1; }
.entry-body h2 { font-size: 1.1rem; font-weight: 700; }
.entry-body p { color: var(--color-text-muted); font-size: 0.9rem; margin-top: 0.2rem; }
.entry-arrow { font-size: 1.6rem; color: var(--color-text-muted); }

.data-note {
  margin-top: 2rem;
  text-align: center;
  font-size: 0.8rem;
  color: var(--color-text-muted);
}
</style>
