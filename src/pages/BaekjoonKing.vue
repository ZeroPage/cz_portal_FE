<template>
  <div class="baekjoon-king-container">
    <div class="main-header">
      <h1 class="page-title">🏆 백준킹</h1>
      <p class="page-subtitle">백준 실력을 겨뤄보세요!</p>
    </div>

    <div class="content-tabs">
      <button
        class="tab-button"
        :class="{ active: activeTab === 'profile' }"
        @click="activeTab = 'profile'"
      >
        👤 프로필 관리
      </button>
      <button
        class="tab-button"
        :class="{ active: activeTab === 'ranking' }"
        @click="activeTab = 'ranking'"
      >
        📊 현재 랭킹
      </button>
      <button
        class="tab-button"
        :class="{ active: activeTab === 'hall-of-fame' }"
        @click="activeTab = 'hall-of-fame'"
      >
        🏅 명예의 전당
      </button>
    </div>

    <!-- 프로필 관리 탭 -->
    <div v-if="activeTab === 'profile'" class="tab-content">
      <div v-if="!isLoggedIn" class="login-required">
        <div class="login-message-card">
          <div class="login-icon">🔐</div>
          <h3>로그인이 필요합니다</h3>
          <p>백준 프로필을 등록하려면 먼저 로그인해주세요.</p>
          <router-link to="/login" class="login-btn"
            >로그인하러 가기</router-link
          >
        </div>
      </div>

      <div v-else class="profile-section">
        <div class="profile-card">
          <h2>백준 프로필 등록</h2>
          <div class="input-group">
            <input
              v-model="baekjoonId"
              type="text"
              placeholder="백준 아이디를 입력하세요"
              class="baekjoon-input"
              @keyup.enter="createProfile"
            />
            <button
              @click="createProfile"
              :disabled="!baekjoonId.trim() || isLoading"
              class="register-btn"
            >
              {{ isLoading ? "등록 중..." : "프로필 등록" }}
            </button>
          </div>
          <div v-if="profileMessage" class="message" :class="messageType">
            {{ profileMessage }}
          </div>
        </div>
      </div>
    </div>

    <!-- 현재 랭킹 탭 -->
    <div v-if="activeTab === 'ranking'" class="tab-content">
      <div v-if="!isLoggedIn" class="login-required">
        <div class="login-message-card">
          <div class="login-icon">📊</div>
          <h3>로그인 후 조회하실 수 있습니다</h3>
          <p>현재 랭킹을 확인하려면 먼저 로그인해주세요.</p>
          <router-link to="/login" class="login-btn"
            >로그인하러 가기</router-link
          >
        </div>
      </div>

      <div v-else class="ranking-section">
        <div class="ranking-header">
          <h2>🔥 현재 랭킹</h2>
          <button @click="loadRanking" class="refresh-btn">새로고침</button>
        </div>

        <div v-if="loadingRanking" class="loading">랭킹을 불러오는 중...</div>

        <div v-else-if="rankingData.length > 0" class="ranking-list">
          <div
            v-for="(user, index) in sortedRanking"
            :key="user.baekjoonId"
            class="ranking-item"
            :class="{
              'rank-1': index === 0,
              'rank-2': index === 1,
              'rank-3': index === 2,
            }"
          >
            <div class="rank-number">
              <span v-if="index === 0">🥇</span>
              <span v-else-if="index === 1">🥈</span>
              <span v-else-if="index === 2">🥉</span>
              <span v-else>{{ index + 1 }}</span>
            </div>
            <div class="user-info">
              <div class="baekjoon-id">{{ user.nickName }}</div>
              <div class="user-stats">
                <span class="rating">레이팅: {{ user.rating }}</span>
                <span class="solved">해결: {{ user.solvedCount }}문제</span>
              </div>
            </div>
            <div
              class="rating-diff"
              :class="{
                positive: user.ratingDiff > 0,
                negative: user.ratingDiff < 0,
                neutral: user.ratingDiff === 0,
              }"
            >
              <span v-if="user.ratingDiff > 0">+{{ user.ratingDiff }}</span>
              <span v-else-if="user.ratingDiff < 0">{{ user.ratingDiff }}</span>
              <span v-else>0</span>
            </div>
          </div>
        </div>

        <div v-else class="empty-state">아직 등록된 사용자가 없습니다.</div>
      </div>
    </div>

    <!-- 명예의 전당 탭 -->
    <div v-if="activeTab === 'hall-of-fame'" class="tab-content">
      <div v-if="!isLoggedIn" class="login-required">
        <div class="login-message-card">
          <div class="login-icon">🏅</div>
          <h3>로그인 후 조회하실 수 있습니다</h3>
          <p>명예의 전당을 확인하려면 먼저 로그인해주세요.</p>
          <router-link to="/login" class="login-btn"
            >로그인하러 가기</router-link
          >
        </div>
      </div>

      <div v-else class="hall-of-fame-section">
        <div class="hall-header">
          <h2>🏅 명예의 전당</h2>
          <p>역대 백준킹 우승자들</p>
        </div>

        <div v-if="loadingHistory" class="loading">
          우승 기록을 불러오는 중...
        </div>

        <div v-else-if="winnerHistory.length > 0" class="winner-rounds">
          <div
            v-for="(round, roundIndex) in groupedWinners"
            :key="roundIndex"
            class="winner-round"
          >
            <h3 class="round-title">{{ roundIndex + 1 }}회차</h3>
            <div class="winners-podium">
              <div
                v-for="(winner, index) in round"
                :key="winner.baekjoonId"
                class="winner-card"
                :class="`place-${winner.rank}`"
              >
                <div class="winner-rank">
                  <span v-if="winner.rank === 1">👑</span>
                  <span v-else-if="winner.rank === 2">🥈</span>
                  <span v-else-if="winner.rank === 3">🥉</span>
                </div>
                <div class="winner-info">
                  <div class="winner-nickname">{{ winner.nickName }}</div>
                  <div class="winner-baekjoon">{{ winner.baekjoonId }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="empty-state">아직 우승 기록이 없습니다.</div>
      </div>
    </div>
  </div>
</template>

<script>
import { API_ROOT } from "@/api.js";

export default {
  name: "BaekjoonKing",
  data() {
    return {
      activeTab: "ranking",
      baekjoonId: "",
      isLoading: false,
      profileMessage: "",
      messageType: "",
      rankingData: [],
      loadingRanking: false,
      winnerHistory: [],
      loadingHistory: false,
    };
  },
  computed: {
    isLoggedIn() {
      return !!localStorage.getItem("token");
    },
    sortedRanking() {
      return [...this.rankingData].sort((a, b) => b.ratingDiff - a.ratingDiff);
    },
    groupedWinners() {
      const groups = [];
      let currentGroup = [];
      let currentRound = null;

      this.winnerHistory.forEach((winner) => {
        // 각 그룹은 rank가 1부터 시작하므로, rank가 1이면 새로운 회차
        if (winner.rank === 1 && currentGroup.length > 0) {
          groups.push([...currentGroup]);
          currentGroup = [];
        }
        currentGroup.push(winner);
      });

      if (currentGroup.length > 0) {
        groups.push(currentGroup);
      }

      return groups;
    },
  },
  mounted() {
    if (this.isLoggedIn) {
      this.loadRanking();
      this.loadWinnerHistory();
    }
  },
  methods: {
    async createProfile() {
      if (!this.baekjoonId.trim()) return;

      this.isLoading = true;
      this.profileMessage = "";

      try {
        const response = await fetch(`${API_ROOT}/baekjoon/create-profile`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
          body: JSON.stringify({
            baekjoonId: this.baekjoonId.trim(),
          }),
        });

        const result = await response.json();

        if (response.status === 200) {
          this.profileMessage = "백준 프로필이 성공적으로 등록되었습니다!";
          this.messageType = "success";
          this.baekjoonId = "";

          // 랭킹 새로고침
          await this.loadRanking();

          // 성공 메시지를 잠깐 보여준 후 랭킹 탭으로 이동
          setTimeout(() => {
            this.activeTab = "ranking";
            this.profileMessage = "";
          }, 2000);
        } else {
          this.profileMessage = result.message || "프로필 등록에 실패했습니다.";
          this.messageType = "error";
        }
      } catch (error) {
        this.profileMessage = "네트워크 오류가 발생했습니다.";
        this.messageType = "error";
      } finally {
        this.isLoading = false;
      }
    },

    async loadRanking() {
      this.loadingRanking = true;
      try {
        const response = await fetch(`${API_ROOT}/baekjoon/get-profile`, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });

        const result = await response.json();

        if (response.status === 200) {
          this.rankingData = result.data || [];
        }
      } catch (error) {
        console.error("랭킹 로드 실패:", error);
      } finally {
        this.loadingRanking = false;
      }
    },

    async loadWinnerHistory() {
      this.loadingHistory = true;
      try {
        const response = await fetch(
          `${API_ROOT}/baekjoon/get-winner-history`,
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("token")}`,
            },
          }
        );

        const result = await response.json();

        if (response.status === 200) {
          this.winnerHistory = result.data || [];
        }
      } catch (error) {
        console.error("우승 기록 로드 실패:", error);
      } finally {
        this.loadingHistory = false;
      }
    },
  },
};
</script>

<style scoped>
.baekjoon-king-container {
  min-height: 100vh;
  background: #0a0a0a;
  padding: 20px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.main-header {
  text-align: center;
  margin-bottom: 30px;
}

.page-title {
  font-size: 3rem;
  font-weight: bold;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 10px;
}

.page-subtitle {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1.2rem;
}

/* 탭 스타일 */
.content-tabs {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-bottom: 30px;
  flex-wrap: wrap;
}

.tab-button {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.7);
  padding: 12px 24px;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
}

.tab-button:hover {
  background: rgba(255, 107, 129, 0.1);
  border-color: rgba(255, 107, 129, 0.3);
  color: white;
}

.tab-button.active {
  background: linear-gradient(45deg, #ff2e63, #ff6b81);
  border-color: #ff6b81;
  color: white;
}

.tab-content {
  width: 100%;
  max-width: 900px;
}

/* 로그인 안내 스타일 */
.login-required {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 300px;
}

.login-message-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 40px;
  text-align: center;
  backdrop-filter: blur(12px);
  max-width: 400px;
  width: 100%;
}

.login-icon {
  font-size: 3rem;
  margin-bottom: 20px;
}

.login-message-card h3 {
  color: white;
  font-size: 1.5rem;
  margin-bottom: 15px;
}

.login-message-card p {
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 25px;
  line-height: 1.6;
}

.login-btn {
  display: inline-block;
  background: linear-gradient(45deg, #ff2e63, #ff6b81);
  color: white;
  padding: 12px 25px;
  border-radius: 25px;
  text-decoration: none;
  font-weight: bold;
  transition: all 0.3s;
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 107, 129, 0.3);
}

/* 프로필 관리 스타일 */
.profile-section {
  display: flex;
  justify-content: center;
}

.profile-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 30px;
  backdrop-filter: blur(12px);
  max-width: 500px;
  width: 100%;
}

.profile-card h2 {
  color: white;
  text-align: center;
  margin-bottom: 20px;
  font-size: 1.5rem;
}

.input-group {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.baekjoon-input {
  flex: 1;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 12px 15px;
  color: white;
  font-size: 1rem;
}

.baekjoon-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.baekjoon-input:focus {
  outline: none;
  border-color: #ff6b81;
}

.register-btn {
  background: linear-gradient(45deg, #ff2e63, #ff6b81);
  border: none;
  color: white;
  padding: 12px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
  transition: transform 0.2s;
}

.register-btn:hover:not(:disabled) {
  transform: translateY(-2px);
}

.register-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.message {
  padding: 10px;
  border-radius: 8px;
  text-align: center;
  font-weight: 500;
}

.message.success {
  background: rgba(76, 175, 80, 0.2);
  color: #4caf50;
  border: 1px solid rgba(76, 175, 80, 0.3);
}

.message.error {
  background: rgba(244, 67, 54, 0.2);
  color: #f44336;
  border: 1px solid rgba(244, 67, 54, 0.3);
}

/* 랭킹 스타일 */
.ranking-section {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 30px;
  backdrop-filter: blur(12px);
}

.ranking-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.ranking-header h2 {
  color: white;
  margin: 0;
}

.refresh-btn {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  padding: 8px 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.refresh-btn:hover {
  background: rgba(255, 107, 129, 0.2);
}

.ranking-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.ranking-item {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  transition: all 0.3s;
}

.ranking-item:hover {
  transform: translateY(-2px);
  border-color: rgba(255, 107, 129, 0.3);
}

.ranking-item.rank-1 {
  background: linear-gradient(
    45deg,
    rgba(255, 215, 0, 0.1),
    rgba(255, 215, 0, 0.05)
  );
  border-color: rgba(255, 215, 0, 0.3);
}

.ranking-item.rank-2 {
  background: linear-gradient(
    45deg,
    rgba(192, 192, 192, 0.1),
    rgba(192, 192, 192, 0.05)
  );
  border-color: rgba(192, 192, 192, 0.3);
}

.ranking-item.rank-3 {
  background: linear-gradient(
    45deg,
    rgba(205, 127, 50, 0.1),
    rgba(205, 127, 50, 0.05)
  );
  border-color: rgba(205, 127, 50, 0.3);
}

.rank-number {
  font-size: 1.5rem;
  font-weight: bold;
  margin-right: 20px;
  min-width: 40px;
  text-align: center;
  color: white;
}

.user-info {
  flex: 1;
}

.baekjoon-id {
  font-size: 1.2rem;
  font-weight: bold;
  color: white;
  margin-bottom: 5px;
}

.user-stats {
  display: flex;
  gap: 15px;
}

.rating,
.solved {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.rating-diff {
  font-size: 1.1rem;
  font-weight: bold;
  min-width: 60px;
  text-align: right;
}

.rating-diff.positive {
  color: #4caf50;
}

.rating-diff.negative {
  color: #f44336;
}

.rating-diff.neutral {
  color: rgba(255, 255, 255, 0.5);
}

/* 명예의 전당 스타일 */
.hall-of-fame-section {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 30px;
  backdrop-filter: blur(12px);
}

.hall-header {
  text-align: center;
  margin-bottom: 30px;
}

.hall-header h2 {
  color: white;
  margin-bottom: 10px;
}

.hall-header p {
  color: rgba(255, 255, 255, 0.7);
}

.winner-rounds {
  display: flex;
  flex-direction: column;
  gap: 30px;
}

.winner-round {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 12px;
  padding: 25px;
}

.round-title {
  color: #ff6b81;
  text-align: center;
  margin-bottom: 20px;
  font-size: 1.3rem;
}

.winners-podium {
  display: flex;
  justify-content: center;
  gap: 20px;
  flex-wrap: wrap;
}

.winner-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  text-align: center;
  min-width: 200px;
  transition: all 0.3s;
}

.winner-card:hover {
  transform: translateY(-5px);
}

.winner-card.place-1 {
  background: linear-gradient(
    45deg,
    rgba(255, 215, 0, 0.15),
    rgba(255, 215, 0, 0.05)
  );
  border-color: rgba(255, 215, 0, 0.4);
}

.winner-card.place-2 {
  background: linear-gradient(
    45deg,
    rgba(192, 192, 192, 0.15),
    rgba(192, 192, 192, 0.05)
  );
  border-color: rgba(192, 192, 192, 0.4);
}

.winner-card.place-3 {
  background: linear-gradient(
    45deg,
    rgba(205, 127, 50, 0.15),
    rgba(205, 127, 50, 0.05)
  );
  border-color: rgba(205, 127, 50, 0.4);
}

.winner-rank {
  font-size: 2rem;
  margin-bottom: 10px;
}

.winner-nickname {
  font-size: 1.2rem;
  font-weight: bold;
  color: white;
  margin-bottom: 5px;
}

.winner-baekjoon {
  color: #ff6b81;
  font-weight: 500;
  margin-bottom: 10px;
}

.winner-stats {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.winner-stats span {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.loading,
.empty-state {
  text-align: center;
  color: rgba(255, 255, 255, 0.7);
  padding: 40px;
  font-size: 1.1rem;
}

/* 반응형 */
@media (max-width: 768px) {
  .page-title {
    font-size: 2.2rem;
  }

  .content-tabs {
    flex-direction: column;
    align-items: center;
  }

  .tab-button {
    width: 200px;
  }

  .input-group {
    flex-direction: column;
  }

  .ranking-header {
    flex-direction: column;
    gap: 10px;
  }

  .user-stats {
    flex-direction: column;
    gap: 5px;
  }

  .winners-podium {
    flex-direction: column;
    align-items: center;
  }
}
</style>
