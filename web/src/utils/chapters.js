/**
 * 词汇 PDF 章节定义（来源：内分泌科复试核心词汇表.pdf 目录页）
 * 词条编号范围：vocab-{number}，id 形式为 "vocab-1", "vocab-46" ...
 */
export const VOCAB_CHAPTERS = [
  { title: '第一章：解剖生理', count: 45,  from: 1,   to: 45  },
  { title: '第二章：症状体征', count: 54,  from: 46,  to: 99  },
  { title: '第三章：疾病',     count: 123, from: 100, to: 222 },
  { title: '第四章：病因机制', count: 60,  from: 223, to: 282 },
  { title: '第五章：检查诊断', count: 82,  from: 283, to: 364 },
  { title: '第六章：药物治疗', count: 73,  from: 365, to: 437 },
  { title: '第七章：操作技术', count: 45,  from: 438, to: 482 },
  { title: '第八章：并发症预后', count: 35, from: 483, to: 517 },
]

/** 从 vocab id（"vocab-12"）提取数字编号 */
export function vocabNumber(id) {
  const m = id?.match(/vocab-(\d+)/)
  return m ? parseInt(m[1], 10) : 0
}

/** 根据 id 查找所属章节 */
export function chapterOf(id) {
  const n = vocabNumber(id)
  return VOCAB_CHAPTERS.find(ch => n >= ch.from && n <= ch.to) ?? null
}
