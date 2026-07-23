<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useResourceStore } from '@/stores/resource'
import { useIncidentStore } from '@/stores/incident'
import StatusTag from '@/components/StatusTag.vue'
import { ResourceTypeLabel, ResourceStatusLabel, ResourceStatusTagType } from '@/types/enums'
import type { ResourceTypeValue, ResourceStatusValue } from '@/types/enums'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'

const resourceStore = useResourceStore()
const incidentStore = useIncidentStore()

const dispatchDialogVisible = ref(false)
const dispatchFormRef = ref<FormInstance>()
const dispatching = ref(false)
const currentResourceId = ref('')

const filterType = ref<ResourceTypeValue | ''>('')

const resourceTypeOptions = Object.entries(ResourceTypeLabel).map(([value, label]) => ({ value, label }))

const statusMap = Object.fromEntries(
  Object.entries(ResourceStatusLabel).map(([key, label]) => [
    key,
    { label, type: ResourceStatusTagType[key as ResourceStatusValue] },
  ])
)

const dispatchForm = reactive({
  incidentId: '',
  quantity: 1,
})

const dispatchRules: FormRules = {
  incidentId: [{ required: true, message: '请选择目标事件', trigger: 'change' }],
  quantity: [{ required: true, message: '请输入调度数量', trigger: 'blur' }],
}

async function loadData(): Promise<void> {
  await resourceStore.fetchList(
    filterType.value ? { resourceType: filterType.value } : undefined
  )
}

function openDispatchDialog(resourceId: string, availableQty: number): void {
  currentResourceId.value = resourceId
  dispatchForm.incidentId = ''
  dispatchForm.quantity = 1
  dispatchDialogVisible.value = true
  incidentStore.fetchList({ page: 1, size: 100 })
}

async function handleDispatch(): Promise<void> {
  const valid = await dispatchFormRef.value?.validate().catch(() => false)
  if (!valid) return

  const resource = resourceStore.resourceList.find((r) => r.resourceId === currentResourceId.value)
  if (resource && dispatchForm.quantity > resource.availableQuantity) {
    ElMessage.warning('调度数量不能超过可用数量')
    return
  }

  dispatching.value = true
  try {
    await resourceStore.dispatch({
      resourceId: currentResourceId.value,
      incidentId: dispatchForm.incidentId,
      quantity: dispatchForm.quantity,
    })
    ElMessage.success('调度成功')
    dispatchDialogVisible.value = false
    loadData()
  } catch {
    ElMessage.error('调度失败，请稍后重试')
  } finally {
    dispatching.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="resource-page page-container">
    <div class="page-header">
      <h2 class="page-header__title">资源调度</h2>
    </div>

    <el-card shadow="hover" class="resource-page__filter">
      <el-form inline>
        <el-form-item label="资源类型">
          <el-select v-model="filterType" placeholder="全部" clearable style="width: 160px" @change="loadData">
            <el-option v-for="opt in resourceTypeOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
          </el-select>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card shadow="hover">
      <el-table :data="resourceStore.resourceList" v-loading="resourceStore.loading" stripe>
        <el-table-column prop="resourceName" label="资源名称" min-width="140" />
        <el-table-column prop="resourceType" label="资源类型" width="120">
          <template #default="{ row }">
            {{ ResourceTypeLabel[row.resourceType as ResourceTypeValue] ?? row.resourceType }}
          </template>
        </el-table-column>
        <el-table-column prop="quantity" label="数量" width="100" />
        <el-table-column prop="availableQuantity" label="可用数量" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <StatusTag :status="row.status" :status-map="statusMap" />
          </template>
        </el-table-column>
        <el-table-column prop="region" label="所属区域" width="140" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button
              link
              type="primary"
              :disabled="row.status !== 'available'"
              @click="openDispatchDialog(row.resourceId, row.availableQuantity)"
            >
              调度
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dispatchDialogVisible" title="资源调度" width="480px">
      <el-form ref="dispatchFormRef" :model="dispatchForm" :rules="dispatchRules" label-width="100px">
        <el-form-item label="目标事件" prop="incidentId">
          <el-select v-model="dispatchForm.incidentId" placeholder="请选择灾情事件" style="width: 100%">
            <el-option
              v-for="item in incidentStore.incidentList"
              :key="item.incidentId"
              :label="item.incidentName"
              :value="item.incidentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="调度数量" prop="quantity">
          <el-input-number v-model="dispatchForm.quantity" :min="1" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dispatchDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="dispatching" @click="handleDispatch">确认调度</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.resource-page__filter {
  margin-bottom: var(--spacing-md);
}
</style>