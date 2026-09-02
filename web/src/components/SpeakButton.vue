<template>
  <button
    class="btn btn-speak"
    :class="{ speaking: isMyTurn }"
    :title="isMyTurn ? '停止' : '朗读'"
    @click="toggle"
  >
    <span>{{ isMyTurn ? '⏹' : '🔊' }}</span>
    <span v-if="label">{{ isMyTurn ? '停止' : label }}</span>
  </button>
</template>

<script setup>
import { computed } from 'vue'
import { speak, stop, currentSpeakingText } from '@/services/speech.js'

const props = defineProps({
  text: { type: String, required: true },
  label: { type: String, default: '发音' },
  lang: { type: String, default: 'en-US' },
  rate: { type: Number, default: 0.9 }
})

// 只有当前按钮的 text 正在播放时才高亮
const isMyTurn = computed(() => currentSpeakingText.value === props.text && props.text !== '')

function toggle() {
  if (isMyTurn.value) {
    stop()
  } else {
    speak(props.text, props.lang, props.rate)
  }
}
</script>
