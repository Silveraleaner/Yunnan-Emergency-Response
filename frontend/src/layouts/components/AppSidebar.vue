<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'
import { computed } from 'vue'

defineProps<{
  collapsed: boolean
}>()

const route = useRoute()
const router = useRouter()

const menuItems = computed(() => {
  const mainRoute = router.options.routes.find((r) => r.path === '/')
  if (!mainRoute?.children) return []
  return mainRoute.children.filter((child) => child.meta?.hidden !== true)
})

const activeMenu = computed(() => {
  return route.path
})

function handleMenuSelect(index: string): void {
  router.push(index)
}
</script>

<template>
  <aside class="app-sidebar" :class="{ 'app-sidebar--collapsed': collapsed }">
    <div class="app-sidebar__logo">
      <el-icon :size="28" color="#fff"><Warning /></el-icon>
      <span v-show="!collapsed" class="app-sidebar__logo-text">应急决策平台</span>
    </div>
    <el-menu
      :default-active="activeMenu"
      :collapse="collapsed"
      background-color="var(--color-bg-sidebar)"
      text-color="rgba(255, 255, 255, 0.65)"
      active-text-color="#fff"
      @select="handleMenuSelect"
    >
      <template v-for="item in menuItems" :key="item.path">
        <el-sub-menu
          v-if="item.children?.length"
          :index="'/' + item.path"
        >
          <template #title>
            <el-icon><component :is="item.meta?.icon" /></el-icon>
            <span>{{ item.meta?.title }}</span>
          </template>
          <el-menu-item
            v-for="child in item.children.filter((c) => c.meta?.hidden !== true)"
            :key="child.path"
            :index="'/' + item.path + '/' + child.path"
          >
            <el-icon><component :is="child.meta?.icon" /></el-icon>
            <span>{{ child.meta?.title }}</span>
          </el-menu-item>
        </el-sub-menu>
        <el-menu-item v-else :index="'/' + item.path">
          <el-icon><component :is="item.meta?.icon" /></el-icon>
          <span>{{ item.meta?.title }}</span>
        </el-menu-item>
      </template>
    </el-menu>
  </aside>
</template>

<style scoped>
.app-sidebar {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  width: var(--sidebar-width);
  background-color: var(--color-bg-sidebar);
  transition: width var(--transition-duration);
  overflow-y: auto;
  overflow-x: hidden;
  z-index: 100;
}

.app-sidebar--collapsed {
  width: var(--sidebar-collapsed-width);
}

.app-sidebar__logo {
  height: var(--header-height);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-sm);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.app-sidebar__logo-text {
  color: #fff;
  font-size: var(--font-size-lg);
  font-weight: 600;
  white-space: nowrap;
}
</style>