/**
 * Web Speech API 封装
 */
import { ref } from 'vue'

/** 当前正在朗读的文本（用于按钮高亮判断） */
export const currentSpeakingText = ref('')

export function speak(text, lang = 'en-US', rate = 0.9, pitch = 1) {
  if (!('speechSynthesis' in window)) {
    alert('您的浏览器不支持 Web Speech API，推荐使用 Chrome 或 Edge。')
    return
  }
  stop()

  const utterance = new SpeechSynthesisUtterance(text)
  utterance.lang = lang
  utterance.rate = rate
  utterance.pitch = pitch

  utterance.onstart = () => { currentSpeakingText.value = text }
  utterance.onend = () => { currentSpeakingText.value = '' }
  utterance.onerror = () => { currentSpeakingText.value = '' }

  window.speechSynthesis.speak(utterance)
}

export function stop() {
  if (window.speechSynthesis) {
    window.speechSynthesis.cancel()
  }
  currentSpeakingText.value = ''
}
