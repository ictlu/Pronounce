/**
 * Web Speech API 封装
 */
import { ref } from 'vue'
import { supabase } from './supabase'

/** 当前正在朗读的文本（用于按钮高亮判断） */
export const currentSpeakingText = ref('')

let currentAudio = null

export async function speak(text, lang = 'en-US', rate = 0.9, pitch = 1) {
  stop()
  currentSpeakingText.value = text

  try {
    const baseUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/tts`
    const url = new URL(baseUrl)
    url.searchParams.append('text', text)
    url.searchParams.append('voice', lang.includes('en') ? 'en-US-AriaNeural' : 'zh-CN-XiaoxiaoNeural')

    // 直接将 URL 赋值给 Audio 对象，浏览器会自动处理流式下载和即时播放，极大降低延迟
    currentAudio = new Audio(url.toString())

    
    // 监听播放结束事件
    currentAudio.onended = () => {
      currentSpeakingText.value = ''
    }
    currentAudio.onerror = () => {
      currentSpeakingText.value = ''
    }
    
    await currentAudio.play()
  } catch (err) {
    console.error('TTS 失败:', err)
    currentSpeakingText.value = ''
  }
}

export function stop() {
  if (currentAudio) {
    currentAudio.pause()
    currentAudio.currentTime = 0
    currentAudio = null
  }
  // 如果之前还在使用原生的 speechSynthesis，也停掉
  if ('speechSynthesis' in window) {
    window.speechSynthesis.cancel()
  }
  currentSpeakingText.value = ''
}
