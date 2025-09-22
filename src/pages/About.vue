<template>
  <div class="about-container">
    <!-- 배경 장식 -->
    <div class="background-decoration">
      <div class="floating-shape shape-1"></div>
      <div class="floating-shape shape-2"></div>
      <div class="floating-shape shape-3"></div>
    </div>

    <div class="content-wrapper">
      <transition name="fade-title">
        <div v-if="show" class="header-section">
          <h1 class="title">✨ About Us</h1>
          <div class="title-underline"></div>
        </div>
      </transition>

      <transition name="fade-content">
        <div v-if="show" class="description-section">
          <p class="description">저희 동아리가 궁금하시다면?</p>
          <p class="sub-description">
            아래를 클릭해서 각 동아리를 방문해보세요!
          </p>
        </div>
      </transition>

      <transition name="fade-clubs">
        <div v-if="show" class="clubs-container">
          <div class="club-card clug-card">
            <div class="club-icon">💻</div>
            <h3 class="club-name">CLUG</h3>
            <p class="club-description">CAU Linuxer & Unixer Group<br /></p>
            <router-link to="/clug" class="club-btn clug-btn">
              <span>둘러보기</span>
              <div class="btn-icon">→</div>
            </router-link>
          </div>

          <div class="club-card zeropage-card">
            <div class="club-icon">🚀</div>
            <h3 class="club-name">ZeroPage</h3>
            <p class="club-description">TOGETHER WE GE BETTER<br /></p>
            <router-link to="/zeropage" class="club-btn zeropage-btn">
              <span>둘러보기</span>
              <div class="btn-icon">→</div>
            </router-link>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";

export default {
  name: "About",
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
.about-container {
  min-height: 100vh;
  background: #0a0a0a;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  position: relative;
  overflow: hidden;
}

/* 배경 장식 */
.background-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
}

.floating-shape {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(
    45deg,
    rgba(255, 107, 129, 0.1),
    rgba(255, 181, 98, 0.1)
  );
  animation: float 6s ease-in-out infinite;
}

.shape-1 {
  width: 200px;
  height: 200px;
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.shape-2 {
  width: 150px;
  height: 150px;
  top: 70%;
  right: 15%;
  animation-delay: 2s;
}

.shape-3 {
  width: 100px;
  height: 100px;
  top: 20%;
  right: 20%;
  animation-delay: 4s;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0px) rotate(0deg);
    opacity: 0.3;
  }
  50% {
    transform: translateY(-20px) rotate(180deg);
    opacity: 0.1;
  }
}

/* 메인 컨텐츠 */
.content-wrapper {
  position: relative;
  z-index: 2;
  max-width: 1000px;
  width: 100%;
  padding: 0 20px;
}

/* 헤더 섹션 */
.header-section {
  margin-bottom: 40px;
}

.title {
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: bold;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 15px;
  line-height: 1.2;
}

.title-underline {
  width: 80px;
  height: 4px;
  background: linear-gradient(45deg, #ff2e63, #ff6b81);
  margin: 0 auto;
  border-radius: 2px;
}

/* 설명 섹션 */
.description-section {
  margin-bottom: 50px;
}

.description {
  font-size: clamp(1.3rem, 3vw, 1.8rem);
  color: white;
  margin-bottom: 15px;
  font-weight: 500;
  line-height: 1.4;
}

.sub-description {
  font-size: clamp(1rem, 2.5vw, 1.2rem);
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
  max-width: 600px;
  margin: 0 auto;
}

/* 클럽 카드들 */
.clubs-container {
  display: flex;
  justify-content: center;
  gap: clamp(20px, 5vw, 40px);
  margin-top: 40px;
  flex-wrap: wrap;
}

.club-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 40px 30px;
  width: clamp(280px, 40vw, 350px);
  backdrop-filter: blur(12px);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.club-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    45deg,
    transparent,
    rgba(255, 255, 255, 0.02),
    transparent
  );
  transform: translateX(-100%);
  transition: transform 0.6s;
}

.club-card:hover::before {
  transform: translateX(100%);
}

.club-card:hover {
  transform: translateY(-10px);
  border-color: rgba(255, 107, 129, 0.3);
  box-shadow: 0 15px 35px rgba(255, 107, 129, 0.2);
}

.clug-card:hover {
  border-color: rgba(100, 200, 255, 0.4);
  box-shadow: 0 15px 35px rgba(100, 200, 255, 0.2);
}

.zeropage-card:hover {
  border-color: rgba(255, 181, 98, 0.4);
  box-shadow: 0 15px 35px rgba(255, 181, 98, 0.2);
}

.club-icon {
  font-size: 3rem;
  margin-bottom: 20px;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
}

.club-name {
  font-size: 1.8rem;
  font-weight: bold;
  color: white;
  margin-bottom: 15px;
}

.club-description {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1rem;
  line-height: 1.6;
  margin-bottom: 25px;
}

.club-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: linear-gradient(45deg, #ff2e63, #ff6b81);
  color: white;
  text-decoration: none;
  padding: 12px 25px;
  border-radius: 25px;
  font-weight: bold;
  font-size: 0.95rem;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.clug-btn {
  background: linear-gradient(45deg, #64c8ff, #4facfe);
}

.zeropage-btn {
  background: linear-gradient(45deg, #ffb562, #ff9a56);
}

.club-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(255, 107, 129, 0.4);
}

.clug-btn:hover {
  box-shadow: 0 8px 20px rgba(100, 200, 255, 0.4);
}

.zeropage-btn:hover {
  box-shadow: 0 8px 20px rgba(255, 181, 98, 0.4);
}

.btn-icon {
  transition: transform 0.3s ease;
}

.club-btn:hover .btn-icon {
  transform: translateX(3px);
}

/* 애니메이션 */
.fade-title-enter-active {
  transition: opacity 1s ease, transform 0.8s ease;
}

.fade-title-enter-from {
  opacity: 0;
  transform: translateY(-20px);
}

.fade-content-enter-active {
  transition: opacity 1s ease 0.3s, transform 0.8s ease 0.3s;
}

.fade-content-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.fade-clubs-enter-active {
  transition: opacity 1.2s ease 0.6s, transform 1s ease 0.6s;
}

.fade-clubs-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

/* 반응형 */
@media (max-width: 768px) {
  .content-wrapper {
    padding: 0 15px;
  }

  .clubs-container {
    flex-direction: column;
    align-items: center;
  }

  .club-card {
    width: 100%;
    max-width: 350px;
    padding: 30px 25px;
  }

  .shape-1,
  .shape-2,
  .shape-3 {
    display: none;
  }
}

@media (max-width: 480px) {
  .club-card {
    padding: 25px 20px;
  }

  .club-icon {
    font-size: 2.5rem;
  }

  .club-name {
    font-size: 1.5rem;
  }
}
</style>
