<template>
  <div class="oms-container">
    <div class="content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">OMS of the Week</h1>
      </transition>

      <div v-if="loading" class="loading">
        <p>로딩 중...</p>
      </div>

      <div v-else-if="error" class="error">
        <p>OMS 정보를 불러올 수 없습니다</p>
      </div>

      <div v-else>
        <transition name="fade-content">
          <p v-if="show" class="oms-title">{{ omsTitle }}</p>
        </transition>

        <transition name="fade-content">
          <p v-if="show" class="description">{{ description }}</p>
        </transition>

        <transition name="fade-content">
          <p v-if="show" class="presenter">발표자: {{ presenter }}</p>
        </transition>
      </div>
    </div>

    <transition name="fade-content">
      <footer v-if="show" class="footer">
        <router-link to="/omss" class="btn">역대 OMS</router-link>
      </footer>
    </transition>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
  name: "Oms",
  setup() {
    const show = ref(false);
    const loading = ref(true);
    const error = ref(false);
    
    const omsTitle = ref("");
    const description = ref("");
    const presenter = ref("");

    const loadLatestOms = async () => {
      try {
        const response = await fetch("/omss.json");
        const data = await response.json();
        
        if (data && data.length > 0) {
          // 가장 최근 OMS 데이터 가져오기 (배열의 마지막 요소)
          const latestOms = data[data.length - 1];
          
          omsTitle.value = latestOms.title;
          description.value = latestOms.description;
          presenter.value = latestOms.presenter;
        }
      } catch (err) {
        console.error("OMS 데이터 로딩 실패:", err);
        error.value = true;
      } finally {
        loading.value = false;
        setTimeout(() => {
          show.value = true;
        }, 100);
      }
    };

    onMounted(() => {
      loadLatestOms();
    });

    return { 
      show, 
      loading, 
      error, 
      omsTitle, 
      description, 
      presenter 
    };
  },
};
</script>

<style scoped>
.fade-title-enter-active {
  transition: opacity 1s ease, transform 0.8s ease;
}
.fade-title-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.fade-content-enter-active {
  transition: opacity 1s ease 0.5s, transform 0.8s ease 0.5s;
}
.fade-content-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.oms-container {
  min-height: calc(100vh - 80px);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  overflow: hidden;
  text-align: center;
  padding: clamp(20px, 5vh, 60px) clamp(10px, 5vw, 40px);
  padding-top: 20px;
}

.content {
  max-width: 1400px;
  width: 100%;
  position: relative;
  z-index: 1;
}

.title {
  background: linear-gradient(45deg, #1E3A8A, #2563EB, #38BDF8, #60A5FA);
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 800;
  margin-bottom: 2rem;
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 300%;
  animation: gradient 8s linear infinite;
}

@keyframes gradient {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.loading, .error {
  color: white;
  font-size: 1.2rem;
  padding: 20px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  margin: 20px 0;
}

.oms-title {
  font-weight: 700;
  color: white;
  padding: clamp(8px, 1vw, 10px) clamp(16px, 2vw, 20px);
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 15px;
  display: inline-block;
  letter-spacing: 1px;
  max-width: 90vw;
  width: fit-content;
  white-space: nowrap;
  font-size: clamp(1.2rem, 4.5vw, 3rem);
  box-shadow: 0 8px 32px rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.description {
  font-size: clamp(1rem, 2.2vw, 1.5rem);
  margin-top: clamp(8px, 1vh, 12px);
  color: rgba(255, 255, 255, 0.8);
}

.presenter {
  font-size: clamp(0.9rem, 1.8vw, 1.2rem);
  margin-top: clamp(4px, 0.8vh, 8px);
  color: rgba(255, 255, 255, 0.6);
}

.footer {
  position: absolute;
  bottom: clamp(16px, 3vh, 30px);
  width: 100%;
  display: flex;
  justify-content: center;
  gap: clamp(20px, 5vw, 40px);
}

.btn {
  width: clamp(120px, 18vw, 150px);
  height: clamp(40px, 6vh, 50px);
  font-size: clamp(1rem, 2vw, 1.2rem);
  font-weight: bold;
  color: white;
  text-decoration: none;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease-in-out;
  backdrop-filter: blur(10px);
}

.btn:hover {
  background: rgba(255, 255, 255, 0.4);
  box-shadow: 0 6px 20px rgba(255, 255, 255, 0.2);
}

/* 모바일 대응 */
@media (max-width: 768px) {
  .oms-container {
    padding: 20px 15px;
    min-height: calc(100vh - 80px);
  }
  
  .title {
    font-size: clamp(2rem, 8vw, 3rem);
    margin-bottom: 1.5rem;
  }
  
  .oms-title {
    font-size: clamp(1rem, 6vw, 2rem);
    white-space: normal;
    text-align: center;
  }
}
</style>