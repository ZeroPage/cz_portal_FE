<template>
  <div class="typing-game-container">
    <div class="content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">⌨️ 타자 빨리치기</h1>
      </transition>

      <!-- 연락처 입력 단계 -->
      <transition name="fade-content">
        <div v-if="show && gameState === 'contact'" class="contact-section">
          <div class="input-card">
            <h3>🎁 상품 수령을 위한 연락처</h3>
            <p class="privacy-notice">
              타자 게임 우승자에게 상품을 전달하기 위한 연락처입니다.<br />
              <strong>행사 종료 후 모든 개인정보는 완전히 파기됩니다.</strong>
            </p>
            <input
              v-model="contact"
              type="text"
              placeholder="카카오톡 ID, 전화번호, 이메일 등"
              class="contact-input"
              @keyup.enter="goToNickname"
              maxlength="50"
            />
            <button
              @click="goToNickname"
              :disabled="!contact.trim()"
              class="next-btn"
            >
              다음 단계
            </button>
            <div class="privacy-info">
              <small>
                📋 개인정보 처리방침<br />
                • 수집목적: 게임 상품 전달<br />
                • 보관기간: 행사 종료 후 즉시 파기<br />
                • 제3자 제공: 하지 않음
              </small>
            </div>
          </div>
        </div>
      </transition>

      <!-- 닉네임 입력 단계 -->
      <transition name="fade-content">
        <div v-if="show && gameState === 'nickname'" class="nickname-section">
          <div class="input-card">
            <h3>닉네임을 입력하세요</h3>
            <input
              v-model="nickname"
              type="text"
              placeholder="닉네임을 입력하세요"
              class="nickname-input"
              @keyup.enter="startGame"
              maxlength="20"
            />
            <button
              @click="startGame"
              :disabled="!nickname.trim()"
              class="start-btn"
            >
              게임 시작
            </button>
          </div>
        </div>
      </transition>

      <!-- 게임 진행 단계 -->
      <transition name="fade-content">
        <div v-if="show && gameState === 'playing'" class="game-section">
          <div class="game-info">
            <div class="timer">시간: {{ formatTime(elapsedTime) }}</div>
            <div class="progress">
              진행률:
              {{ Math.round((currentIndex / targetText.length) * 100) }}%
            </div>
            <div class="accuracy">정확도: {{ accuracy }}%</div>
          </div>

          <div class="text-display">
            <div class="text-content">
              <span
                v-for="(char, index) in targetText"
                :key="index"
                :class="{
                  'typed-correct':
                    index < currentIndex && typedText[index] === char,
                  'typed-incorrect':
                    index < currentIndex && typedText[index] !== char,
                  current: index === currentIndex,
                  untyped: index > currentIndex,
                }"
              >
                {{ char }}
              </span>
            </div>
          </div>

          <div class="input-section">
            <textarea
              v-model="typedText"
              @input="onInput"
              class="typing-input"
              placeholder="여기에 위 텍스트를 그대로 입력하세요..."
              :disabled="!isGameStarted || gameState !== 'playing'"
            ></textarea>
          </div>
          
          <!-- 게임 컨트롤 버튼들 -->
          <div class="game-controls">
            <button 
              v-if="!isGameStarted"
              @click="startTyping"
              class="control-btn start-btn"
            >
              ⏱️ 타이핑 시작
            </button>
            
            <button 
              v-if="isGameStarted && canFinishGame"
              @click="finishGame"
              class="control-btn finish-btn"
            >
              ✅ 게임 완료
            </button>
            
            <div v-if="isGameStarted && !canFinishGame" class="finish-requirements">
              <p>게임 완료 조건:</p>
              <ul>
                <li :class="{ completed: progress === 100 }">
                  📊 진행률 100% {{ progress === 100 ? '✅' : `(현재 ${progress}%)` }}
                </li>
              </ul>
            </div>
          </div>
        </div>
      </transition>

      <!-- 결과 단계 -->
      <transition name="fade-content">
        <div v-if="show && gameState === 'finished'" class="result-section">
          <div class="result-card">
            <h3>🎉 게임 완료!</h3>
            <div class="result-stats">
              <div class="stat">
                <span class="stat-label">닉네임</span>
                <span class="stat-value">{{ nickname }}</span>
              </div>
              <div class="stat">
                <span class="stat-label">소요 시간</span>
                <span class="stat-value">{{ formatTime(finalTime) }}</span>
              </div>
              <div class="stat">
                <span class="stat-label">타자 속도</span>
                <span class="stat-value">{{ wpm }} WPM</span>
              </div>
              <div class="stat">
                <span class="stat-label">정확도</span>
                <span class="stat-value">{{ finalAccuracy }}%</span>
              </div>
            </div>
            <div class="result-actions">
              <button @click="resetGame" class="restart-btn">다시 하기</button>
              <router-link to="/event" class="back-btn">메인으로</router-link>
            </div>
          </div>
        </div>
      </transition>

      <!-- 순위 표시 -->
      <transition name="fade-content">
        <div v-if="show && rankings.length > 0" class="rankings-section">
          <h3>🏆 순위</h3>
          <div class="rankings-list">
            <div
              v-for="(rank, index) in rankings"
              :key="index"
              :class="[
                'ranking-item',
                {
                  'current-user':
                    rank.nickname === nickname && gameState === 'finished',
                },
              ]"
            >
              <span class="rank-number">{{ index + 1 }}</span>
              <span class="rank-nickname">{{ rank.nickname }}</span>
              <span class="rank-time">{{ formatTime(rank.time) }}</span>
              <span class="rank-wpm">{{ rank.wpm }} WPM</span>
            </div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed, watch } from "vue";

