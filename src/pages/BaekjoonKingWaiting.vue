<template>
  <div class="ranking-container">
    <transition name="fade-title">
      <h1 v-if="show" class="title">Baekjoon King</h1>
    </transition>

    <transition name="fade-content">
      <p v-if="show" class="subtitle">
        <br /><br /><br /><br />이번 주 시상 종목 : <span class="highlight">[Rating 상승 폭]</span> <br /><br />
        <span class="highlight2">...This Week's KING is...</span> <br /><br />
        다음 회차 시작일 : <span class="highlight">3/17 (월)</span>
      </p>
    </transition>

    <transition name="fade-content">
      <footer v-if="show" class="footer">
        <router-link to="/sign" class="btn">참여하기</router-link>
        <router-link to="/rank" class="btn">역대 우승자</router-link>
      </footer>
    </transition>
  </div>
</template>

<script>
import { ref, onMounted, computed } from "vue";

export default {
  name: "BaekjoonKing",
  setup() {
    const show = ref(false);
    const rankingData = ref([]);

    // API 호출 함수
    const fetchRankings = async () => {
      try {
        const response = await fetch("https://czportal.site/api/infos/all");
        const data = await response.json();
        rankingData.value = data.result;
      } catch (error) {
        console.error("Error fetching rankings:", error);
      }
    };

    onMounted(async () => {
      show.value = true;
      await fetchRankings();
    });

    // ratingDiff 기준 내림차순 정렬 (숫자로 변환)
    const sortedRankings = computed(() => {
      return rankingData.value.slice().sort((a, b) => {
        return Number(b.ratingDiff) - Number(a.ratingDiff);
      });
    });

    // podium 순서: 기존 하드 코딩 순서(왼쪽부터 3등, 2등, 1등, 4등)
    const podiumOrder = computed(() => {
      if (sortedRankings.value.length < 4) {
        return sortedRankings.value;
      }
      return [
        sortedRankings.value[2], // 3등
        sortedRankings.value[1], // 2등
        sortedRankings.value[0], // 1등
        sortedRankings.value[3]  // 4등
      ];
    });

    // podium에 사용할 클래스 배열 (순서에 맞게)
    const rankClasses = ["third", "second", "first", "fourth"];

    return {
      show,
      podiumOrder,
      rankClasses
    };
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&family=Noto+Sans+KR:wght@400;700&display=swap');

.ranking-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  color: white;
  text-align: center;
  position: relative;
  padding-bottom: 80px;
  font-family: 'Poppins', 'Noto Sans KR', sans-serif;
}

.subtitle {
  font-size: 1.2rem;
  opacity: 0.8;
  margin-bottom: 40px;
}

.highlight {
  font-weight: 700;
  font-size: 1.3rem;
  color: #ffd700;
  margin-bottom: 60px;
}

.highlight2 {
  font-weight: 900;
  font-size: 3rem;
  color: #ffcc00;
  letter-spacing: 5px;
  animation: suspense 1.5s ease-in-out infinite alternate;
}


.footer {
  position: absolute;
  bottom: 20px;
  width: 100%;
  display: flex;
  justify-content: center;
  gap: 40px;
}

.btn {
  width: 150px;
  height: 50px;
  font-size: 1.2rem;
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
</style>
