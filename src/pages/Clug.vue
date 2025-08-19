<template>
  <div class="clug-container">
    <transition name="fade-content">
      <div v-if = "show" class="logo-container">
        <div class="box">
          <b>
            <img src="@/assets/clug-logo2.jpeg" alt="CLUG Logo" class="clug-logo" />
          </b>
        </div>
      </div>
    </transition>

    <transition name="fade-content">
      <div v-if = "show" class="section-group">
        <div v-for="(item, index) in sections" :key="index" class="section">
          <div class="section-title">{{ item.title }}</div>
          <p class="section-text">{{ item.content }}</p>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import {onMounted, ref} from "vue";

export default {
  name: "CLUG",
  setup() {
    const show = ref(false);
    const sections = [
      {
        title: "Introduction",
        content:
            "안녕하세요! 중앙대학교를 대표하는 오픈소스 소프트웨어 동아리 CLUG입니다!\nCLUG는 자유 소프트웨어를 탐구하는, 중앙대학교 리눅스·유닉스 사용자 모임입니다. 다양한 주제의 스터디, 세미나, 멘토링 및 해커톤을 진행합니다. ‘이모저모’와 같은 활동들로 졸업생들과의 만남을 통해 다양한 이야기를 듣고 조언을 얻습니다."
      },
      {
        title: "다양한 주제의 스터디",
        content:
            "동아리에서 제공해주는 커리큘럼을 따라 스터디원과 함께 공부하는 활동입니다. 운영체제, 네트워크, 보안, AI, 웹 개발 등 다양한 주제를 다룹니다.\n혼자 하기 어려웠던 공부를 같이 하면서 동료들과 성장해봐요!"
      },
      {
        title: "깃, 깃허브 활용 세미나",
        content:
            "본격적인 개발에 앞서 개발에 필수적인 버전 관리 도구인 Git과 GitHub를 학습하는 세미나입니다. 협업 프로젝트에서 필수적으로 사용되는 만큼, 기본 개념부터 실전 활용법까지 익힐 수 있어요!"
      },
      {
        title: "친구야 만나서 반가워~!",
        content:
            "학교 주변 핫플레이스 지도를 따라 탐방하는 새내기 교류 행사입니다. 새로운 환경에서 낯설지 않도록 도와주며, 활동을 통해 새로운 친구들을 사귈 수 있습니다!"
      },
      {
        title: "CLUG 클론 코딩",
        content:
            "실제 서비스나 웹사이트를 따라 만들며 프레임워크와 개발 기술을 익히는 활동입니다.\n부담 없이 개발을 시작할 수 있으며, 실전 경험을 쌓으며 흥미를 붙이기에 좋은 기회에요!"
      },
      {
        title: "CLUG 해커톤",
        content:
            "매칭된 팀원들과 함께 해커톤 형식으로 프로젝트를 진행합니다.\n그동안 학습한 기술을 활용해 실제 서비스를 만들어보며, 협업 능력과 문제 해결 능력을 기를 수 있어요!"
      },
      {
        title: "중앙대 컴공인의 이모저모",
        content:
            "CLUG 선배님들을 모셔서 컴퓨터공학과 학생들이 궁금해하는 진로 관련 질문을 해결하는 세미나입니다.\n업계에서 활동 중인 선배님들과 직접 소통하며 실질적인 조언을 받을 수 있어요!"
      }
    ];

    onMounted(() => {
      show.value = true; // 페이지가 로드되면 애니메이션 실행
    });

    return { show, sections };
  }
};
</script>

<style scoped>
.clug-container {
  min-height: 100vh;
  padding: clamp(80px, 10vh, 120px) clamp(20px, 5vw, 40px) clamp(40px, 8vh, 60px);
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: left;
  overflow-y: auto;
}

.section-group {
  display: flex;
  flex-direction: column;
  gap: clamp(30px, 6vh, 60px);
  width: 100%;
  max-width: 1000px;
}

.section {
  width: 100%;
  background: var(--glass-bg);
  padding: clamp(16px, 3vw, 25px);
  border: var(--border);
  box-shadow: var(--shadow);
  border-radius: 12px;
}

.section-title {
  display: inline-block;
  padding: 10px 20px;
  font-size: clamp(1.2rem, 2vw, 1.8rem);
  font-weight: bold;
  color: white;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  border: 2px solid white;
  margin-bottom: 15px;
}

.section-text {
  font-size: clamp(1rem, 1.8vw, 1.2rem);
  line-height: 1.6;
  color: white;
  white-space: pre-line;
}

.logo-container {
  margin-bottom: clamp(30px, 6vh, 60px);
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
  padding: clamp(20px, 5vw, 40px);
  gap: clamp(30px, 5vw, 50px);
}

.logo-container .box {
  position: relative;
  width: clamp(160px, 25vw, 220px);
  height: clamp(160px, 25vw, 220px);
  display: flex;
  justify-content: center;
  align-items: center;
  background: #fff;
  border-radius: 20px;
  overflow: hidden;
}

.logo-container .box::before,
.logo-container .box::after {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: 20px;
}

.logo-container .box::before {
  background: linear-gradient(45deg, #ffbc00, #ff0058);
}

.logo-container .box::after {
  background: linear-gradient(45deg, #ffbc00, #ff0058);
  filter: blur(16px);
}

.logo-container .box b {
  padding: clamp(20px, 5vw, 30px);
  position: absolute;
  display: block;
  inset: 4px;
  border-radius: 16px;
  background: rgba(0, 0, 0, 0.75);
  z-index: 2;
}

.clug-logo {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.fade-content-enter-active {
  transition: opacity 0.8s,transform 0.6s;
}
.fade-content-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

</style>
