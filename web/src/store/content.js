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
      const { supabase } = await import('@/services/supabase.js')

      const [vocabRes, litRes] = await Promise.all([
        supabase.from('core_vocabularies').select('*').order('created_at', { ascending: true }),
        supabase.from('literature_articles').select('*').order('created_at', { ascending: true })
      ])

      if (vocabRes.error) throw vocabRes.error
      if (litRes.error) throw litRes.error

      // 为了兼容现有前端的 id 解析逻辑，将 original_id 映射回 id
      vocabulary.value = (vocabRes.data || []).map(v => ({ ...v, id: v.original_id || v.id }))
      literature.value = (litRes.data || []).map(a => ({ 
        ...a, 
        id: a.original_id || a.id, 
        paragraphs: [{ id: `${a.original_id || a.id}-p1`, english: a.content_en, chinese: a.content_zh }] 
      }))
    } catch (e) {
      console.error(e)
      error.value = e.message || '加载失败'
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
