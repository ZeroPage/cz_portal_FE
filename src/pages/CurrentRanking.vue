<template>
  <div class="ranking-container">
    <div class="header">
      <transition name="fade-title">
        <h1 v-if="show" class="title">Current Ranking</h1>
      </transition>
      <transition name="fade-content">
        <h2 v-if="show" class="subtitle">This Week's Top Performers</h2>
      </transition>
    </div>

    <transition name="fade-content">
      <div v-if="show" class="ranking-list">
        <div v-for="(user, index) in users" :key="user.username" class="ranking-item">
          <div class="rank-info">
            <span class="rank">#{{ index + 1 }}</span>
            <!-- 닉네임으로 표시 -->
            <span class="username">{{ user.nickname }}</span>
            <!-- 가장 어려운 문제: score, 문제 푼 개수: solvedCountDiff -->
            <span class="score">{{ user.score }}</span>
          </div>
          <div class="progress-bar">
            <!-- 숫자형으로 변환 후 최대값과 비교하여 프로그레스바 계산 -->
            <div class="progress-fill" :style="{ width: (Number(user.score) / maxRatingDiff * 100) + '%' }"></div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';

export default {
  name: "CurrentRanking",
  setup() {
    const users = ref([]);
    const maxRatingDiff = ref(0);
    const show = ref(false);

    //어려운 문제 계산 용 2개
    const getMaxDifficultyIndex = (diffArrayStr) => {
      const levels = diffArrayStr.split(',').map(Number);
      for (let i = levels.length - 1; i >= 0; i--) {
        if (levels[i] > 0) {
          return i;
        }
      }
      return -1;
    };
    const calculateScore = (user) => {
      const hardestIdx = getMaxDifficultyIndex(user.solvedCountDiffByLevelArray);
      const score = hardestIdx + 1; // ← 점수 계산 방식은 자유롭게 조정 가능
      return {
        ...user,
        hardestIdx,
        score,
      };
    };

    onMounted(async () => {
      show.value = true;
      try {
        const response = await fetch("https://czportal.site/api/infos/all");
        const data = await response.json();
        if (data.isSuccess && data.result) {

          // 어려운 문제
          const processedUsers = data.result.map(calculateScore);
          users.value = processedUsers.sort((a, b) => b.score - a.score);
          maxRatingDiff.value = users.value.length > 0 ? users.value[0].score : 0;



          // 문제 많이 푼 거
          /*
          users.value = data.result.sort(
            (a, b) => Number(b.solvedCountDiff) - Number(a.solvedCountDiff)
          );
          maxRatingDiff.value = Number(users.value[0].solvedCountDiff);
          */

          // rating diff 용
          /*
          users.value = data.result.sort(
            (a, b) => Number(b.ratingDiff) - Number(a.ratingDiff)
          );
          maxRatingDiff.value = Number(users.value[0].ratingDiff);
          */

        }
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });

    return { show, users, maxRatingDiff };
  },
};
</script>

<style scoped>
.ranking-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  height: 100vh;
  color: white;
  text-align: center;
  position: relative;
  padding-top: 80px;
  padding-bottom: 80px;
  font-family: 'Poppins', sans-serif;
}

.header {
  position: relative;
  width: 100%;
  padding: 20px 0;
  z-index: 10;
}

.title {
  margin-top: clamp(2rem, 6vh, 4rem);
}

.subtitle {
  font-size: clamp(1rem, 3.5vw, 1.4rem);
  opacity: 0.8;
  margin-bottom: 40px;
}

.ranking-list {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
  width: 80%;
  max-height: 60vh;
  overflow-y: auto;
  padding-right: clamp(6px, 2vw, 10px);
  border-top: 2px solid rgba(255, 255, 255, 0.2);
  padding-top: 10px;
  position: relative;
}

/* 스크롤바 스타일 */
.ranking-list::-webkit-scrollbar {
  width: 8px;
}

.ranking-list::-webkit-scrollbar-track {
  background: transparent;
}

.ranking-list::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

.ranking-list::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

.ranking-item {
  width: 100%;
  background: #252525;
  padding: clamp(12px, 3vw, 20px) clamp(16px, 5vw, 24px);
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: clamp(0.9rem, 2.8vw, 1.1rem);
  color: #eee;
  font-weight: 400;
}

.rank-info {
  display: flex;
  justify-content: space-between;
  width: 100%;
  margin-bottom: 8px;
  font-size: clamp(0.85rem, 2.5vw, 1rem);
}

.rank {
  font-weight: 500;
  color: #ffcc00;
}

.username {
  flex: 1;
  text-align: center;
}

.score {
  font-weight: 500;
  color: #66bb6a;
}

.progress-bar {
  width: 100%;
  height: 12px;
  background: #444;
  border-radius: 6px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #ffcc00, #ff8c00);
  border-radius: 6px;
  transition: width 0.5s ease-in-out;
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
