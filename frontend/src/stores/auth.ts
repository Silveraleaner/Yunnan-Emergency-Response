import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { UserInfo } from '@/types/user'
import type { UserRoleValue } from '@/types/enums'
import { login as loginApi } from '@/api/login'
import type { LoginParams } from '@/types/user'
import { setStoredToken, clearStoredToken } from '@/utils/token'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(null)
  const userInfo = ref<UserInfo | null>(null)

  const isLoggedIn = computed(() => !!token.value)
  const userRole = computed<UserRoleValue | null>(() => userInfo.value?.role ?? null)

  function setToken(newToken: string): void {
    token.value = newToken
    setStoredToken(newToken)
  }

  function setUserInfo(info: UserInfo): void {
    userInfo.value = info
  }

  function clearAuth(): void {
    token.value = null
    userInfo.value = null
    clearStoredToken()
  }

  async function login(params: LoginParams): Promise<void> {
    const res = await loginApi(params) as unknown as { token: string; userInfo: UserInfo }
    setToken(res.token)
    userInfo.value = res.userInfo
  }

  function logout(): void {
    clearAuth()
  }

  return {
    token,
    userInfo,
    isLoggedIn,
    userRole,
    setToken,
    setUserInfo,
    clearAuth,
    login,
    logout,
  }
})
