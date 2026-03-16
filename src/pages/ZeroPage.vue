<template>
  <div class="zp-container">
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
              <img src="@/assets/zp-logo.png" alt="ZP Logo" class="zp-logo" />
            </div>
          </div>
          <h1 class="page-title">ZeroPage</h1>
          <p class="page-subtitle">Web Development & Project Community</p>
          <div class="title-underline"></div>
        </div>
      </transition>

      <!-- 소개 섹션 -->
      <transition name="fade-intro">
        <div v-if="show" class="intro-section">
          <div class="intro-card">
            <h2>함께 배우고 성장하는 공간</h2>
            <p>
              공부하고자 하는 뜻이 있는 사람들이 모인 인력의 장입니다.<br />
              뜻이 같은 사람들을 만나고, 지식을 나누며,<br />
              서로의 부족한 점을 채워가는 개발 동아리입니다.
            </p>
          </div>
        </div>
      </transition>

      <!-- 이벤트 섹션 -->
      <transition name="fade-events">
        <div v-if="show" class="events-section">
          <h2 class="section-title">주요 이벤트</h2>
          <div class="events-grid">
            <div
              v-for="(event, index) in events"
              :key="index"
              class="event-card"
              :class="`event-${index + 1}`"
            >
              <h3 class="event-title">{{ event.title }}</h3>
              <p class="event-description">{{ event.content }}</p>
            </div>
          </div>
        </div>
      </transition>

      <!-- 추가 정보 섹션 -->
      <transition name="fade-info">
        <div v-if="show" class="info-section">
          <div class="info-card">
            <h3>더 많은 정보</h3>
            <div class="info-links">
              <div class="info-item">
                <span class="info-label">게시판</span>
                <span class="info-value">zeropage.org</span>
              </div>
              <div class="info-item">
                <span class="info-label">포탈</span>
                <span class="info-value">portal.zeropage.org</span>
              </div>
              <div class="info-item">
                <span class="info-label">위키</span>
                <span class="info-value">wiki.zeropage.org</span>
              </div>
            </div>
          </div>

          <div class="thanks-card">
            <h3>감사 인사</h3>
            <p>
              ZeroPage 졸업 선배님들이 '지피지기'라는 이름으로<br />
              지속적인 자금 지원을 해주셔서 유익한 행사들을<br />
              진행할 수 있었습니다. 진심으로 감사드립니다!
            </p>
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
  name: "ZeroPage",
  setup() {
    const show = ref(false);
    const events = [
      {
        icon: "🎤",
        title: "OMS (Open Micro Seminar)",
        content:
          "매주 정기 모임에서 진행되는 짧은 세미나로, 자유로운 주제로 발표하며 정보를 공유합니다.",
        tag: "정기",
      },
      {
        icon: "🌱",
        title: "새싹교실 & CodeRace",
        content:
          "선후배간의 친목을 도모하는 수업형 행사로, 관심 분야별 클래스를 진행합니다.",
        tag: "교육",
      },
      {
        icon: "⚡",
        title: "EngelsCamp",
        content:
          "평소 시도하지 못했던 아이디어를 실현하는 무박 2일 해커톤입니다.",
        tag: "해커톤",
      },
      {
        icon: "😈",
        title: "DevilsCamp",
        content: "다양한 주제로 지식과 경험을 공유하는 심화 세미나 시간입니다.",
        tag: "세미나",
      },
      {
        icon: "⏰",
        title: "지금그때",
        content:
          "선후배들이 모여 경험을 나누고 서로의 시선에서 이야기를 공유하는 자리입니다.",
        tag: "교류",
      },
      {
        icon: "🎊",
        title: "기년회",
        content: "연말에 한 해를 되돌아보며 앞으로의 계획을 세우는 행사입니다.",
        tag: "연례",
      },
      {
        icon: "🏔️",
        title: "MT & 나들이",
        content:
          "동아리 회원들과 함께 자연 속에서 휴식과 즐거움을 만끽하는 야외 활동입니다.",
        tag: "친목",
      },
    ];

    onMounted(() => {
      show.value = true;
    });

    return { show, events };
  },
};
</script>

