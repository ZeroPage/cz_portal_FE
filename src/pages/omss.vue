<template>
  <div class="oms-container">
    <transition name="fade-title">
      <h1 v-if="show" class="title">
        OMS 자료
      </h1>
    </transition>

    <transition name="fade-content">
      <div v-if="show" class="oms-list">
        <!-- 각 OMS 항목 -->
        <div
            v-for="oms in omss"
            :key="oms.id"
            class="oms-item"
            @click="goToDetail(oms.id)"
        >
          <div class="oms-info">
            <h3 class="oms-title">{{ oms.title }}</h3>
            <p class="oms-subtitle">{{ oms.subtitle }}</p>
          </div>
          <div class="oms-meta">
            <p class="oms-date">{{ oms.date }}</p>
            <p class="oms-presenter">발표자: {{ oms.presenter }}</p>
          </div>
        </div>

        <!-- 작년 자료 링크 -->
        <div class="oms-item archive-link" @click="goToArchive">
          <div class="oms-info">
            <h3 class="oms-title">작년 OMS 모음</h3>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";

export default {
  name: "OMSS",
  setup() {
    const show = ref(false);
    const router = useRouter();
    const omss = ref([]);

    const loadOMSS = async () => {
      try {
        const response = await fetch('/omss.json');
        const data = await response.json();
        omss.value = data.sort((a, b) => b.id - a.id);
      } catch (error) {
        console.error('Failed to load OMS data:', error);
      }
    };

    const goToDetail = (id) => {
      router.push(`/oms/${id}`);
    };

    const goToArchive = () => {
      window.location.href = "https://portal.zeropage.org/oms";
    };

    onMounted(async () => {
      await loadOMSS();
      show.value = true;
    });

    return {show, omss, goToDetail, goToArchive};
  },
};
</script>


<style scoped>
.oms-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  overflow: hidden;
  color: white;
  text-align: center;
  position: relative;
  padding-bottom: clamp(40px, 8vh, 80px);
  padding-top: clamp(40px, 8vh, 80px);
}

.title {
  margin-top: clamp(60px, 8vh, 100px);
  margin-bottom: clamp(20px, 4vh, 30px);
}

.oms-list {
  width: 90%;
  height: 60vh;
  overflow-y: auto;
  padding: clamp(16px, 3vw, 20px);
  background: rgba(255, 255, 255, 0.1);
  border-radius: clamp(8px, 1vw, 10px);
  box-shadow: 0 8px 32px rgba(255, 255, 255, 0.1);
}

.oms-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: clamp(10px, 2vw, 15px);
  margin-bottom: clamp(8px, 1.5vw, 12px);
  background: rgba(255, 255, 255, 0.2);
  border-radius: clamp(6px, 1vw, 8px);
  cursor: pointer;
  transition: all 0.3s ease-in-out;
}

.oms-item:hover {
  background: rgba(255, 255, 255, 0.4);
}

.oms-info {
  text-align: left;
}

.oms-title {
  font-size: clamp(0.8rem, 2.5vw, 1.1rem);
  font-weight: bold;
}

.oms-subtitle {
  font-size: clamp(0.65rem, 2vw, 0.95rem);
  opacity: 0.8;
}

.oms-meta {
  text-align: right;
}

.oms-date,
.oms-presenter {
  font-size: clamp(0.55rem, 1.5vw, 0.85rem);
  font-weight: bold;
}

.archive-link {
  background: rgba(229, 115, 115, 0.3);
  text-align: center;
  font-size: clamp(0.9rem, 2vw, 1rem);
  font-weight: bold;
  color: white;
}

.archive-link:hover {
  background: rgba(229, 115, 115, 0.5);
}

.fade-title-enter-active,
.fade-content-enter-active {
  transition: opacity 1s ease, transform 0.8s ease;
}

.fade-title-enter-from,
.fade-content-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.oms-list::-webkit-scrollbar {
  width: clamp(6px, 0.6vw, 8px);
}

.oms-list::-webkit-scrollbar-track {
  background: transparent;
}

.oms-list::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

.oms-list::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}
</style>

