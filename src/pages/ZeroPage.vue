<template>
  <div class="zp-container">
    <transition name="fade-content">
      <div v-if="show" class="logo-container">
        <div class="box">
          <b>
            <img src="@/assets/zp-logo.png" alt="ZP Logo" class="zp-logo">
          </b>
        </div>
      </div>
    </transition>
    <transition name="fade-content">
      <div v-if ="show" class="section-group">
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
  name: "ZeroPage",
  setup() {
    const show = ref(false);
    const sections = [
      {
        title: "Introduction",
        content:
            "제로페이지는 공부하고자하는 뜻이 있는 사람들이 모인 일종의 인력의 장입니다.\n 그 안에서 뜻이 같은 사람들을 만날수 있기를, 또는 자신이 아는 것에 대해 다른 사람들에게 전달해줄수 있기를, 또는 자신의 부족한 점을 다른 사람들로부터 얻어갈 수 있었으면 합니다.\n 개인의 이익들이 모여서 집단의 이익을 만들어가며, 집단의 이익을 추구하는 것이 곧 개개인들에게 이익이 되는 경지가 되었으면 합니다."
      },
      {
        title: "Event - OMS",
        content: "OMS(Open Micro Seminar)는 매주 정기 모임에서 진행되는 짧은 세미나로, 자유로운 주제로 발표합니다. 이를 통해 회원들은 정보 공유, 프레젠테이션 경험 축적, 그리고 상호 이해 증진을 목표로 합니다."
      },
      {
        title: "Event - 새싹교실, CodeRace",
        content: "선후배간의 친목을 도모하는 수업형 행사입니다.\n 관심 분야별 클래스를 진행하여 처음 프로그래밍을 접하는 새내기들뿐만 아니라 새싹 교실의 선생들도 배움을 얻어가는 자리입니다."
      },
      {
        title: "Event - EngelsCamp",
        content: "평소에 아디이어가 떠올랐으나 시도하지 못 했던 것들을 시도하는 무박 2일 해커톤입니다. 실력은 무관합니다. 경험을 얻어가는 것이 중요합니다."
      },
      {
        title: "Event - DevilsCamp",
        content: "전공과 관련 있는 다양한 주제로 지식과 경험을 공유하는 시간입니다. ZeroPage의 재학생들과 졸업하신 선배님들께서 2~3시간씩 각기 다른 주제로 세미나를 진행하는 방식으로, 학과 커리큘럼 외의 다양한 분야를 접해보고 직접 실습도 해볼 수 있는 흔치 않은 기회입니다."
      },
      {
        title: "Event - 지금그때",
        content: "전통을 자랑하는 선후배 이야기 자리인 지금과 그때(지금그때) 입니다. 여러분의 지금이 우리의 그때보다 낫길 바라며 선후배들이 모여 이야기를 나누고 서로의 시선에서 경험을 나눕니다. 제로페이지 역대 선배들과 이야기를 나눌 수 있는 흔치 않은 기회입니다."
      },
      {
        title: "Event - 기년회",
        content: "연말, 한 해를 되돌아보며 앞으로의 내일을 계획하는 행사입니다."
      },
      {
        title: "Event - MT",
        content: "말 그대로 MT 입니다!"
      },
      {
        title: "Event - 나들이",
        content: "동아리 회원들과 함께 어울리며 자연 속에서 휴식과 즐거움을 즐기는 특별한 야외 활동입니다. 맛있는 것들을 먹으며 친목을 다질 수 있는 기회입니다."
      },
      {
        title: "More Info",
        content: "- 게시판\t: zeropage.org \n - 포탈\t: portal.zeropage.org \n - 위키\t:  wiki.zeropage.org"
      },
      {
        title: "THANKS TO ZP지기",
        content: "감사하게도 ZeroPage 졸업 선배님들이 '지피지기'라는 이름으로 필요할 때마다 자금을 지원해주신 덕에 유익한 행사들을 많이 진행히였고, 앞으로도 유익한 행사를 개최할 것을 약속합니다."
      }
    ];

    onMounted(() => {
      show.value = true; // 페이지가 로드되면 애니메이션 실행
    });

    return { show,sections };
  }
};
</script>

<style scoped>
.zp-container {
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

.zp-logo {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.fade-content-enter-active {
  transition: opacity 0.8s , transform 0.6s;
}
.fade-content-enter-from {
  opacity: 0;
  transform: translateY(10px);
}
</style>
