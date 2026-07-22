import type { DisasterTypeValue, IncidentLevelValue, IncidentStatusValue } from './enums'

export interface Attachment {
  fileName: string
  fileUrl: string
  fileSize: number
}

export interface Incident {
  incidentId: string
  incidentName: string
  disasterType: DisasterTypeValue
  incidentLevel: IncidentLevelValue
  occurTime: string
  location: string
  description: string
  status: IncidentStatusValue
  attachments: Attachment[]
  imageUrls: string[]
  reporterId: string
  reportTime: string
}

export interface IncidentReportData {
  incidentName: string
  disasterType: DisasterTypeValue
  incidentLevel: IncidentLevelValue
  occurTime: string
  location: string
  description: string
  images: File[]
}

export interface IncidentReportResult {
  incidentId: string
  imageUrls: string[]
}

export interface IncidentListParams {
  page: number
  size: number
  disasterType?: DisasterTypeValue
  incidentLevel?: IncidentLevelValue
  status?: IncidentStatusValue
  keyword?: string
}

export interface IncidentListResult {
  total: number
  list: Incident[]
}