<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { usePlanStore } from '@/stores/plan'
import { useIncidentStore } from '@/stores/incident'
import { useAuthStore } from '@/stores/auth'
import { useDisposalPlanStore } from '@/stores/disposal-plan'
import { PlanStatusLabel, PlanStatusTagType, DisposalPlanStatusLabel, DisposalPlanStatusTagType } from '@/types/enums'
import type { PlanStatusValue, DisposalPlanStatusValue } from '@/types/enums'
import { ElMessage, ElMessageBox } from 'element-plus'
import { formatDate } from '@/utils/format'
import StatusTag from '@/components/StatusTag.vue'

const route = useRoute()
const planStore = usePlanStore()
const incidentStore = useIncidentStore()
const authStore = useAuthStore()
const disposalPlanStore = useDisposalPlanStore()

const selectedIncidentId = ref('')
const selectedPlanId = ref('')
const streamMode = ref(false)
const isEditing = ref(false)
const editedContent = ref('')
const contentConfirmed = ref(false)

const canEdit = ref(false)

const disposalPlanStatusMap = Object.fromEntries(
  Object.entries(DisposalPlanStatusLabel).map(([key, label]) => [
    key,
    { label, type: DisposalPlanStatusTagType[key as DisposalPlanStatusValue] },
  ])
)

function checkEditPermission(): void {
  const role = authStore.roleName
  const status = planStore.currentPlan?.status
  canEdit.value = (role === 'OPERATOR' || role === 'ADMIN') && status === 'draft'
}

async function loadIncidents(): Promise<void> {
  await incidentStore.fetchList({ page: 1, size: 100 })
}

async function loadPlans(): Promise<void> {
  if (!selectedIncidentId.value) return
  selectedPlanId.value = ''
  planStore.currentPlan = null
  contentConfirmed.value = false
  await planStore.fetchList(selectedIncidentId.value)
}

async function handleStreamGenerate(): Promise<void> {
  if (!selectedIncidentId.value) {
    ElMessage.warning('请先选择灾情事件')
    return
  }
  streamMode.value = true
  planStore.startStream(selectedIncidentId.value)
}

async function handleSyncGenerate(): Promise<void> {
  if (!selectedIncidentId.value) {
    ElMessage.warning('请先选择灾情事件')
    return
  }

  const planId = await planStore.generate(selectedIncidentId.value)

  if (planId) {
    ElMessage.success('方案生成成功')
    selectedPlanId.value = planId
    await planStore.fetchDetail(planId)
    await planStore.fetchList(selectedIncidentId.value)
  } else {
    ElMessage.error('方案生成失败，请稍后重试')
  }
}

function handleStopStream(): void {
  planStore.stopStream()
  streamMode.value = false
  if (selectedIncidentId.value) {
    planStore.fetchList(selectedIncidentId.value)
  }
}

async function selectPlan(planId: string): Promise<void> {
  streamMode.value = false
  isEditing.value = false
  contentConfirmed.value = false
  selectedPlanId.value = planId
  await planStore.fetchDetail(planId)
  checkEditPermission()
}

function handleStartEdit(): void {
  isEditing.value = true
  editedContent.value = planStore.currentPlan?.planContent || ''
}

function handleSaveEdit(): void {
  if (planStore.currentPlan) {
    planStore.currentPlan.planContent = editedContent.value
  }
  isEditing.value = false
  ElMessage.success('编辑成功')
  ElMessage.info('编辑功能需要后端接口支持（暂未实现持久化）')
}

function handleCancelEdit(): void {
  isEditing.value = false
}

async function handleApprove(): Promise<void> {
  if (!planStore.currentPlan) return
  try {
    await ElMessageBox.confirm('确认审批通过该方案？', '审批确认', {
      confirmButtonText: '通过',
      cancelButtonText: '取消',
      type: 'success',
    })
    planStore.currentPlan.status = 'approved'
    ElMessage.success('方案已审批通过')
  } catch { /* cancelled */ }
}

async function handleReject(): Promise<void> {
  if (!planStore.currentPlan) return
  try {
    await ElMessageBox.confirm('确认驳回该方案？', '驳回确认', {
      confirmButtonText: '驳回',
      cancelButtonText: '取消',
      type: 'warning',
    })
    planStore.currentPlan.status = 'rejected'
    ElMessage.success('方案已驳回')
  } catch { /* cancelled */ }
}

async function handleSubmitDisposalPlan(): Promise<void> {
  if (!planStore.currentPlan) return
  try {
    await disposalPlanStore.submitDisposalPlan(planStore.currentPlan.id)
    ElMessage.success('处置方案已提交')
  } catch {
    ElMessage.error('提交失败，请稍后重试')
  }
}

