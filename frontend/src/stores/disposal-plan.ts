import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { DisposalPlan } from '@/types/disposal-plan'
import { getDisposalPlanList, submitDisposalPlan, rejectDisposalPlan } from '@/api/disposal-plan'

export const useDisposalPlanStore = defineStore('disposal-plan', () => {
  const disposalPlanList = ref<DisposalPlan[]>([])
  const currentDisposalPlan = ref<DisposalPlan | null>(null)
  const loading = ref(false)

  async function fetchList(incidentId?: string): Promise<void> {
    loading.value = true
    try {
      const res = await getDisposalPlanList(incidentId ? { incidentId } : undefined) as unknown as DisposalPlan[]
      disposalPlanList.value = res
    } finally {
      loading.value = false
    }
  }

  async function submitDisposalPlanAction(id: number): Promise<void> {
    await submitDisposalPlan({ id })
  }

  async function rejectDisposalPlanAction(id: number, reason: string): Promise<void> {
    await rejectDisposalPlan({ id, rejectReason: reason })
  }

  return {
    disposalPlanList,
    currentDisposalPlan,
    loading,
    fetchList,
    submitDisposalPlan: submitDisposalPlanAction,
    rejectDisposalPlan: rejectDisposalPlanAction,
  }
})