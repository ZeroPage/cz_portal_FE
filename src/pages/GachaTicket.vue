<template>
  <div class="gacha-page">
    <div class="gacha-container">
      <div class="gacha-header">
        <h1>뽑기</h1>
        <div class="ticket-info">
          <div class="ticket-status">
            <span class="ticket-count"
              >보유 티켓: {{ userInfo.ticketCount || 0 }}장</span
            >
            <div
              v-if="(userInfo.ticketCount || 0) > 0"
              class="ticket-available"
            >
              <span class="available-badge">⭐ 뽑기 이용 가능!</span>
            </div>
            <div v-else class="ticket-received">
              <span class="received-badge">✗ 티켓 부족</span>
            </div>
          </div>
        </div>
      </div>

      <div class="gacha-main">
        <!-- 뽑기 머신 -->
        <div class="gacha-machine">
          <div class="machine-body">
            <div class="machine-screen" :class="{ spinning: isSpinning }">
              <div v-if="!isSpinning && !result" class="screen-idle">
                <div class="slot-machine">
                  <div class="slot-reel">
                    <div class="slot-symbol">♦</div>
                  </div>
                  <div class="slot-reel">
                    <div class="slot-symbol">♠</div>
                  </div>
                  <div class="slot-reel">
                    <div class="slot-symbol">♣</div>
                  </div>
                </div>
              </div>
              <div v-else-if="isSpinning" class="screen-spinning">
                <div class="slot-machine">
                  <div class="slot-reel spinning-reel">
                    <div class="slot-symbols">
                      <div class="slot-symbol">♦</div>
                      <div class="slot-symbol">♠</div>
                      <div class="slot-symbol">♣</div>
                      <div class="slot-symbol">♥</div>
                      <div class="slot-symbol">★</div>
                      <div class="slot-symbol">♦</div>
                      <div class="slot-symbol">♠</div>
                      <div class="slot-symbol">♣</div>
                    </div>
                  </div>
                  <div
                    class="slot-reel spinning-reel"
                    style="animation-delay: 0.1s"
                  >
                    <div class="slot-symbols">
                      <div class="slot-symbol">♠</div>
                      <div class="slot-symbol">♣</div>
                      <div class="slot-symbol">♥</div>
                      <div class="slot-symbol">★</div>
                      <div class="slot-symbol">♦</div>
                      <div class="slot-symbol">♠</div>
                      <div class="slot-symbol">♣</div>
                      <div class="slot-symbol">♥</div>
                    </div>
                  </div>
                  <div
                    class="slot-reel spinning-reel"
                    style="animation-delay: 0.2s"
                  >
                    <div class="slot-symbols">
                      <div class="slot-symbol">♣</div>
                      <div class="slot-symbol">♥</div>
                      <div class="slot-symbol">★</div>
                      <div class="slot-symbol">♦</div>
                      <div class="slot-symbol">♠</div>
                      <div class="slot-symbol">♣</div>
                      <div class="slot-symbol">♥</div>
                      <div class="slot-symbol">★</div>
                    </div>
                  </div>
                </div>
              </div>
              <div
                v-else-if="result"
                class="screen-result"
                :class="result.success ? 'success' : 'fail'"
              >
                <div v-if="result.success" class="result-success">
                  <div class="slot-machine result-slots">
                    <div class="slot-reel">
                      <div class="slot-symbol win">★</div>
                    </div>
                    <div class="slot-reel">
                      <div class="slot-symbol win">★</div>
                    </div>
                    <div class="slot-reel">
                      <div class="slot-symbol win">★</div>
                    </div>
                  </div>
                  <div class="prize-name">{{ result.goods }}</div>
                </div>
                <div v-else class="result-fail">
                  <div class="slot-machine result-slots">
                    <div class="slot-reel">
                      <div class="slot-symbol">♦</div>
                    </div>
                    <div class="slot-reel">
                      <div class="slot-symbol">♠</div>
                    </div>
                    <div class="slot-reel">
                      <div class="slot-symbol">♣</div>
                    </div>
                  </div>
                  <div class="fail-text">아쉬워요!</div>
                </div>
              </div>
            </div>

            <button
              @click="drawTicket"
              :disabled="isSpinning || (userInfo.ticketCount || 0) <= 0"
              class="gacha-button"
              :class="{
                disabled: (userInfo.ticketCount || 0) <= 0,
                spinning: isSpinning,
              }"
            >
              {{ getButtonText() }}
            </button>
          </div>
        </div>

        <!-- 상품 확률 리스트 -->
        <div class="prize-list">
          <h3>상품 목록</h3>
          <div class="prize-items">
            <div v-for="item in prizeList" :key="item.name" class="prize-item">
              <div class="prize-info">
                <span class="prize-name">{{ item.name }}</span>
                <span class="prize-probability"
                  >{{ (parseFloat(item.probability) * 100).toFixed(1) }}%</span
                >
              </div>
              <div class="prize-count">재고: {{ item.count }}개</div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="error" class="error-message">
        {{ error }}
      </div>
    </div>

    <!-- 당첨 축하 팝업 -->
    <div v-if="showWinPopup" class="win-popup-overlay" @click="closeWinPopup">
      <div class="win-popup" @click.stop>
        <div class="confetti"></div>
        <div class="confetti"></div>
        <div class="confetti"></div>
        <div class="confetti"></div>
        <div class="confetti"></div>

        <div class="win-content">
          <div class="win-title">★ 축하합니다! ★</div>
          <div class="win-prize">
            <div class="prize-emoji">♦</div>
            <div class="prize-text">{{ winResult?.goods }}</div>
          </div>
          <div class="win-message">당첨되었습니다!</div>
          <button class="close-popup-btn" @click="closeWinPopup">확인</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { API_ROOT } from "@/api.js";

