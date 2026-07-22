import request from '@/utils/request'
import type { ApiResponse } from '@/types/api'
import type { Plan } from '@/types/plan'

export function getPlanList(incidentId: string): Promise<ApiResponse<Plan[]>> {
  return request.get('/plan/list', { params: { incidentId } })
}

export function generatePlan(incidentId: string): Promise<ApiResponse<{ planId: string }>> {
  return request.post('/plan/generate', { incidentId }, { timeout: 60000 })
}

export function getPlanDetail(planId: string): Promise<ApiResponse<Plan>> {
  return request.get('/plan/detail', { params: { planId } })
}