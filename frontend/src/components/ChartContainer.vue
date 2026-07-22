<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'
import * as echarts from 'echarts/core'
import { LineChart, PieChart, MapChart, ScatterChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GeoComponent,
  VisualMapComponent,
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import type { EChartsOption } from 'echarts'

echarts.use([
  LineChart,
  PieChart,
  MapChart,
  ScatterChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GeoComponent,
  VisualMapComponent,
  CanvasRenderer,
])

const props = defineProps<{
  option: EChartsOption
  loading?: boolean
}>()

const chartRef = ref<HTMLDivElement>()
let chartInstance: echarts.ECharts | null = null

function initChart(): void {
  if (!chartRef.value) return
  chartInstance = echarts.init(chartRef.value)
  chartInstance.setOption(props.option)
}

function handleResize(): void {
  chartInstance?.resize()
}

watch(
  () => props.option,
  (newOption) => {
    if (chartInstance) {
      chartInstance.setOption(newOption, true)
    }
  },
  { deep: true }
)

watch(
  () => props.loading,
  (val) => {
    if (chartInstance) {
      val ? chartInstance.showLoading() : chartInstance.hideLoading()
    }
  }
)

onMounted(() => {
  initChart()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  chartInstance?.dispose()
  chartInstance = null
})
</script>

<template>
  <div ref="chartRef" class="chart-container"></div>
</template>

<style scoped>
.chart-container {
  width: 100%;
  height: 100%;
  min-height: 300px;
}
</style>