export default {
  name: "GachaTicket",
  data() {
    return {
      userInfo: {},
      prizeList: [],
      isSpinning: false,
      result: null,
      error: "",
      showWinPopup: false,
      winResult: null,
    };
  },
  mounted() {
    this.loadUserInfo();
    this.loadPrizeList();
  },
  methods: {
    async loadUserInfo() {
      try {
        const response = await fetch(`${API_ROOT}/auth/me`, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });
        const result = await response.json();
        if (response.status === 200) {
          this.userInfo = result.data;
        }
      } catch (e) {
        console.error("사용자 정보 로드 실패:", e);
      }
    },

    async loadPrizeList() {
      try {
        const response = await fetch(`${API_ROOT}/ticket/goods-info`, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });
        const result = await response.json();
        if (response.status === 200) {
          this.prizeList = result.data;
        }
      } catch (e) {
        console.error("상품 목록 로드 실패:", e);
      }
    },

    async drawTicket() {
      if (!localStorage.getItem("token")) {
        this.error = "로그인이 필요합니다";
        return;
      }

      if (this.userInfo.ticketCount <= 0) {
        this.error = "티켓이 부족합니다";
        return;
      }

      this.error = "";
      this.result = null;
      this.isSpinning = true;

      try {
        // 스피닝 애니메이션 시간
        await new Promise((resolve) => setTimeout(resolve, 2000));

        const response = await fetch(`${API_ROOT}/ticket/ticket-draw`, {
          method: "GET",
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });

        const result = await response.json();

        if (response.status === 200) {
          this.result = {
            success: result.data.isSuccess,
            goods: result.data.goods,
          };
          // 당첨된 경우 팝업 표시
          if (result.data.isSuccess) {
            this.winResult = result.data;
            setTimeout(() => {
              this.showWinPopup = true;
            }, 500); // 결과 화면이 잠깐 보인 후 팝업
          }
          // 티켓 개수 업데이트
          this.userInfo.ticketCount -= 1;
        } else if (result.code === "TICKET4002") {
          this.result = {
            success: false,
            message: "꽝",
          };
          // 티켓 개수 업데이트
          this.userInfo.ticketCount -= 1;
        } else {
          this.error = result.message || "뽑기에 실패했습니다";
        }
      } catch (e) {
        this.error = "네트워크 오류가 발생했습니다";
      } finally {
        this.isSpinning = false;
      }
    },

    getButtonText() {
      if (this.isSpinning) return "뽑는 중...";
      if ((this.userInfo.ticketCount || 0) <= 0) return "티켓 부족";
      return "뽑기 (1티켓)";
    },

    closeWinPopup() {
      this.showWinPopup = false;
      this.winResult = null;
    },
  },
};
</script>

