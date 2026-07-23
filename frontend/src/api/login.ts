import request from '@/utils/request'
import type { ApiResponse } from '@/types/api'
import type { LoginParams, LoginResult } from '@/types/user'

export function login(params: LoginParams): Promise<ApiResponse<LoginResult>> {
  return request.post('/login', params)
}