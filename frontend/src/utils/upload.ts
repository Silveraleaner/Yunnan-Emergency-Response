import type { IncidentReportData } from '@/types/incident'

export function buildIncidentFormData(data: IncidentReportData): FormData {
  const formData = new FormData()

  formData.append('incidentName', data.incidentName)
  formData.append('disasterType', data.disasterType)
  formData.append('incidentLevel', data.incidentLevel)
  formData.append('occurTime', data.occurTime)
  formData.append('location', data.location)
  formData.append('description', data.description)

  if (data.images?.length) {
    data.images.forEach((file) => {
      formData.append('images', file)
    })
  }

  return formData
}