<script setup lang="ts">
defineProps<{
  status: string
  statusMap: Record<string, { label: string; type: string }>
}>()
</script>

<template>
  <el-tag :type="statusMap[status]?.type ?? 'info'" size="default">
    {{ statusMap[status]?.label ?? status }}
  </el-tag>
</template>