<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useIncidentStore } from '@/stores/incident'
import StatusTag from '@/components/StatusTag.vue'
import {
  DisasterTypeLabel,
  IncidentLevelLabel,
  IncidentStatusLabel,
  IncidentStatusTagType,
} from '@/types/enums'
import type { DisasterTypeValue, IncidentLevelValue, IncidentStatusValue } from '@/types/enums'
import { formatDate } from '@/utils/format'

const route = useRoute()
const router = useRouter()
const incidentStore = useIncidentStore()

const statusMap = Object.fromEntries(
  Object.entries(IncidentStatusLabel).map(([key, label]) => [
    key,
    { label, type: IncidentStatusTagType[key as IncidentStatusValue] },
  ])
)

const incidentId = route.params.id as string

onMounted(() => {
  incidentStore.fetchDetail(incidentId)
})
</script>

<template>
  <div class="incident-detail page-container">
    <div class="page-header">
      <h2 class="page-header__title">事件详情</h2>
      <el-button @click="router.back()">
        <el-icon><ArrowLeft /></el-icon>
        返回
      </el-button>
    </div>

    <el-card shadow="hover" v-loading="incidentStore.loading">
      <template v-if="incidentStore.currentIncident">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="事件名称">
            {{ incidentStore.currentIncident.incidentName }}
          </el-descriptions-item>
          <el-descriptions-item label="灾害类型">
            {{ DisasterTypeLabel[incidentStore.currentIncident.disasterType as DisasterTypeValue] }}
          </el-descriptions-item>
          <el-descriptions-item label="事件等级">
            {{ IncidentLevelLabel[incidentStore.currentIncident.incidentLevel as IncidentLevelValue] }}
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <StatusTag :status="incidentStore.currentIncident.status" :status-map="statusMap" />
          </el-descriptions-item>
          <el-descriptions-item label="发生时间">
            {{ formatDate(incidentStore.currentIncident.occurTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="发生地点">
            {{ incidentStore.currentIncident.location }}
          </el-descriptions-item>
          <el-descriptions-item label="上报人">
            {{ incidentStore.currentIncident.reporterId }}
          </el-descriptions-item>
          <el-descriptions-item label="上报时间">
            {{ formatDate(incidentStore.currentIncident.reportTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="事件描述" :span="2">
            {{ incidentStore.currentIncident.description }}
          </el-descriptions-item>
        </el-descriptions>

        <div class="incident-detail__images" v-if="incidentStore.currentIncident.imageUrls?.length">
          <h3>现场图片</h3>
          <div class="incident-detail__image-list">
            <el-image
              v-for="(url, index) in incidentStore.currentIncident.imageUrls"
              :key="index"
              :src="url"
              fit="cover"
              class="incident-detail__image"
              :preview-src-list="incidentStore.currentIncident.imageUrls"
              :initial-index="index"
            >
              <template #error>
                <div class="incident-detail__image-error">
                  <el-icon><PictureFilled /></el-icon>
                  <span>图片加载失败</span>
                </div>
              </template>
            </el-image>
          </div>
        </div>

        <div class="incident-detail__attachments" v-if="incidentStore.currentIncident.attachments?.length">
          <h3>附件列表</h3>
          <el-table :data="incidentStore.currentIncident.attachments" stripe>
            <el-table-column prop="fileName" label="文件名" />
            <el-table-column prop="fileSize" label="文件大小" width="120">
              <template #default="{ row }">
                {{ (row.fileSize / 1024).toFixed(1) }} KB
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100">
              <template #default="{ row }">
                <el-link type="primary" :href="row.fileUrl" target="_blank">下载</el-link>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </template>
    </el-card>
  </div>
</template>

<style scoped>
.incident-detail__images {
  margin-top: var(--spacing-lg);
}

.incident-detail__images h3 {
  font-size: var(--font-size-lg);
  margin-bottom: var(--spacing-md);
}

.incident-detail__image-list {
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-sm);
}

.incident-detail__image {
  width: 160px;
  height: 120px;
  border-radius: var(--border-radius-sm);
  border: 1px solid var(--color-border-light);
}

.incident-detail__image-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  background: var(--color-bg-page);
  color: var(--color-text-secondary);
  font-size: var(--font-size-xs);
  gap: var(--spacing-xs);
}

.incident-detail__attachments {
  margin-top: var(--spacing-lg);
}

.incident-detail__attachments h3 {
  font-size: var(--font-size-lg);
  margin-bottom: var(--spacing-md);
}
</style>
