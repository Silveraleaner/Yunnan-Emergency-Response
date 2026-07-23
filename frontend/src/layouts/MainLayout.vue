<script setup lang="ts">
import { ref } from 'vue'
import AppHeader from './components/AppHeader.vue'
import AppSidebar from './components/AppSidebar.vue'

const sidebarCollapsed = ref(false)

function toggleSidebar(): void {
  sidebarCollapsed.value = !sidebarCollapsed.value
}
</script>

<template>
  <div class="main-layout">
    <AppSidebar :collapsed="sidebarCollapsed" />
    <div class="main-layout__right" :class="{ 'main-layout__right--collapsed': sidebarCollapsed }">
      <AppHeader @toggle-sidebar="toggleSidebar" />
      <main class="main-layout__content">
        <RouterView v-slot="{ Component }">
          <Transition name="slide-fade" mode="out-in">
            <component :is="Component" />
          </Transition>
        </RouterView>
      </main>
    </div>
  </div>
</template>

<style scoped>
.main-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.main-layout__right {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  margin-left: var(--sidebar-width);
  transition: margin-left var(--transition-duration);
}

.main-layout__right--collapsed {
  margin-left: var(--sidebar-collapsed-width);
}

.main-layout__content {
  flex: 1;
  overflow-y: auto;
  background-color: var(--color-bg-page);
  padding: var(--spacing-lg);
}
</style>