<template>
  <div class="oms-container">
    <div class="content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">OMS of the Week</h1>
      </transition>

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

    // 새로운 OMS title 추가
    const omsTitle = ref("넌 무슨 타입 트레이너야?");
    const description = ref("포켓몬 능력치 클러스터링으로 알아보는 전투 스타일");
    const presenter = ref("서유진");

    onMounted(() => {
      show.value = true;
    });

    return { show, omsTitle, description, presenter };
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
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  overflow: hidden;
  text-align: center;
  padding: clamp(20px, 5vh, 60px) clamp(10px, 5vw, 40px);
}

.content {
  max-width: 1400px;
  width: 100%;
  position: relative;
  z-index: 1;
}

.oms-title {
  font-weight: 700;
  color: white;
  padding: clamp(8px, 1vw, 10px) clamp(16px, 2vw, 20px);
  background: var(--glass-bg);
  border: var(--border);
  border-radius: 15px;
  display: inline-block;
  letter-spacing: 1px;
  max-width: 90vw;
  width: fit-content;
  white-space: nowrap;
  font-size: clamp(1.2rem, 4.5vw, 4.5rem);
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
}

.btn:hover {
  background: rgba(255, 255, 255, 0.4);
  box-shadow: 0 6px 20px rgba(255, 255, 255, 0.2);
}
</style>
