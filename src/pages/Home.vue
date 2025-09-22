<template>
  <div class="home-container">
    <div class="content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">
          <span class="full-title">CLUG X ZeroPage</span>
        </h1>
      </transition>
      <div class="qr-section">
        <img
          src="/images/QR 코드.png"
          alt="동아리 신청 QR 코드"
          class="qr-code"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
  name: "Home",
  setup() {
    const show = ref(false);

    onMounted(() => {
      show.value = true;
    });

    return { show };
  },
};
</script>

<style scoped>
.qr-section {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

.qr-code {
  width: 200px;
  height: auto;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

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

.home-container {
  min-height: calc(100vh - 80px);
  display: flex;
  justify-content: center;
  align-items: center;
  overflow: hidden;
  padding: 5% 5% 0;
  padding-top: 20px;
}

.content {
  max-width: 1400px;
  width: 100%;
  text-align: center;
  position: relative;
  z-index: 1;
}

.quiz-box {
  background: rgba(255, 255, 255, 0.05);
  padding: 2rem;
  border-radius: 1rem;
  margin-top: 2rem;
  color: white;
}

.question {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  font-weight: bold;
}

.code {
  background-color: rgba(255, 255, 255, 0.1);
  padding: 1rem;
  border-radius: 0.5rem;
  text-align: left;
  white-space: pre-wrap;
  margin-bottom: 1.5rem;
  font-family: monospace;
  font-size: 1rem;
}

/* 반응형 */
@media (max-width: 768px) {
  .home-container {
    min-height: calc(100vh - 80px);
    padding: 20px;
    padding-top: 40px;
  }

  .title {
    font-size: 2.5rem;
  }

  .question {
    font-size: 1.2rem;
  }
}

@media (max-width: 480px) {
  .home-container {
    padding: 15px;
    padding-top: 30px;
  }

  .title {
    font-size: 2rem;
  }

  .full-title {
    display: inline;
  }

  .short-title {
    display: none;
  }

  .description {
    font-size: 1rem;
  }

  .code {
    font-size: 0.85rem;
  }
}
</style>
