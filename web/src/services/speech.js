/**
 * Web Speech API 封装
 * 用法：
 *   import { speak, stop, isSpeaking } from '@/services/speech.js'
 *   speak('endocrine')
 */
import { ref } from 'vue'

export const isSpeaking = ref(false)

let currentUtterance = null

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

  utterance.onstart = () => { isSpeaking.value = true }
  utterance.onend = () => { isSpeaking.value = false; currentUtterance = null }
  utterance.onerror = () => { isSpeaking.value = false; currentUtterance = null }

  currentUtterance = utterance
  window.speechSynthesis.speak(utterance)
}

export function stop() {
  if (window.speechSynthesis) {
    window.speechSynthesis.cancel()
  }
  isSpeaking.value = false
  currentUtterance = null
}
