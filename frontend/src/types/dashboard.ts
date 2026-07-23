import type { Incident } from './incident'
import type { Resource } from './resource'

export interface DashboardOverview {
  todayCount: number
  activeCount: number
  pendingCount: number
}

export interface DashboardTrend {
  dates: string[]
  counts: number[]
}

export interface DashboardDistribution {
  types: string[]
  counts: number[]
}

export interface ScreenData {
  statistics: DashboardOverview
  incidents: Incident[]
  resources: Resource[]
}