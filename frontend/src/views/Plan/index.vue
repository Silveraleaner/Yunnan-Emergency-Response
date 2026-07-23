<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { usePlanStore } from '@/stores/plan'
import { useIncidentStore } from '@/stores/incident'
import { PlanStatusLabel } from '@/types/enums'
import type { PlanStatusValue } from '@/types/enums'
import { ElMessage } from 'element-plus'
import { formatDate } from '@/utils/format'

const planStore = usePlanStore()
const incidentStore = useIncidentStore()

const selectedIncidentId = ref('')
const selectedPlanId = ref('')
const timeoutTimer = ref<ReturnType<typeof setTimeout> | null>(null)

async function loadIncidents(): Promise<void> {
  await incidentStore.fetchList({ page: 1, size: 100 })
}

async function loadPlans(): Promise<void> {
  if (!selectedIncidentId.value) return
  selectedPlanId.value = ''
  planStore.currentPlan = null
  await planStore.fetchList(selectedIncidentId.value)
}

async function handleGenerate(): Promise<void> {
  if (!selectedIncidentId.value) {
    ElMessage.warning('请先选择灾情事件')
    return
  }

  timeoutTimer.value = setTimeout(() => {
    ElMessage.error('方案生成超时，请稍后重试')
    planStore.generating = false
  }, 60000)

  const planId = await planStore.generate(selectedIncidentId.value)

  if (timeoutTimer.value) {
    clearTimeout(timeoutTimer.value)
    timeoutTimer.value = null
  }

  if (planId) {
    ElMessage.success('方案生成成功')
    selectedPlanId.value = planId
    await planStore.fetchDetail(planId)
    await planStore.fetchList(selectedIncidentId.value)
  } else if (!planStore.generating) {
    ElMessage.error('方案生成失败，请稍后重试')
  }
}

async function selectPlan(planId: string): Promise<void> {
  selectedPlanId.value = planId
  await planStore.fetchDetail(planId)
}

onMounted(() => {
  loadIncidents()
})
</script>

<template>
  <div class="plan-page page-container">
    <div class="page-header">
      <h2 class="page-header__title">AI方案生成</h2>
    </div>

    <el-card shadow="hover" class="plan-page__selector">
      <el-form inline>
        <el-form-item label="选择灾情事件">
          <el-select
            v-model="selectedIncidentId"
            placeholder="请选择灾情事件"
            style="width: 360px"
            @change="loadPlans"
          >
            <el-option
              v-for="item in incidentStore.incidentList"
              :key="item.incidentId"
              :label="item.incidentName"
              :value="item.incidentId"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            :loading="planStore.generating"
            @click="handleGenerate"
          >
            {{ planStore.generating ? '生成中...' : '生成新方案' }}
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <div class="plan-page__body" v-if="selectedIncidentId">
      <el-card shadow="hover" class="plan-page__list">
        <template #header>
          <span>历史方案</span>
        </template>
        <div v-if="planStore.planList.length === 0" class="plan-page__empty">暂无方案</div>
        <div
          v-for="plan in planStore.planList"
          :key="plan.planId"
          class="plan-page__item"
          :class="{ 'plan-page__item--active': selectedPlanId === plan.planId }"
          @click="selectPlan(plan.planId)"
        >
          <div class="plan-page__item-title">{{ plan.planTitle }}</div>
          <div class="plan-page__item-meta">
            <span>{{ formatDate(plan.generateTime, 'YYYY-MM-DD HH:mm') }}</span>
            <el-tag size="small" :type="plan.status === 'approved' ? 'success' : plan.status === 'rejected' ? 'danger' : 'info'">
              {{ PlanStatusLabel[plan.status as PlanStatusValue] ?? plan.status }}
            </el-tag>
          </div>
        </div>
      </el-card>

      <el-card shadow="hover" class="plan-page__detail">
        <template #header>
          <span>方案详情</span>
        </template>
        <div v-if="!planStore.currentPlan" class="plan-page__empty">请选择或生成方案</div>
        <div v-else class="plan-page__content">
          <h3>{{ planStore.currentPlan.planTitle }}</h3>
          <div class="plan-page__content-meta">
            <span>生成时间：{{ formatDate(planStore.currentPlan.generateTime) }}</span>
            <el-tag size="small" :type="planStore.currentPlan.status === 'approved' ? 'success' : planStore.currentPlan.status === 'rejected' ? 'danger' : 'info'">
              {{ PlanStatusLabel[planStore.currentPlan.status as PlanStatusValue] }}
            </el-tag>
          </div>
          <el-divider />
          <div class="plan-page__content-body" v-html="planStore.currentPlan.planContent" />
        </div>
      </el-card>
    </div>
  </div>
</template>

<style scoped>
.plan-page__selector {
  margin-bottom: var(--spacing-md);
}

.plan-page__body {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: var(--spacing-md);
  min-height: 500px;
}

.plan-page__empty {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 200px;
  color: var(--color-text-secondary);
}

.plan-page__item {
  padding: var(--spacing-md);
  border-radius: var(--border-radius-sm);
  cursor: pointer;
  transition: background-color var(--transition-duration);
  border-bottom: 1px solid var(--color-border-light);
}

.plan-page__item:hover {
  background-color: var(--color-bg-page);
}

.plan-page__item--active {
  background-color: rgba(26, 115, 232, 0.08);
  border-left: 3px solid var(--color-primary);
}

.plan-page__item-title {
  font-weight: 500;
  margin-bottom: var(--spacing-xs);
}

.plan-page__item-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: var(--font-size-xs);
  color: var(--color-text-secondary);
}

.plan-page__content h3 {
  font-size: var(--font-size-xl);
  margin-bottom: var(--spacing-sm);
}

.plan-page__content-meta {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

.plan-page__content-body {
  line-height: 1.8;
  color: var(--color-text-regular);
}
</style>