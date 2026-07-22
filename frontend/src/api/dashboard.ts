import request from '@/utils/request'
import type { ApiResponse } from '@/types/api'
import type { DashboardOverview, DashboardTrend, DashboardDistribution, ScreenData } from '@/types/dashboard'

export function getDashboardOverview(): Promise<ApiResponse<DashboardOverview>> {
  return request.get('/dashboard/overview')
}

export function getDashboardTrend(): Promise<ApiResponse<DashboardTrend>> {
  return request.get('/dashboard/trend')
}

export function getDashboardDistribution(): Promise<ApiResponse<DashboardDistribution>> {
  return request.get('/dashboard/distribution')
}

export function getScreenData(): Promise<ApiResponse<ScreenData>> {
  return request.get('/dashboard/screen')
}