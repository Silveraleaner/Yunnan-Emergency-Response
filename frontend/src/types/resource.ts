import type { ResourceTypeValue, ResourceStatusValue } from './enums'

export interface Resource {
  resourceId: string
  resourceName: string
  resourceType: ResourceTypeValue
  quantity: number
  availableQuantity: number
  status: ResourceStatusValue
  region: string
}

export interface ResourceListParams {
  resourceType?: ResourceTypeValue
}

export interface ResourceDispatchData {
  resourceId: string
  incidentId: string
  quantity: number
}