import type { UserRoleValue } from './enums'

export interface UserInfo {
  userId: string
  username: string
  realName: string
  role: UserRoleValue
}

export interface LoginParams {
  username: string
  password: string
}

export interface LoginResult {
  token: string
  userInfo: UserInfo
}