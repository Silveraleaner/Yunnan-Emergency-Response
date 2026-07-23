import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Plan } from '@/types/plan'
import { getPlanList, generatePlan, getPlanDetail, streamPlan } from '@/api/plan'
import { getStoredToken } from '@/utils/token'

export const usePlanStore = defineStore('plan', () => {
  const planList = ref<Plan[]>([])
  const currentPlan = ref<Plan | null>(null)
  const generating = ref(false)
  const streamingContent = ref('')
  const streaming = ref(false)

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

  function startStream(incidentId: string): void {
    streaming.value = true
    streamingContent.value = ''
    const token = getStoredToken() || ''

    streamPlan(
      incidentId,
      token,
      (text: string) => { streamingContent.value += text },
      () => { streaming.value = false },
      () => { streaming.value = false },
    )
  }

  function stopStream(): void {
    streaming.value = false
  }

  return {
    planList,
    currentPlan,
    generating,
    streamingContent,
    streaming,
    fetchList,
    generate,
    fetchDetail,
    startStream,
    stopStream,
  }
})