export default {
  name: "TypingGame",
  setup() {
    const show = ref(false);
    const gameState = ref("contact"); // 'contact', 'nickname', 'playing', 'finished'
    const contact = ref("");
    const nickname = ref("");
    const currentIndex = ref(0);
    const typedText = ref("");
    const startTime = ref(null);
    const endTime = ref(null);
    const elapsedTime = ref(0);
    const timer = ref(null);
    const rankings = ref([]);
    const isGameStarted = ref(false); // 게임 시작 여부

    // 원래 가사로 복원
    const targetText = `We're goin' up, up, up, it's our moment
You know together we're glowing
Gonna be, gonna be golden
Oh, up, up, up with our voices
영원히 깨질 수 없는
Gonna be, gonna be golden`;

    const accuracy = computed(() => {
      if (currentIndex.value === 0) return 100;
      let correct = 0;
      for (let i = 0; i < currentIndex.value; i++) {
        if (typedText.value[i] === targetText[i]) {
          correct++;
        }
      }
      return Math.round((correct / currentIndex.value) * 100);
    });

    const finalAccuracy = computed(() => {
      if (typedText.value.length === 0) return 100;
      let correct = 0;
      for (let i = 0; i < targetText.length; i++) {
        if (typedText.value[i] === targetText[i]) {
          correct++;
        }
      }
      return Math.round((correct / targetText.length) * 100);
    });

    const finalTime = computed(() => {
      if (endTime.value && startTime.value) {
        return Math.round((endTime.value - startTime.value) / 1000);
      }
      return 0;
    });

    // 진행률 계산
    const progress = computed(() => {
      return Math.round((currentIndex.value / targetText.length) * 100);
    });

    // 오타 체크
    const hasNoErrors = computed(() => {
      for (let i = 0; i < currentIndex.value; i++) {
        if (typedText.value[i] !== targetText[i]) {
          return false;
        }
      }
      return true;
    });

    // 게임 완료 가능 여부 (진행률 100%만 체크)
    const canFinishGame = computed(() => {
      return isGameStarted.value && progress.value === 100;
    });

    const wpm = computed(() => {
      if (finalTime.value === 0) return 0;
      // WPM = (타자 수 / 5) / (시간(분))
      const words = targetText.length / 5;
      const minutes = finalTime.value / 60;
      return Math.round(words / minutes);
    });

    const formatTime = (seconds) => {
      const mins = Math.floor(seconds / 60);
      const secs = seconds % 60;
      return `${mins}:${secs.toString().padStart(2, "0")}`;
    };

    const goToNickname = () => {
      if (!contact.value.trim()) return;
      gameState.value = "nickname";
    };

    const startGame = () => {
      if (!nickname.value.trim()) return;

      gameState.value = "playing";
      typedText.value = "";
      currentIndex.value = 0;
      // 아직 타이핑 시작하지 않음
      isGameStarted.value = false;
    };

    // 새로운 타이핑 시작 함수
    const startTyping = () => {
      isGameStarted.value = true;
      startTime.value = Date.now();
      elapsedTime.value = 0;

      timer.value = setInterval(() => {
        elapsedTime.value = Math.round((Date.now() - startTime.value) / 1000);
      }, 1000);
    };

    const onInput = () => {
      // 게임이 시작되지 않았으면 입력 차단
      if (!isGameStarted.value) return;
      
      // 현재 입력 위치 업데이트
      currentIndex.value = typedText.value.length;

      // 자동 완료는 제거 (수동으로만 완료 가능)
    };

    const finishGame = () => {
      if (!canFinishGame.value) return;
      
      endTime.value = Date.now();
      gameState.value = "finished";

      if (timer.value) {
        clearInterval(timer.value);
        timer.value = null;
      }

      // 결과를 로컬 스토리지에 저장
      saveResult();
    };

    const saveResult = () => {
      const result = {
        contact: contact.value,
        nickname: nickname.value,
        time: finalTime.value,
        wpm: wpm.value,
        accuracy: finalAccuracy.value,
        date: new Date().toISOString(),
      };

      const existingRankings = JSON.parse(
        localStorage.getItem("typingGameRankings") || "[]"
      );
      existingRankings.push(result);

      // 시간 순으로 정렬 (빠른 시간이 위로)
      existingRankings.sort((a, b) => a.time - b.time);

      // 상위 10개만 유지
      const topRankings = existingRankings.slice(0, 10);

      localStorage.setItem("typingGameRankings", JSON.stringify(topRankings));
      loadRankings();
    };

    const loadRankings = () => {
      const saved = localStorage.getItem("typingGameRankings");
      if (saved) {
        rankings.value = JSON.parse(saved);
      }
    };

    const resetGame = () => {
      gameState.value = "contact";
      contact.value = "";
      nickname.value = "";
      typedText.value = "";
      currentIndex.value = 0;
      startTime.value = null;
      endTime.value = null;
      elapsedTime.value = 0;

      if (timer.value) {
        clearInterval(timer.value);
        timer.value = null;
      }
    };

    onMounted(() => {
      setTimeout(() => {
        show.value = true;
      }, 100);
      loadRankings();
    });

    return {
      show,
      gameState,
      contact,
      nickname,
      targetText,
      typedText,
      currentIndex,
      elapsedTime,
      accuracy,
      finalAccuracy,
      finalTime,
      wpm,
      rankings,
      isGameStarted,
      progress,
      hasNoErrors,
      canFinishGame,
      formatTime,
      goToNickname,
      startGame,
      startTyping,
      onInput,
      finishGame,
      resetGame,
    };
  },
};
</script>

