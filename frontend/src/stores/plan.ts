import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Plan } from '@/types/plan'
import { getPlanList, generatePlan, getPlanDetail } from '@/api/plan'

export const usePlanStore = defineStore('plan', () => {
  const planList = ref<Plan[]>([])
  const currentPlan = ref<Plan | null>(null)
  const generating = ref(false)

  async function fetchList(incidentId: string): Promise<void> {
    const res = await getPlanList(incidentId) as unknown as Plan[]
    planList.value = res
  }

  async function generate(incidentId: string): Promise<string | null> {
    generating.value = true
    try {
      const res = await generatePlan(incidentId) as unknown as { planId: string }
      return res.planId
    } catch {
      return null
    } finally {
      generating.value = false
    }
  }

  async function fetchDetail(planId: string): Promise<void> {
    const res = await getPlanDetail(planId) as unknown as Plan
    currentPlan.value = res
  }

  return {
    planList,
    currentPlan,
    generating,
    fetchList,
    generate,
    fetchDetail,
  }
})