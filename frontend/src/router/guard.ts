import type { Router } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

export function setupRouterGuard(router: Router): void {
  router.beforeEach((to, _from, next) => {
    const authStore = useAuthStore()

    if (to.meta.requiresAuth && !authStore.isLoggedIn) {
      next({ path: '/login', query: { redirect: to.fullPath } })
      return
    }

    if (to.path === '/login' && authStore.isLoggedIn) {
      next({ path: '/home' })
      return
    }

    next()
  })
}