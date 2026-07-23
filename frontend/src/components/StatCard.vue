<script setup lang="ts">
defineProps<{
  title: string
  value: number | string
  icon?: string
  loading?: boolean
}>()
</script>

<template>
  <div class="stat-card">
    <el-card shadow="hover">
      <div class="stat-card__content">
        <div class="stat-card__info">
          <div class="stat-card__title">{{ title }}</div>
          <div class="stat-card__value" v-if="!loading">
            {{ value ?? '--' }}
          </div>
          <el-skeleton v-else :rows="1" animated />
        </div>
        <div class="stat-card__icon" v-if="icon">
          <el-icon :size="40" color="var(--color-primary)">
            <component :is="icon" />
          </el-icon>
        </div>
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.stat-card__content {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.stat-card__title {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  margin-bottom: var(--spacing-sm);
}

.stat-card__value {
  font-size: 28px;
  font-weight: 700;
  color: var(--color-text-primary);
}

.stat-card__icon {
  opacity: 0.8;
}
</style>