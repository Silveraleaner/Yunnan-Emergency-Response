import request from '@/utils/request'
import type { ApiResponse } from '@/types/api'
import type { Resource, ResourceListParams, ResourceDispatchData } from '@/types/resource'

export function getResourceList(params?: ResourceListParams): Promise<ApiResponse<Resource[]>> {
  return request.get('/resource/list', { params })
}

export function dispatchResource(data: ResourceDispatchData): Promise<ApiResponse<null>> {
  return request.post('/resource/dispatch', data)
}