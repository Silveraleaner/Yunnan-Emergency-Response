import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Resource, ResourceListParams, ResourceDispatchData } from '@/types/resource'
import { getResourceList, dispatchResource } from '@/api/resource'

export const useResourceStore = defineStore('resource', () => {
  const resourceList = ref<Resource[]>([])
  const loading = ref(false)

  async function fetchList(params?: ResourceListParams): Promise<void> {
    loading.value = true
    try {
      const res = await getResourceList(params) as unknown as Resource[]
      resourceList.value = res
    } finally {
      loading.value = false
    }
  }

  async function dispatch(data: ResourceDispatchData): Promise<void> {
    await dispatchResource(data)
  }

  return {
    resourceList,
    loading,
    fetchList,
    dispatch,
  }
})