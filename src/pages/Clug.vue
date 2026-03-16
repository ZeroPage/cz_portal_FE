<template>
  <div class="clug-container">
    <!-- 배경 장식 -->
    <div class="background-decoration">
      <div class="floating-shape shape-1"></div>
      <div class="floating-shape shape-2"></div>
      <div class="floating-shape shape-3"></div>
    </div>

    <div class="content-wrapper">
      <!-- 헤더 섹션 -->
      <transition name="fade-header">
        <div v-if="show" class="header-section">
          <div class="logo-container">
            <div class="logo-box">
              <img
                src="@/assets/clug-logo2.jpeg"
                alt="CLUG Logo"
                class="clug-logo"
              />
            </div>
          </div>
          <h1 class="page-title">CLUG</h1>
          <p class="page-subtitle">Creative Linux User Group</p>
          <div class="title-underline"></div>
        </div>
      </transition>

      <!-- 소개 섹션 -->
      <transition name="fade-intro">
        <div v-if="show" class="intro-section">
          <div class="intro-card">
            <h2>함께 성장하는 개발 여정</h2>
            <p>
              중앙대학교를 대표하는 오픈소스 소프트웨어 동아리 CLUG입니다!<br />
              자유 소프트웨어를 탐구하며 다양한 주제의 스터디와 프로젝트를
              통해<br />
              동료들과 함께 성장해나가는 공간입니다.
            </p>
          </div>
        </div>
      </transition>

      <!-- 활동 섹션 -->
      <transition name="fade-activities">
        <div v-if="show" class="activities-section">
          <h2 class="section-title">주요 활동</h2>
          <div class="activities-grid">
            <div
              v-for="(activity, index) in activities"
              :key="index"
              class="activity-card"
              :class="`activity-${index + 1}`"
            >
              <h3 class="activity-title">{{ activity.title }}</h3>
              <p class="activity-description">{{ activity.content }}</p>
            </div>
          </div>
        </div>
      </transition>

      <!-- 뒤로가기 버튼 -->
      <transition name="fade-back">
        <div v-if="show" class="back-section">
          <router-link to="/about" class="back-btn">
            <span>다른 동아리 보기</span>
          </router-link>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import { onMounted, ref } from "vue";

export default {
  name: "CLUG",
  setup() {
    const show = ref(false);
    const activities = [
      {
        title: "다양한 주제의 스터디",
        content:
          "운영체제, 네트워크, 보안, AI, 웹 개발 등 다양한 주제를 동료들과 함께 학습합니다.",
      },
      {
        title: "Git & GitHub 세미나",
        content:
          "버전 관리 도구인 Git과 GitHub를 기본부터 실전 활용법까지 익힐 수 있습니다.",
      },
      {
        title: "친구야 만나서 반가워",
        content:
          "새내기 교류 행사로 학교 주변 핫플레이스를 탐방하며 새로운 친구들을 만납니다.",
      },
      {
        title: "클론 코딩 프로젝트",
        content:
          "실제 서비스를 따라 만들며 프레임워크와 개발 기술을 실전에서 익힙니다.",
      },
      {
        title: "CLUG 해커톤",
        content:
          "팀원들과 함께 해커톤 형식으로 프로젝트를 진행하며 협업 능력을 기릅니다.",
      },
      {
        title: "이모저모 세미나",
        content:
          "업계에서 활동 중인 선배님들과 직접 소통하며 진로 관련 조언을 받습니다.",
      },
    ];

    onMounted(() => {
      show.value = true;
    });

    return { show, activities };
  },
};
</script>

<style scoped>
.clug-container {
  min-height: 100vh;
  background: #0a0a0a;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  position: relative;
  overflow-x: hidden;
  padding: 20px 0 40px 0;
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
    rgba(100, 200, 255, 0.1),
    rgba(79, 172, 254, 0.1)
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
  top: 60%;
  right: 15%;
  animation-delay: 2s;
}

.shape-3 {
  width: 100px;
  height: 100px;
  top: 30%;
  right: 25%;
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
  max-width: 1200px;
  width: 100%;
  padding: 0 20px;
}

/* 헤더 섹션 */
.header-section {
  text-align: center;
  margin-bottom: 60px;
  padding-top: 40px;
}

.logo-container {
  margin-bottom: 30px;
  display: flex;
  justify-content: center;
}

