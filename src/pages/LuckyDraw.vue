<template>
  <div class="lucky-draw-container">
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
          <h1 class="page-title">🎰 럭키 드로우</h1>
          <p class="page-subtitle">행운의 주인공은 누구?</p>
          <div class="title-underline"></div>
        </div>
      </transition>

      <!-- 메인 콘텐츠 -->
      <transition name="fade-content">
        <div v-if="show" class="main-content">
          <!-- 입력 섹션 -->
          <div class="input-section">
            <div class="input-group">
              <label for="max-number">최대 숫자 입력:</label>
              <input
                id="max-number"
                v-model.number="maxNumber"
                type="number"
                min="1"
                placeholder="예: 100"
                class="number-input"
                @keyup.enter="draw"
              />
            </div>

            <button
              @click="draw"
              :disabled="maxNumber < 1 || isDrawing"
              class="draw-button"
              :class="{ drawing: isDrawing }"
            >
              <span v-if="!isDrawing">🎲 드로우!</span>
              <span v-else>뽑는 중...</span>
            </button>
          </div>

          <!-- 결과 섹션 -->
          <transition name="result-pop">
            <div v-if="result !== null" class="result-section">
              <div class="result-card">
                <h2 class="result-label">당첨된 번호</h2>
                <div class="result-number">{{ result }}</div>
                <div class="result-range">1 ~ {{ maxNumber }} 중 선택됨</div>
              </div>
            </div>
          </transition>

          <!-- 범위 표시 섹션 -->
          <div v-if="maxNumber > 0" class="range-section">
            <div class="range-info">
              <p>
                현재 범위: <strong>1 ~ {{ maxNumber }}</strong>
              </p>
            </div>
          </div>

          <!-- 히스토리 섹션 -->
          <transition name="fade-history">
            <div v-if="history.length > 0" class="history-section">
              <h3 class="history-title">최근 드로우 기록</h3>
              <div class="history-list">
                <div
                  v-for="(item, index) in history"
                  :key="index"
                  class="history-item"
                >
                  <span class="history-rank"
                    >#{{ history.length - index }}</span
                  >
                  <span class="history-number">{{ item.result }}</span>
                  <span class="history-range">(1~{{ item.max }})</span>
                  <span class="history-time">{{ formatTime(item.time) }}</span>
                </div>
              </div>

              <button @click="clearHistory" class="clear-button">
                기록 삭제
              </button>
            </div>
          </transition>
        </div>
      </transition>

      <!-- 뒤로가기 버튼 -->
      <transition name="fade-back">
        <div v-if="show" class="back-section">
          <router-link to="/" class="back-btn">
            <span>← 홈으로</span>
          </router-link>
        </div>
      </transition>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";

const show = ref(false);
const maxNumber = ref(100);
const result = ref(null);
const isDrawing = ref(false);
const history = ref([]);

// 애니메이션 효과를 위한 드로우 함수
const draw = async () => {
  if (maxNumber.value < 1 || isDrawing.value) return;

  isDrawing.value = true;
  result.value = null;

  // 총 애니메이션 시간: 3초
  const totalDuration = 3000;
  const startTime = Date.now();

  // 속도 곡선: 처음엔 빠르고, 점점 느려짐
  const easeOutQuad = (t) => 1 - (1 - t) * (1 - t);

  // 프레임 업데이트
  const updateFrame = () => {
    const elapsed = Date.now() - startTime;
    const progress = Math.min(elapsed / totalDuration, 1);

    if (progress < 1) {
      // 진행도에 따라 프레임 업데이트 속도 감소
      const easeProgress = easeOutQuad(progress);
      result.value = Math.floor(Math.random() * maxNumber.value) + 1;
      requestAnimationFrame(updateFrame);
    } else {
      // 최종 결과
      const finalResult = Math.floor(Math.random() * maxNumber.value) + 1;
      result.value = finalResult;

      // 히스토리에 추가 (최대 10개까지만)
      history.value.unshift({
        result: finalResult,
        max: maxNumber.value,
        time: new Date(),
      });

      if (history.value.length > 10) {
        history.value.pop();
      }

      isDrawing.value = false;
    }
  };

  requestAnimationFrame(updateFrame);
};

// 시간 포맷
const formatTime = (date) => {
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  return `${hours}:${minutes}:${seconds}`;
};