<style scoped>
.gacha-page {
  min-height: 100vh;
  background: #0a0a0a;
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.gacha-container {
  max-width: 1000px;
  width: 100%;
}

.gacha-header {
  text-align: center;
  margin-bottom: 30px;
}

.gacha-header h1 {
  font-size: 3rem;
  margin: 0 0 15px 0;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562, #e0a04a);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: gradient 8s linear infinite;
  background-size: 300%;
}

.ticket-info {
  background: rgba(255, 255, 255, 0.08);
  padding: 15px 25px;
  border-radius: 25px;
  display: inline-block;
  backdrop-filter: blur(15px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
}

.ticket-status {
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: center;
}

.ticket-count {
  color: #ff6b81;
  font-weight: 600;
  font-size: 1.2rem;
}

.ticket-available .available-badge {
  background: linear-gradient(45deg, #00c851, #00ff41);
  color: #000;
  padding: 6px 15px;
  border-radius: 18px;
  font-size: 0.95rem;
  font-weight: 700;
  animation: pulse 2s infinite;
  box-shadow: 0 2px 10px rgba(0, 200, 81, 0.4);
}

.ticket-received .received-badge {
  background: rgba(158, 158, 158, 0.2);
  color: #9e9e9e;
  padding: 6px 15px;
  border-radius: 18px;
  font-size: 0.95rem;
  font-weight: 600;
  border: 1px solid rgba(158, 158, 158, 0.3);
}

.gacha-main {
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 30px;
  align-items: start;
}

.gacha-machine {
  display: flex;
  justify-content: center;
}

.machine-body {
  background: rgba(255, 255, 255, 0.08);
  border: 2px solid rgba(255, 255, 255, 0.15);
  border-radius: 25px;
  padding: 45px;
  backdrop-filter: blur(15px);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
  transition: transform 0.3s ease;
}

.machine-body:hover {
  transform: translateY(-5px);
}

.machine-screen {
  width: 300px;
  height: 300px;
  background: #000;
  border-radius: 15px;
  border: 3px solid #333;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 30px;
  position: relative;
  overflow: hidden;
}

.machine-screen.spinning {
  animation: screenGlow 0.5s infinite alternate;
}

@keyframes screenGlow {
  0% {
    box-shadow: 0 0 10px #ff6b81;
  }
  100% {
    box-shadow: 0 0 30px #ff2e63;
  }
}

/* 슬롯 머신 스타일 */
.slot-machine {
  display: flex;
  gap: 20px;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.slot-reel {
  width: 70px;
  height: 100px;
  background: #111;
  border: 2px solid #444;
  border-radius: 8px;
  overflow: hidden;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.slot-symbol {
  font-size: 3rem;
  color: #ff6b81;
  font-weight: bold;
  text-align: center;
  line-height: 1;
}

.slot-symbol.win {
  color: #ffd700;
  animation: winGlow 1s infinite alternate;
}

@keyframes winGlow {
  0% {
    text-shadow: 0 0 10px #ffd700;
  }
  100% {
    text-shadow: 0 0 20px #ffd700, 0 0 30px #ffd700;
  }
}

.spinning-reel {
  overflow: hidden;
}

.spinning-reel .slot-symbols {
  display: flex;
  flex-direction: column;
  animation: slotSpin 0.1s linear infinite;
}

.spinning-reel .slot-symbol {
  min-height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
}

@keyframes slotSpin {
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(-100px);
  }
}

.result-slots .slot-symbol {
  animation: resultBounce 0.6s ease-out;
}

@keyframes resultBounce {
  0% {
    transform: scale(0.5);
    opacity: 0;
  }
  50% {
    transform: scale(1.2);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

/* 화면 결과 스타일 */
.screen-result {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20px;
}

.result-success {
  text-align: center;
  color: #4caf50;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
}

.result-success .prize-name {
  font-size: 1.5rem;
  font-weight: bold;
  color: #ffd700;
}

.result-fail {
  text-align: center;
  color: #666;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
}

.result-fail .fail-text {
  font-size: 1.5rem;
  font-weight: bold;
  color: #ff6b81;
}

@keyframes pulse {
  0%,
  100% {
    opacity: 0.5;
  }
  50% {
    opacity: 1;
  }
}

.screen-result {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  animation: resultPop 0.5s ease-out;
}

@keyframes resultPop {
  0% {
    transform: scale(0);
    opacity: 0;
  }
  50% {
    transform: scale(1.2);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.gacha-button {
  width: 100%;
  padding: 18px;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562, #e0a04a);
  background-size: 300%;
  color: white;
  border: none;
  border-radius: 15px;
  font-size: 1.3rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
  animation: gradient 8s linear infinite;
  text-transform: uppercase;
  letter-spacing: 1px;
  box-shadow: 0 4px 15px rgba(255, 107, 129, 0.3);
}

.gacha-button:hover:not(:disabled) {
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(255, 107, 129, 0.5);
}

.gacha-button.disabled {
  background: rgba(120, 120, 120, 0.3);
  cursor: not-allowed;
  animation: none;
  box-shadow: none;
  color: rgba(255, 255, 255, 0.5);
}

.gacha-button.spinning {
  background: rgba(255, 107, 129, 0.5);
  animation: none;
}

.prize-list {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 25px;
  backdrop-filter: blur(15px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.prize-list h3 {
  color: white;
  margin: 0 0 20px 0;
  text-align: center;
  font-size: 1.4rem;
  font-weight: 600;
  background: linear-gradient(45deg, #ff6b81, #ffb562);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.prize-items {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.prize-item {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 12px;
  padding: 15px;
  transition: all 0.3s ease;
}

.prize-item:hover {
  transform: translateX(8px);
  border-color: rgba(255, 107, 129, 0.4);
  background: rgba(255, 255, 255, 0.12);
  box-shadow: 0 4px 15px rgba(255, 107, 129, 0.2);
}

.prize-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
}

.prize-name {
  color: white;
  font-weight: 500;
}

.prize-probability {
  color: #ff6b81;
  font-weight: 600;
}

.prize-count {
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.9rem;
}

.error-message {
  background: rgba(255, 46, 99, 0.2);
  color: #ff6b81;
  padding: 12px;
  border-radius: 8px;
  margin-top: 20px;
  text-align: center;
  border: 1px solid rgba(255, 107, 129, 0.3);
  backdrop-filter: blur(12px);
}

@keyframes gradient {
  0% {
    background-position: 0 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0 50%;
  }
}

/* 당첨 팝업 스타일 */
.win-popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(5px);
  animation: fadeIn 0.3s ease-out;
}

.win-popup {
  position: relative;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562);
  background-size: 400% 400%;
  border-radius: 20px;
  padding: 40px;
  text-align: center;
  max-width: 400px;
  width: 90%;
  box-shadow: 0 20px 40px rgba(255, 46, 99, 0.3);
  animation: popupSlideIn 0.5s ease-out, gradient 3s ease infinite;
  overflow: hidden;
}

.confetti {
  position: absolute;
  width: 10px;
  height: 10px;
  background: #ffdd59;
  animation: confettiFall 3s linear infinite;
}

.confetti:nth-child(1) {
  left: 10%;
  animation-delay: 0s;
  background: #ff6b81;
}

.confetti:nth-child(2) {
  left: 30%;
  animation-delay: 0.5s;
  background: #4ecdc4;
}

.confetti:nth-child(3) {
  left: 50%;
  animation-delay: 1s;
  background: #45b7d1;
}

.confetti:nth-child(4) {
  left: 70%;
  animation-delay: 1.5s;
  background: #96ceb4;
}

.confetti:nth-child(5) {
  left: 90%;
  animation-delay: 2s;
  background: #feca57;
}

.win-content {
  position: relative;
  z-index: 10;
}

.win-title {
  font-size: 2.5rem;
  font-weight: bold;
  color: white;
  margin-bottom: 20px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
  animation: bounce 1s ease-in-out infinite alternate;
}

.win-prize {
  margin: 20px 0;
}

.prize-emoji {
  font-size: 4rem;
  margin-bottom: 10px;
  animation: prize-rotate 2s ease-in-out infinite;
}

.prize-text {
  font-size: 1.8rem;
  font-weight: bold;
  color: white;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
  margin-bottom: 10px;
}

.win-message {
  font-size: 1.3rem;
  color: white;
  margin-bottom: 30px;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.close-popup-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 2px solid white;
  color: white;
  padding: 12px 30px;
  border-radius: 25px;
  font-size: 1.1rem;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
}

.close-popup-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes popupSlideIn {
  from {
    transform: scale(0.7) translateY(-50px);
    opacity: 0;
  }
  to {
    transform: scale(1) translateY(0);
    opacity: 1;
  }
}

@keyframes confettiFall {
  0% {
    transform: translateY(-100vh) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: translateY(100vh) rotate(720deg);
    opacity: 0;
  }
}

@keyframes bounce {
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(-10px);
  }
}

@keyframes prize-rotate {
  0%,
  100% {
    transform: rotate(0deg) scale(1);
  }
  25% {
    transform: rotate(-10deg) scale(1.1);
  }
  75% {
    transform: rotate(10deg) scale(1.1);
  }
}

@media (max-width: 768px) {
  .gacha-main {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .machine-screen {
    width: 250px;
    height: 250px;
  }

  .machine-body {
    padding: 20px;
  }

  .gacha-header h1 {
    font-size: 2rem;
  }
}
</style>