onMounted(() => {
  loadIncidents()
  const incidentId = route.query.incidentId as string | undefined
  if (incidentId) {
    selectedIncidentId.value = incidentId
    loadPlans()
  }
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
            :loading="planStore.streaming"
            @click="handleStreamGenerate"
          >
            {{ planStore.streaming ? '生成中...' : '流式生成' }}
          </el-button>
          <el-button
            :loading="planStore.generating"
            @click="handleSyncGenerate"
          >
            {{ planStore.generating ? '生成中...' : '同步生成' }}
          </el-button>
          <el-button
            v-if="planStore.streaming"
            type="danger"
            @click="handleStopStream"
          >
            停止
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
            <span>{{ plan.generateTime ? formatDate(plan.generateTime, 'YYYY-MM-DD HH:mm') : '-' }}</span>
            <el-tag size="small" :type="PlanStatusTagType[plan.status as PlanStatusValue] ?? 'info'">
              {{ PlanStatusLabel[plan.status as PlanStatusValue] ?? plan.status }}
            </el-tag>
          </div>
        </div>
      </el-card>

      <el-card shadow="hover" class="plan-page__detail">
        <template #header>
          <div class="plan-page__detail-header">
            <div class="plan-page__detail-header-left">
              <span>方案详情</span>
              <StatusTag
                v-if="planStore.currentPlan"
                :status="planStore.currentPlan.status"
                :status-map="disposalPlanStatusMap"
              />
            </div>
            <div v-if="planStore.currentPlan && planStore.currentPlan.status === 'draft' && !isEditing" class="plan-page__actions">
              <el-button v-if="canEdit" size="small" @click="handleStartEdit">编辑</el-button>
              <el-button type="success" size="small" @click="handleApprove">审批通过</el-button>
              <el-button type="danger" size="small" @click="handleReject">驳回</el-button>
            </div>
          </div>
        </template>

        <div v-if="streamMode && planStore.streaming" class="plan-page__stream">
          <div class="plan-page__stream-content">
            <div class="plan-page__stream-text">{{ planStore.streamingContent }}</div>
            <span class="plan-page__cursor">|</span>
          </div>
        </div>

        <div v-else-if="streamMode && planStore.streamingContent && !planStore.streaming" class="plan-page__stream">
          <div class="plan-page__stream-content">
            <div class="plan-page__stream-text">{{ planStore.streamingContent }}</div>
          </div>
        </div>

        <div v-else-if="!planStore.currentPlan" class="plan-page__empty">请选择或生成方案</div>
        <div v-else class="plan-page__content">
          <h3>{{ planStore.currentPlan.planTitle }}</h3>
          <div class="plan-page__content-meta">
            <span>生成时间：{{ planStore.currentPlan.generateTime ? formatDate(planStore.currentPlan.generateTime) : '-' }}</span>
            <el-tag size="small" :type="PlanStatusTagType[planStore.currentPlan.status as PlanStatusValue] ?? 'info'">
              {{ PlanStatusLabel[planStore.currentPlan.status as PlanStatusValue] }}
            </el-tag>
          </div>
          <el-divider />
          <template v-if="isEditing">
            <el-input
              v-model="editedContent"
              type="textarea"
              :rows="20"
              placeholder="请编辑预案内容"
            />
            <div class="plan-page__edit-actions">
              <el-button type="primary" @click="handleSaveEdit">保存</el-button>
              <el-button @click="handleCancelEdit">取消</el-button>
            </div>
          </template>
          <template v-else>
            <div class="plan-page__content-body" v-html="planStore.currentPlan.planContent" />
            <div class="plan-page__submit-area" v-if="!isEditing && planStore.currentPlan.planContent">
              <el-checkbox v-model="contentConfirmed">确认方案内容</el-checkbox>
              <el-button
                v-if="authStore.roleName === 'OPERATOR' && contentConfirmed && planStore.currentPlan"
                type="primary"
                @click="handleSubmitDisposalPlan"
              >
                提交处置方案
              </el-button>
            </div>
          </template>
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

.plan-page__detail-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}

.plan-page__detail-header-left {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.plan-page__actions {
  display: flex;
  gap: var(--spacing-xs);
}

.plan-page__stream {
  min-height: 300px;
  padding: var(--spacing-md);
}

.plan-page__stream-content {
  display: flex;
  align-items: flex-start;
}

.plan-page__stream-text {
  white-space: pre-wrap;
  line-height: 1.8;
  color: var(--color-text-regular);
}

.plan-page__cursor {
  animation: blink 1s step-end infinite;
  color: var(--color-primary);
  font-weight: bold;
  margin-left: 2px;
}

@keyframes blink {
  50% { opacity: 0; }
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

.plan-page__edit-actions {
  margin-top: var(--spacing-md);
  display: flex;
  gap: var(--spacing-sm);
}

.plan-page__submit-area {
  margin-top: var(--spacing-md);
  padding-top: var(--spacing-md);
  border-top: 1px solid var(--color-border-light);
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}
</style>
