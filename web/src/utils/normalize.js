/**
 * 频率字段归一化（原始数据含多余空格）
 * "高频必 会" → "高频必会"
 */
export function normalizeFreq(raw) {
  if (!raw) return '未标注'
  const cleaned = raw.replace(/\s+/g, '')
  if (cleaned.includes('高频')) return '高频必会'
  if (cleaned.includes('中频')) return '中频重点'
  if (cleaned.includes('低频')) return '低频拓展'
  return cleaned || '未标注'
}

/** 频率的排列顺序（由高到低） */
export const FREQ_ORDER = ['高频必会', '中频重点', '低频拓展', '未标注']