.logo-box {
  position: relative;
  width: 150px;
  height: 150px;
  border-radius: 20px;
  background: linear-gradient(45deg, #64c8ff, #4facfe);
  padding: 4px;
  box-shadow: 0 10px 30px rgba(100, 200, 255, 0.3);
}

.clug-logo {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 16px;
}

.page-title {
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: bold;
  background: linear-gradient(45deg, #64c8ff, #4facfe);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 10px;
  line-height: 1.2;
}

.page-subtitle {
  font-size: clamp(1rem, 2.5vw, 1.3rem);
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 20px;
  font-weight: 500;
}

.title-underline {
  width: 80px;
  height: 4px;
  background: linear-gradient(45deg, #64c8ff, #4facfe);
  margin: 0 auto;
  border-radius: 2px;
}

/* 소개 섹션 */
.intro-section {
  margin-bottom: 80px;
  display: flex;
  justify-content: center;
}

.intro-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(100, 200, 255, 0.2);
  border-radius: 20px;
  padding: 40px 35px;
  text-align: center;
  backdrop-filter: blur(12px);
  max-width: 600px;
  width: 100%;
  position: relative;
  overflow: hidden;
}

.intro-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    45deg,
    transparent,
    rgba(100, 200, 255, 0.02),
    transparent
  );
  transform: translateX(-100%);
  transition: transform 0.6s;
}

.intro-card:hover::before {
  transform: translateX(100%);
}

.intro-icon {
  font-size: 3rem;
  margin-bottom: 20px;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
}

.intro-card h2 {
  font-size: clamp(1.5rem, 3vw, 2rem);
  color: white;
  margin-bottom: 20px;
  font-weight: bold;
}

.intro-card p {
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.7;
  font-size: clamp(1rem, 2vw, 1.1rem);
}

/* 활동 섹션 */
.activities-section {
  margin-bottom: 60px;
}

.section-title {
  text-align: center;
  font-size: clamp(2rem, 4vw, 2.5rem);
  color: white;
  margin-bottom: 50px;
  font-weight: bold;
}

.activities-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 25px;
  margin-top: 30px;
}

.activity-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 30px 25px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.activity-card::before {
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

.activity-card:hover::before {
  transform: translateX(100%);
}

.activity-card:hover {
  transform: translateY(-5px);
  border-color: rgba(100, 200, 255, 0.3);
  box-shadow: 0 10px 25px rgba(100, 200, 255, 0.2);
}

.activity-icon {
  font-size: 2.5rem;
  margin-bottom: 15px;
  display: block;
}

.activity-title {
  font-size: 1.3rem;
  color: white;
  margin-bottom: 12px;
  font-weight: bold;
}

.activity-description {
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.6;
  margin-bottom: 15px;
  font-size: 0.95rem;
}

/* 뒤로가기 버튼 */
.back-section {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}

.back-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  text-decoration: none;
  padding: 12px 25px;
  border-radius: 25px;
  font-weight: 500;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.back-btn:hover {
  background: rgba(100, 200, 255, 0.2);
  border-color: rgba(100, 200, 255, 0.4);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(100, 200, 255, 0.3);
}

.back-icon {
  transition: transform 0.3s ease;
}

.back-btn:hover .back-icon {
  transform: translateX(-3px);
}

/* 애니메이션 */
.fade-header-enter-active {
  transition: opacity 1s ease, transform 0.8s ease;
}

.fade-header-enter-from {
  opacity: 0;
  transform: translateY(-30px);
}

.fade-intro-enter-active {
  transition: opacity 1s ease 0.3s, transform 0.8s ease 0.3s;
}

.fade-intro-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

.fade-activities-enter-active {
  transition: opacity 1.2s ease 0.6s, transform 1s ease 0.6s;
}

.fade-activities-enter-from {
  opacity: 0;
  transform: translateY(40px);
}

.fade-back-enter-active {
  transition: opacity 1s ease 1s, transform 0.8s ease 1s;
}

.fade-back-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

/* 반응형 */
@media (max-width: 768px) {
  .content-wrapper {
    padding: 0 15px;
  }

  .activities-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .activity-card {
    padding: 25px 20px;
  }

  .intro-card {
    padding: 30px 25px;
  }

  .shape-1,
  .shape-2,
  .shape-3 {
    display: none;
  }
}

@media (max-width: 480px) {
  .clug-container {
    padding: 10px 0 30px 0;
  }

  .header-section {
    padding-top: 20px;
    margin-bottom: 40px;
  }

  .intro-section {
    margin-bottom: 50px;
  }

  .activities-section {
    margin-bottom: 40px;
  }

  .activity-card {
    padding: 20px 15px;
  }

  .intro-card {
    padding: 25px 20px;
  }
}
</style>
