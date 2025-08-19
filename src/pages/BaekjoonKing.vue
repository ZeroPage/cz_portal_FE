<template>
  <div class="ranking-container">
    <div class="content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">
          <span class="full-title">2학기에 만나요</span>
        </h1>
      </transition>
      <transition name="fade-content">
        <div v-if="show" class="farewell-box">
          <p class="farewell-message">
            방학동안 백준킹은 쉬어갑니다.<br>
          </p>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
  name: "BaekjoonKing",
  setup() {
    const show = ref(false);

    onMounted(() => {
      show.value = true;
    });

    return {
      show,
    };
  },
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&family=Noto+Sans+KR:wght@400;700&display=swap');

.ranking-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
  padding: 5% 5% 0;
  background: #121212;
  font-family: 'Poppins', 'Noto Sans KR', sans-serif;
}
.content {
  max-width: 900px;
  width: 100%;
  text-align: center;
  position: relative;
  z-index: 1;
}

.title {
  font-size: 3rem;
  font-weight: 700;
  color: #fff;
  letter-spacing: 2px;
  margin-bottom: 1.5rem;
  text-shadow: 0 4px 24px rgba(0,0,0,0.2);
}

.farewell-box {
  background: rgba(255, 255, 255, 0.05);
  padding: 2rem;
  border-radius: 1rem;
  margin-top: 2rem;
  color: white;
  box-shadow: 0 4px 32px rgba(0,0,0,0.12);
}

.farewell-message {
  font-size: 1.5rem;
  font-weight: 600;
  margin: 0;
  line-height: 1.6;
  letter-spacing: 1px;
}

/* Fade animation */
.fade-title-enter-active {
  transition: opacity 0.8s ease, transform 0.6s ease;
}
.fade-title-enter-from {
  opacity: 0;
  transform: translateY(10px);
}
.fade-content-enter-active {
  transition: opacity 0.8s ease 0.3s, transform 0.6s ease 0.3s;
}
.fade-content-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

/* Responsive */
@media (max-width: 768px) {
  .ranking-container {
    padding-top: 10%;
  }
  .title {
    font-size: 2.2rem;
  }
  .farewell-message {
    font-size: 1.1rem;
  }
}

@media (max-width: 480px) {
  .title {
    font-size: 1.5rem;
  }
  .content {
    padding: 0 1rem;
  }
  .farewell-message {
    font-size: 1rem;
  }
}
</style>