// 기록 삭제
const clearHistory = () => {
  if (confirm("드로우 기록을 모두 삭제하시겠어요?")) {
    history.value = [];
  }
};

// 초기화 시 로컬스토리지에서 히스토리 로드
onMounted(() => {
  show.value = true;
  const savedHistory = localStorage.getItem("luckyDrawHistory");
  if (savedHistory) {
    try {
      history.value = JSON.parse(savedHistory).map((item) => ({
        ...item,
        time: new Date(item.time),
      }));
    } catch (e) {
      console.log("히스토리 로드 실패");
    }
  }
});

// 히스토리 변경 시 로컬스토리지에 저장
watch(
  history,
  (newHistory) => {
    localStorage.setItem("luckyDrawHistory", JSON.stringify(newHistory));
  },
  { deep: true }
);
</script>

<style scoped>
.lucky-draw-container {
  min-height: 100vh;
  background: #0a0a0a;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  position: relative;
  overflow-x: hidden;
  padding: 20px 0 40px 0;
  margin-top: 60px;
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
  background: rgba(100, 200, 255, 0.1);
  animation: float 6s ease-in-out infinite;
}

.shape-1 {
  width: 300px;
  height: 300px;
  top: 10%;
  left: 5%;
  animation-delay: 0s;
}

.shape-2 {
  width: 200px;
  height: 200px;
  top: 50%;
  right: 10%;
  animation-delay: 2s;
}

.shape-3 {
  width: 150px;
  height: 150px;
  bottom: 10%;
  left: 20%;
  animation-delay: 4s;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-30px) rotate(180deg);
  }
}

/* 콘텐츠 래퍼 */
.content-wrapper {
  position: relative;
  z-index: 2;
  max-width: 900px;
  width: 100%;
  padding: 0 20px;
}

/* 헤더 섹션 */
.header-section {
  text-align: center;
  margin-bottom: 40px;
  color: white;
}

.page-title {
  font-size: 3.5rem;
  font-weight: 700;
  margin: 0 0 10px 0;
  text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  letter-spacing: 2px;
}

.page-subtitle {
  font-size: 1.3rem;
  margin: 10px 0;
  opacity: 0.95;
  font-weight: 300;
}

