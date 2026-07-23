<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useIncidentStore } from '@/stores/incident'
import StatusTag from '@/components/StatusTag.vue'
import {
  DisasterTypeLabel,
  IncidentLevelLabel,
  IncidentStatusLabel,
  IncidentStatusTagType,
  IncidentStatus,
} from '@/types/enums'
import type { DisasterTypeValue, IncidentLevelValue, IncidentStatusValue } from '@/types/enums'

const router = useRouter()
const incidentStore = useIncidentStore()

const currentPage = ref(1)
const pageSize = ref(20)

const filters = reactive({
  disasterType: '' as DisasterTypeValue | '',
  incidentLevel: '' as IncidentLevelValue | '',
  status: '' as IncidentStatusValue | '',
  keyword: '',
})

const disasterOptions = Object.entries(DisasterTypeLabel).map(([value, label]) => ({ value, label }))
const levelOptions = Object.entries(IncidentLevelLabel).map(([value, label]) => ({ value, label }))
const statusOptions = Object.entries(IncidentStatusLabel).map(([value, label]) => ({ value, label }))

const statusMap = Object.fromEntries(
  Object.entries(IncidentStatusLabel).map(([key, label]) => [
    key,
    { label, type: IncidentStatusTagType[key as IncidentStatusValue] },
  ])
)

async function loadData(): Promise<void> {
  await incidentStore.fetchList({
    page: currentPage.value,
    size: pageSize.value,
    disasterType: filters.disasterType || undefined,
    incidentLevel: filters.incidentLevel || undefined,
    status: filters.status || undefined,
    keyword: filters.keyword || undefined,
  })
}

function handlePageChange(page: number): void {
  currentPage.value = page
  loadData()
}

function handleSizeChange(size: number): void {
  pageSize.value = size
  currentPage.value = 1
  loadData()
}

function handleSearch(): void {
  currentPage.value = 1
  loadData()
}

function resetFilters(): void {
  filters.disasterType = ''
  filters.incidentLevel = ''
  filters.status = ''
  filters.keyword = ''
  currentPage.value = 1
  loadData()
}

function viewDetail(id: string): void {
  router.push(`/incident/${id}`)
}

onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="incident-list page-container">
    <div class="page-header">
      <h2 class="page-header__title">事件列表</h2>
      <el-button type="primary" @click="router.push('/incident/report')">
        <el-icon><Plus /></el-icon>
        新增上报
      </el-button>
    </div>

    <el-card shadow="hover" class="incident-list__filters">
      <el-form inline>
        <el-form-item label="灾害类型">
          <el-select v-model="filters.disasterType" placeholder="全部" clearable style="width: 140px">
            <el-option v-for="opt in disasterOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="事件等级">
          <el-select v-model="filters.incidentLevel" placeholder="全部" clearable style="width: 140px">
            <el-option v-for="opt in levelOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="filters.status" placeholder="全部" clearable style="width: 120px">
            <el-option v-for="opt in statusOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="搜索">
          <el-input v-model="filters.keyword" placeholder="事件名称" clearable @clear="handleSearch" @keyup.enter="handleSearch" style="width: 180px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetFilters">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card shadow="hover">
      <el-table :data="incidentStore.incidentList" v-loading="incidentStore.loading" stripe>
        <el-table-column prop="incidentName" label="事件名称" min-width="160" />
        <el-table-column prop="disasterType" label="灾害类型" width="120">
          <template #default="{ row }">
            {{ DisasterTypeLabel[row.disasterType as DisasterTypeValue] ?? row.disasterType }}
          </template>
        </el-table-column>
        <el-table-column prop="incidentLevel" label="事件等级" width="140">
          <template #default="{ row }">
            {{ IncidentLevelLabel[row.incidentLevel as IncidentLevelValue] ?? row.incidentLevel }}
          </template>
        </el-table-column>
        <el-table-column prop="occurTime" label="发生时间" width="180" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <StatusTag :status="row.status" :status-map="statusMap" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="viewDetail(row.incidentId)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="incident-list__pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="incidentStore.total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @current-change="handlePageChange"
          @size-change="handleSizeChange"
        />
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.incident-list__filters {
  margin-bottom: var(--spacing-md);
}

.incident-list__pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: var(--spacing-md);
}
</style>