<style scoped>
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
  transform: translateY(20px);
}

.typing-game-container {
  min-height: calc(100vh - 80px);
  padding: 120px 20px 40px;
  max-width: 1200px;
  margin: 0 auto;
}

.content {
  width: 100%;
}

.title {
  background: linear-gradient(45deg, #ff6b81, #ffb562);
  font-size: clamp(2rem, 5vw, 3.5rem);
  font-weight: 800;
  margin-bottom: 2rem;
  text-align: center;
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 300%;
  animation: gradient 8s linear infinite;
}

@keyframes gradient {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.nickname-section {
  display: flex;
  justify-content: center;
  margin-bottom: 2rem;
}

.contact-section {
  display: flex;
  justify-content: center;
  margin-bottom: 2rem;
}

.input-card {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 2rem;
  backdrop-filter: blur(15px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  text-align: center;
  max-width: 400px;
  width: 100%;
}

.input-card h3 {
  color: white;
  margin-bottom: 1.5rem;
  font-size: 1.3rem;
}

.nickname-input {
  width: 100%;
  padding: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
  transition: all 0.3s ease;
}

.contact-input {
  width: 100%;
  padding: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
  transition: all 0.3s ease;
}

.nickname-input::placeholder,
.contact-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.nickname-input:focus,
.contact-input:focus {
  outline: none;
  border-color: #ff6b81;
  box-shadow: 0 0 0 3px rgba(255, 107, 129, 0.2);
}

.start-btn,
.next-btn {
  width: 100%;
  padding: 1rem 2rem;
  background: linear-gradient(45deg, #ff6b81, #ffb562);
  border: none;
  border-radius: 10px;
  color: white;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.start-btn:hover:not(:disabled),
.next-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(255, 107, 129, 0.4);
}

.start-btn:disabled,
.next-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.privacy-notice {
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.9rem;
  line-height: 1.5;
  margin-bottom: 1.5rem;
  padding: 1rem;
  background: rgba(255, 193, 7, 0.1);
  border-left: 3px solid #ffc107;
  border-radius: 5px;
}

.privacy-info {
  margin-top: 1rem;
  padding: 0.8rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.privacy-info small {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.8rem;
  line-height: 1.4;
}

.game-section {
  margin-bottom: 2rem;
}

.game-info {
  display: flex;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

.game-info > div {
  background: rgba(255, 255, 255, 0.08);
  padding: 0.8rem 1.5rem;
  border-radius: 10px;
  color: white;
  font-weight: 600;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.text-display {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 15px;
  padding: 2rem;
  margin-bottom: 2rem;
  backdrop-filter: blur(15px);
  min-height: 200px;
  display: flex;
  align-items: center;
}

.text-content {
  font-size: 1.3rem;
  line-height: 1.8;
  font-family: "Courier New", monospace;
  letter-spacing: 1px;
  white-space: pre-wrap;
  word-break: break-all;
}

.typed-correct {
  background-color: rgba(76, 175, 80, 0.3);
  color: #4caf50;
}

.typed-incorrect {
  background-color: rgba(244, 67, 54, 0.3);
  color: #f44336;
}

.current {
  background-color: rgba(255, 235, 59, 0.5);
  color: #ffc107;
  animation: blink 1s infinite;
}

@keyframes blink {
  0%,
  50% {
    opacity: 1;
  }
  51%,
  100% {
    opacity: 0.3;
  }
}

.untyped {
  color: rgba(255, 255, 255, 0.6);
}

.typing-input {
  width: 100%;
  min-height: 150px;
  padding: 1.5rem;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 15px;
  background: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 1.1rem;
  font-family: "Courier New", monospace;
  resize: vertical;
  transition: all 0.3s ease;
}

.typing-input::placeholder {
  color: rgba(255, 255, 255, 0.4);
}

.typing-input:focus {
  outline: none;
  border-color: #ff6b81;
  box-shadow: 0 0 0 3px rgba(255, 107, 129, 0.2);
}

.result-section {
  display: flex;
  justify-content: center;
  margin-bottom: 2rem;
}

.result-card {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 2rem;
  backdrop-filter: blur(15px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  text-align: center;
  max-width: 500px;
  width: 100%;
}

.result-card h3 {
  color: white;
  margin-bottom: 2rem;
  font-size: 1.5rem;
}

.result-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 2rem;
}

.stat {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.stat-label {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.stat-value {
  color: white;
  font-size: 1.2rem;
  font-weight: 600;
}

.result-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.restart-btn,
.back-btn {
  padding: 0.8rem 1.5rem;
  border-radius: 10px;
  font-weight: 600;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  font-size: 1rem;
}

.restart-btn {
  background: linear-gradient(45deg, #ff6b81, #ffb562);
  color: white;
}

.back-btn {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.restart-btn:hover,
.back-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
}

.rankings-section {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 2rem;
  backdrop-filter: blur(15px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.rankings-section h3 {
  color: white;
  text-align: center;
  margin-bottom: 1.5rem;
  font-size: 1.3rem;
}

.rankings-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.ranking-item {
  display: grid;
  grid-template-columns: 60px 1fr 100px 80px;
  gap: 1rem;
  padding: 1rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  color: white;
  align-items: center;
  transition: all 0.3s ease;
}

.ranking-item.current-user {
  background: rgba(255, 107, 129, 0.2);
  border: 1px solid rgba(255, 107, 129, 0.5);
}

.rank-number {
  font-weight: 700;
  color: #ffb562;
  text-align: center;
}

.rank-nickname {
  font-weight: 600;
}

.rank-time,
.rank-wpm {
  text-align: center;
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.8);
}

/* 게임 컨트롤 버튼 스타일 */
.game-controls {
  margin-top: 2rem;
  text-align: center;
}

.control-btn {
  padding: 1rem 2rem;
  border: none;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  margin: 0 0.5rem;
}

.start-btn {
  background: linear-gradient(45deg, #4CAF50, #45a049);
  color: white;
  box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
}

.start-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
}

.finish-btn {
  background: linear-gradient(45deg, #ff6b81, #ff5722);
  color: white;
  box-shadow: 0 4px 15px rgba(255, 107, 129, 0.3);
}

.finish-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 107, 129, 0.4);
}

.finish-requirements {
  margin-top: 1.5rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.finish-requirements p {
  color: white;
  margin-bottom: 1rem;
  font-weight: 600;
  font-size: 1rem;
}

.finish-requirements ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.finish-requirements li {
  padding: 0.5rem 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
  transition: color 0.3s ease;
}

.finish-requirements li.completed {
  color: #4CAF50;
  font-weight: 600;
}

/* 모바일 대응 */
@media (max-width: 768px) {
  .typing-game-container {
    padding: 100px 15px 30px;
  }

  .game-info {
    gap: 1rem;
  }

  .game-info > div {
    padding: 0.6rem 1rem;
    font-size: 0.9rem;
  }

  .text-content {
    font-size: 1.1rem;
  }

  .result-stats {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .result-actions {
    flex-direction: column;
  }

  .ranking-item {
    grid-template-columns: 50px 1fr 80px 70px;
    gap: 0.5rem;
    padding: 0.8rem;
  }

  .rank-nickname {
    font-size: 0.9rem;
  }

  .rank-time,
  .rank-wpm {
    font-size: 0.8rem;
  }
}
</style>