.title-underline {
  width: 100px;
  height: 4px;
  background: white;
  margin: 20px auto 0;
  border-radius: 2px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

/* 메인 콘텐츠 */
.main-content {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(100, 200, 255, 0.2);
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  margin-bottom: 40px;
}

/* 입력 섹션 */
.input-section {
  display: flex;
  gap: 15px;
  margin-bottom: 40px;
  justify-content: center;
  flex-wrap: wrap;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: center;
}

.input-group label {
  color: white;
  font-weight: 600;
  font-size: 1.1rem;
}

.number-input {
  width: 150px;
  padding: 12px 15px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border-radius: 10px;
  font-size: 1.1rem;
  font-weight: 600;
  text-align: center;
  transition: all 0.3s ease;
}

.number-input:focus {
  outline: none;
  border-color: white;
  background: rgba(255, 255, 255, 0.2);
  box-shadow: 0 0 15px rgba(255, 255, 255, 0.3);
}

.number-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

/* 드로우 버튼 */
.draw-button {
  padding: 15px 50px;
  background: linear-gradient(45deg, #64c8ff, #4facfe);
  color: white;
  border: 2px solid white;
  border-radius: 50px;
  font-size: 1.2rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
  text-transform: uppercase;
  letter-spacing: 1px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.draw-button:hover:not(:disabled) {
  transform: scale(1.05);
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.3);
}

.draw-button:active:not(:disabled) {
  transform: scale(0.98);
}

.draw-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.draw-button.drawing {
  animation: pulse 0.6s ease-in-out infinite;
}

@keyframes pulse {
  0%,
  100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

/* 결과 섹션 */
.result-section {
  margin: 40px 0;
  display: flex;
  justify-content: center;
}

.result-card {
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.2) 0%,
    rgba(255, 255, 255, 0.1) 100%
  );
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-radius: 20px;
  padding: 40px;
  text-align: center;
  min-width: 300px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.result-label {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1.2rem;
  margin: 0 0 20px 0;
  font-weight: 600;
}

.result-number {
  font-size: 5rem;
  font-weight: 900;
  color: white;
  text-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
  margin: 20px 0;
  animation: resultBounce 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes resultBounce {
  0% {
    transform: scale(0.5) rotateX(90deg);
    opacity: 0;
  }
  50% {
    transform: scale(1.2) rotateX(0deg);
  }
  75% {
    transform: scale(0.95);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.result-range {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1rem;
  font-weight: 500;
}

/* 범위 섹션 */
.range-section {
  text-align: center;
  color: white;
  margin: 30px 0;
}

.range-info p {
  font-size: 1.1rem;
  margin: 10px 0;
}

.range-info strong {
  color: #ffd700;
  font-weight: 700;
}

.probability {
  font-size: 1rem;
  opacity: 0.9;
}

/* 히스토리 섹션 */
.history-section {
  margin-top: 40px;
  padding-top: 30px;
  border-top: 2px solid rgba(255, 255, 255, 0.2);
}

.history-title {
  color: white;
  font-size: 1.4rem;
  margin-bottom: 20px;
  font-weight: 700;
}

.history-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 20px;
  max-height: 300px;
  overflow-y: auto;
  padding-right: 10px;
}

.history-item {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  padding: 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: white;
  transition: all 0.3s ease;
}

.history-item:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateX(5px);
}

.history-rank {
  font-weight: 700;
  color: #ffd700;
  min-width: 30px;
}

.history-number {
  font-size: 1.3rem;
  font-weight: 700;
  min-width: 50px;
}

.history-range {
  opacity: 0.8;
  flex: 1;
  text-align: center;
}

.history-time {
  font-size: 0.9rem;
  opacity: 0.7;
  min-width: 80px;
  text-align: right;
}

.clear-button {
  background: rgba(255, 99, 71, 0.8);
  color: white;
  border: 1px solid rgba(255, 99, 71, 1);
  padding: 10px 20px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
  width: 100%;
}

.clear-button:hover {
  background: rgba(255, 99, 71, 1);
  transform: scale(1.02);
}

/* 팁 섹션 */
.tips-section {
  margin-top: 40px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.tips-section h3 {
  color: white;
  font-size: 1.3rem;
  margin: 0 0 15px 0;
  font-weight: 700;
}

.tips-list {
  color: rgba(255, 255, 255, 0.9);
}

.tips-list p {
  margin: 8px 0;
  font-size: 1rem;
  line-height: 1.5;
}

/* 뒤로가기 버튼 */
.back-section {
  text-align: center;
  margin-top: 40px;
}

.back-btn {
  display: inline-block;
  padding: 12px 30px;
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 2px solid white;
  border-radius: 50px;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s ease;
  font-size: 1rem;
}

.back-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-3px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

/* 트랜지션 */
.fade-header-enter-active,
.fade-content-enter-active,
.fade-history-enter-active,
.fade-back-enter-active {
  transition: opacity 0.6s ease, transform 0.6s ease;
}

.fade-header-enter-from,
.fade-content-enter-from,
.fade-history-enter-from,
.fade-back-enter-from {
  opacity: 0;
  transform: translateY(20px);
}

.result-pop-enter-active {
  transition: all 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.result-pop-enter-from {
  opacity: 0;
  transform: scale(0) rotate(-360deg);
}

/* 반응형 */
@media (max-width: 768px) {
  .lucky-draw-container {
    margin-top: 70px;
  }

  .page-title {
    font-size: 2.5rem;
  }

  .page-subtitle {
    font-size: 1rem;
  }

  .main-content {
    padding: 25px;
  }

  .input-section {
    flex-direction: column;
    align-items: stretch;
  }

  .number-input {
    width: 100%;
  }

  .draw-button {
    width: 100%;
  }

  .result-number {
    font-size: 3.5rem;
  }

  .result-card {
    min-width: auto;
  }

  .history-item {
    flex-wrap: wrap;
    gap: 10px;
  }

  .history-time {
    width: 100%;
    text-align: left;
  }
}

@media (max-width: 480px) {
  .lucky-draw-container {
    padding: 10px 0 30px 0;
    margin-top: 60px;
  }

  .page-title {
    font-size: 2rem;
  }

  .main-content {
    padding: 20px;
  }

  .input-group label {
    font-size: 1rem;
  }

  .number-input {
    width: 100%;
  }

  .result-number {
    font-size: 2.5rem;
  }

  .draw-button {
    padding: 12px 30px;
    font-size: 1rem;
  }

  .history-list {
    max-height: 200px;
  }

  .tips-list p {
    font-size: 0.9rem;
  }
}
</style>
