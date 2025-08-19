<template>
  <div class="article-container">
    <div class = "content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">coming soon</h1>
      </transition>
    </div>
  </div>
</template>

<script>
import {ref, onMounted} from "vue";

export default {
  name: "Articles",
  setup() {
    const show = ref(false);

    onMounted(() => {
      show.value = true; // 페이지가 로드되면 애니메이션 실행
    });

    return {show};
  },
};
</script>

<style scoped>
.title {
  background: linear-gradient(45deg, #1E3A8A, #2563EB, #38BDF8, #60A5FA);;
  font-size: clamp(3rem, 5.5vw, 5.5rem);
  font-weight: 800;
  margin-bottom: 2rem;
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: gradient 8s linear infinite;
  background-size: 300%;
  line-height: 1.1;
  text-transform: uppercase;
  letter-spacing: -2px;
}

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

.article-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  overflow: hidden;
}

.content {
  max-width: 1400px;
  width: 100%;
  text-align: center;
  position: relative;
  z-index: 1;
}
</style>