<style scoped>
.zp-container {
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
    rgba(255, 181, 98, 0.1),
    rgba(255, 154, 86, 0.1)
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
  background: linear-gradient(45deg, #ffb562, #ff9a56);
  padding: 4px;
  box-shadow: 0 10px 30px rgba(255, 181, 98, 0.3);
}

.zp-logo {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 16px;
}

.page-title {
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: bold;
  background: linear-gradient(45deg, #ffb562, #ff9a56);
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
  background: linear-gradient(45deg, #ffb562, #ff9a56);
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
  border: 1px solid rgba(255, 181, 98, 0.2);
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
    rgba(255, 181, 98, 0.02),
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

/* 이벤트 섹션 */
.events-section {
  margin-bottom: 60px;
}

.section-title {
  text-align: center;
  font-size: clamp(2rem, 4vw, 2.5rem);
  color: white;
  margin-bottom: 50px;
  font-weight: bold;
}

.events-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 25px;
  margin-top: 30px;
}

.event-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 30px 25px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.event-card::before {
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

.event-card:hover::before {
  transform: translateX(100%);
}

.event-card:hover {
  transform: translateY(-5px);
  border-color: rgba(255, 181, 98, 0.3);
  box-shadow: 0 10px 25px rgba(255, 181, 98, 0.2);
}

.event-icon {
  font-size: 2.5rem;
  margin-bottom: 15px;
  display: block;
}

.event-title {
  font-size: 1.3rem;
  color: white;
  margin-bottom: 12px;
  font-weight: bold;
}

.event-description {
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.6;
  margin-bottom: 15px;
  font-size: 0.95rem;
}

.event-tag {
  display: inline-block;
  background: linear-gradient(45deg, #ffb562, #ff9a56);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 500;
}

/* 정보 섹션 */
.info-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
  margin-bottom: 60px;
}

.info-card,
.thanks-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 181, 98, 0.2);
  border-radius: 15px;
  padding: 30px 25px;
  backdrop-filter: blur(12px);
}

.info-card h3,
.thanks-card h3 {
  color: white;
  font-size: 1.4rem;
  margin-bottom: 20px;
  font-weight: bold;
}

.info-links {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 15px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.info-label {
  color: rgba(255, 255, 255, 0.8);
  font-weight: 500;
}

.info-value {
  color: #ffb562;
  font-weight: 600;
  font-family: monospace;
}

.thanks-card p {
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.6;
  font-size: 1rem;
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
  background: rgba(255, 181, 98, 0.2);
  border-color: rgba(255, 181, 98, 0.4);
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 181, 98, 0.3);
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

.fade-events-enter-active {
  transition: opacity 1.2s ease 0.6s, transform 1s ease 0.6s;
}

.fade-events-enter-from {
  opacity: 0;
  transform: translateY(40px);
}

.fade-info-enter-active {
  transition: opacity 1s ease 0.9s, transform 0.8s ease 0.9s;
}

.fade-info-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

.fade-back-enter-active {
  transition: opacity 1s ease 1.2s, transform 0.8s ease 1.2s;
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

  .events-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .event-card {
    padding: 25px 20px;
  }

  .intro-card {
    padding: 30px 25px;
  }

  .info-section {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .info-card,
  .thanks-card {
    padding: 25px 20px;
  }

  .shape-1,
  .shape-2,
  .shape-3 {
    display: none;
  }
}

@media (max-width: 480px) {
  .zp-container {
    padding: 10px 0 30px 0;
  }

  .header-section {
    padding-top: 20px;
    margin-bottom: 40px;
  }

  .intro-section {
    margin-bottom: 50px;
  }

  .events-section {
    margin-bottom: 40px;
  }

  .event-card {
    padding: 20px 15px;
  }

  .intro-card {
    padding: 25px 20px;
  }

  .info-card,
  .thanks-card {
    padding: 20px 15px;
  }

  .info-item {
    flex-direction: column;
    text-align: center;
    gap: 8px;
  }
}
</style>
