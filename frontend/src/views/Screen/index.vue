<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import ChartContainer from '@/components/ChartContainer.vue'
import IncidentMap from '@/components/IncidentMap.vue'
import { getScreenData } from '@/api/dashboard'
import type { ScreenData, MapIncident } from '@/types/dashboard'
import { DisasterTypeLabel, IncidentLevelLabel } from '@/types/enums'
import type { DisasterTypeValue, IncidentLevelValue } from '@/types/enums'
import type { EChartsOption } from 'echarts'

const router = useRouter()

const screenData = ref<ScreenData | null>(null)
const loading = ref(true)
let refreshTimer: ReturnType<typeof setInterval> | null = null

const filterDisasterType = ref<DisasterTypeValue | ''>('')
const filterIncidentLevel = ref<IncidentLevelValue | ''>('')

const disasterTypeOptions = Object.entries(DisasterTypeLabel).map(([value, label]) => ({ value, label }))
const levelOptions = Object.entries(IncidentLevelLabel).map(([value, label]) => ({ value, label }))

const filteredMapIncidents = computed<MapIncident[]>(() => {
  const list = screenData.value?.mapIncidents ?? []
  return list.filter((inc) => {
    if (filterDisasterType.value && inc.disasterType !== filterDisasterType.value) return false
    if (filterIncidentLevel.value && inc.incidentLevel !== filterIncidentLevel.value) return false
    return true
  })
})

const trendOption = ref<EChartsOption>({})
const resourceOption = ref<EChartsOption>({})

function buildTrendOption(data: ScreenData): EChartsOption {
  const incidentsByType: Record<string, number> = {}
  data.incidents.forEach((inc) => {
    incidentsByType[inc.disasterType] = (incidentsByType[inc.disasterType] || 0) + 1
  })
  return {
    title: { text: '灾情类型统计', textStyle: { color: '#fff', fontSize: 14 } },
    tooltip: { trigger: 'item' },
    series: [
      {
        type: 'pie',
        radius: ['35%', '65%'],
        center: ['50%', '55%'],
        data: Object.entries(incidentsByType).map(([name, value]) => ({ name, value })),
        label: { color: '#fff' },
      },
    ],
  }
}

function buildResourceOption(data: ScreenData): EChartsOption {
  const resourcesByType: Record<string, number> = {}
  data.resources.forEach((res) => {
    resourcesByType[res.resourceType] = (resourcesByType[res.resourceType] || 0) + res.quantity
  })
  return {
    title: { text: '资源分布', textStyle: { color: '#fff', fontSize: 14 } },
    tooltip: { trigger: 'axis' },
    xAxis: {
      type: 'category',
      data: Object.keys(resourcesByType),
      axisLabel: { color: '#fff' },
    },
    yAxis: { type: 'value', axisLabel: { color: '#fff' } },
    series: [
      {
        type: 'bar',
        data: Object.values(resourcesByType),
        itemStyle: { color: '#409eff' },
      },
    ],
  }
}

async function loadData(): Promise<void> {
  try {
    const res = await getScreenData() as unknown as ScreenData
    screenData.value = res
    trendOption.value = buildTrendOption(res)
    resourceOption.value = buildResourceOption(res)
  } catch {
    // Keep previous data
  } finally {
    loading.value = false
  }
}

function enterFullscreen(): void {
  document.documentElement.requestFullscreen().catch(() => {})
}

function exitFullscreen(): void {
  if (document.fullscreenElement) {
    document.exitFullscreen().catch(() => {})
  }
}

function handleKeydown(e: KeyboardEvent): void {
  if (e.key === 'Escape') {
    router.push('/home')
  }
}

onMounted(() => {
  enterFullscreen()
  loadData()
  refreshTimer = setInterval(loadData, 60000)
  document.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
    refreshTimer = null
  }
  exitFullscreen()
  document.removeEventListener('keydown', handleKeydown)
})
</script>

<template>
  <div class="screen-page">
    <div class="screen-page__header">
      <h1>云南自然灾害应急协同决策平台</h1>
      <el-button text @click="router.push('/home')" style="color: #fff">
        <el-icon><Close /></el-icon>
        退出大屏
      </el-button>
    </div>

    <div class="screen-page__stats" v-if="screenData">
      <div class="screen-page__stat">
        <div class="screen-page__stat-value">{{ screenData.statistics.todayCount }}</div>
        <div class="screen-page__stat-label">今日事件数</div>
      </div>
      <div class="screen-page__stat">
        <div class="screen-page__stat-value">{{ screenData.statistics.activeCount }}</div>
        <div class="screen-page__stat-label">活跃事件数</div>
      </div>
      <div class="screen-page__stat">
        <div class="screen-page__stat-value">{{ screenData.statistics.completedCount }}</div>
        <div class="screen-page__stat-label">已结束事件</div>
      </div>
    </div>

    <div class="screen-page__filter" v-if="screenData">
      <el-select v-model="filterDisasterType" placeholder="灾害类型" clearable size="small" style="width: 120px; margin-right: 8px">
        <el-option v-for="opt in disasterTypeOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
      </el-select>
      <el-select v-model="filterIncidentLevel" placeholder="事件等级" clearable size="small" style="width: 120px">
        <el-option v-for="opt in levelOptions" :key="opt.value" :label="opt.label" :value="opt.value" />
      </el-select>
    </div>

    <div class="screen-page__body" v-if="screenData">
      <div class="screen-page__map-area">
        <IncidentMap :incidents="filteredMapIncidents" />
      </div>
      <div class="screen-page__charts-area">
        <div class="screen-page__chart-area">
          <ChartContainer :option="trendOption" />
        </div>
        <div class="screen-page__chart-area">
          <ChartContainer :option="resourceOption" />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.screen-page {
  width: 100vw;
  height: 100vh;
  background: linear-gradient(135deg, #0d1b3e 0%, #0a1628 50%, #060e1a 100%);
  color: #fff;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.screen-page__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 32px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.screen-page__header h1 {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: 4px;
  margin: 0;
}

.screen-page__stats {
  display: flex;
  justify-content: center;
  gap: 80px;
  padding: 16px 32px;
}

.screen-page__stat {
  text-align: center;
}

.screen-page__stat-value {
  font-size: 36px;
  font-weight: 700;
  color: #409eff;
}

.screen-page__stat-label {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 4px;
}

.screen-page__filter {
  display: flex;
  justify-content: center;
  padding: 0 32px 8px;
}

.screen-page__body {
  flex: 1;
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 16px;
  padding: 0 32px 16px;
  min-height: 0;
}

.screen-page__map-area {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
}

.screen-page__charts-area {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.screen-page__chart-area {
  flex: 1;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}
</style>
