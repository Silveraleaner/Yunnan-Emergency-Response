export const DisasterType = {
  EARTHQUAKE: 'earthquake',
  MUDSLIDE: 'mudslide',
  FLOOD: 'flood',
  DROUGHT: 'drought',
  LANDSLIDE: 'landslide',
  FIRE: 'fire',
  OTHER: 'other',
} as const

export type DisasterTypeValue = (typeof DisasterType)[keyof typeof DisasterType]

export const DisasterTypeLabel: Record<DisasterTypeValue, string> = {
  earthquake: '地震',
  mudslide: '泥石流',
  flood: '洪涝',
  drought: '干旱',
  landslide: '山体滑坡',
  fire: '森林火灾',
  other: '其他',
}

export const IncidentLevel = {
  LEVEL_I: 'I',
  LEVEL_II: 'II',
  LEVEL_III: 'III',
  LEVEL_IV: 'IV',
} as const

export type IncidentLevelValue = (typeof IncidentLevel)[keyof typeof IncidentLevel]

export const IncidentLevelLabel: Record<IncidentLevelValue, string> = {
  I: 'Ⅰ级（特别重大）',
  II: 'Ⅱ级（重大）',
  III: 'Ⅲ级（较大）',
  IV: 'Ⅳ级（一般）',
}

export const IncidentStatus = {
  PENDING: 'pending',
  PROCESSING: 'processing',
  COMPLETED: 'completed',
} as const

export type IncidentStatusValue = (typeof IncidentStatus)[keyof typeof IncidentStatus]

export const IncidentStatusLabel: Record<IncidentStatusValue, string> = {
  pending: '待处理',
  processing: '处理中',
  completed: '已完成',
}

export const IncidentStatusTagType: Record<IncidentStatusValue, string> = {
  pending: 'danger',
  processing: 'warning',
  completed: 'success',
}

export const ResourceType = {
  TEAM: 'team',
  MEDICAL: 'medical',
  VEHICLE: 'vehicle',
  SHELTER: 'shelter',
} as const

export type ResourceTypeValue = (typeof ResourceType)[keyof typeof ResourceType]

export const ResourceTypeLabel: Record<ResourceTypeValue, string> = {
  team: '救援队伍',
  medical: '医疗物资',
  vehicle: '运输车辆',
  shelter: '临时安置点',
}

export const ResourceStatus = {
  AVAILABLE: 'available',
  DISPATCHED: 'dispatched',
} as const

export type ResourceStatusValue = (typeof ResourceStatus)[keyof typeof ResourceStatus]

export const ResourceStatusLabel: Record<ResourceStatusValue, string> = {
  available: '可用',
  dispatched: '已调度',
}

export const ResourceStatusTagType: Record<ResourceStatusValue, string> = {
  available: 'success',
  dispatched: 'info',
}

export const PlanStatus = {
  DRAFT: 'draft',
  APPROVED: 'approved',
  REJECTED: 'rejected',
} as const

export type PlanStatusValue = (typeof PlanStatus)[keyof typeof PlanStatus]

export const PlanStatusLabel: Record<PlanStatusValue, string> = {
  draft: '草稿',
  approved: '已审批',
  rejected: '已驳回',
}

export const UserRole = {
  ADMIN: 'admin',
  COMMANDER: 'commander',
  REPORTER: 'reporter',
} as const

export type UserRoleValue = (typeof UserRole)[keyof typeof UserRole]

export const UserRoleLabel: Record<UserRoleValue, string> = {
  admin: '系统管理员',
  commander: '应急指挥人员',
  reporter: '灾情上报人员',
}

export const ALLOWED_IMAGE_TYPES = [
  'image/jpeg',
  'image/png',
  'image/gif',
  'image/webp',
] as const

export const MAX_IMAGE_SIZE: number = 10 * 1024 * 1024

export const MAX_IMAGE_COUNT: number = 5

export const IMAGE_ACCEPT_STRING: string = '.jpg,.jpeg,.png,.gif,.webp'