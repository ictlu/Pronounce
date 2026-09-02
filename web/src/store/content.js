import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useContentStore = defineStore('content', () => {
  const vocabulary = ref([])
  const literature = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function loadContent() {
    if (vocabulary.value.length > 0) return // 已加载则跳过
    loading.value = true
    error.value = null
    try {
      const res = await fetch('/data/medical_english_content.json')
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const data = await res.json()
      vocabulary.value = data.vocabulary || []
      literature.value = data.literature || []
    } catch (e) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  const vocabById = computed(() => {
    const map = {}
    vocabulary.value.forEach(v => { map[v.id] = v })
    return map
  })

  const litById = computed(() => {
    const map = {}
    literature.value.forEach(a => { map[a.id] = a })
    return map
  })

  return { vocabulary, literature, loading, error, loadContent, vocabById, litById }
})
