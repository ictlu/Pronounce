import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/HomeView.vue')
  },
  {
    path: '/vocab',
    name: 'VocabList',
    component: () => import('@/views/VocabListView.vue')
  },
  {
    path: '/vocab/:id',
    name: 'VocabDetail',
    component: () => import('@/views/VocabDetailView.vue'),
    props: true
  },
  {
    path: '/literature',
    name: 'LiteratureList',
    component: () => import('@/views/LiteratureListView.vue')
  },
  {
    path: '/literature/:id',
    name: 'LiteratureDetail',
    component: () => import('@/views/LiteratureDetailView.vue'),
    props: true
  },
  {
    path: '/practice',
    name: 'Practice',
    component: () => import('@/views/PronunciationView.vue')
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router
