<template>
  <button
    class="btn btn-speak"
    :class="{ speaking: active }"
    :title="active ? '停止' : '朗读'"
    @click="toggle"
  >
    <span>{{ active ? '⏹' : '🔊' }}</span>
    <span>{{ active ? '停止' : label }}</span>
  </button>
</template>

<script setup>
import { computed } from 'vue'
import { speak, stop, isSpeaking } from '@/services/speech.js'

const props = defineProps({
  text: { type: String, required: true },
  label: { type: String, default: '发音' },
  lang: { type: String, default: 'en-US' },
  rate: { type: Number, default: 0.9 }
})

// 是否是本按钮正在播放（简单判断：全局 isSpeaking 即认为是自己）
const active = computed(() => isSpeaking.value)

function toggle() {
  if (isSpeaking.value) {
    stop()
  } else {
    speak(props.text, props.lang, props.rate)
  }
}
</script>
