import type { PlanStatusValue } from './enums'

export interface Plan {
  planId: string
  incidentId: string
  planTitle: string
  planContent: string
  generateTime: string
  status: PlanStatusValue
}