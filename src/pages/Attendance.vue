<template>
  <div class="attendance-page">
    <div class="attendance-container">
      <div class="attendance-header">
        <h1>출석체크</h1>
        <p class="date">{{ currentDate }}</p>
      </div>

      <div class="attendance-card">
        <div class="attendance-icon">
          <div
            class="check-circle"
            :class="{
              success: attendanceSuccess,
              disabled: attendanceDisabled,
            }"
          >
            <i v-if="attendanceSuccess" class="icon">✓</i>
            <i v-else-if="attendanceDisabled" class="icon">✓</i>
            <i v-else class="icon">📝</i>
          </div>
        </div>

        <div class="attendance-content">
          <h2 v-if="!attendanceSuccess && !attendanceDisabled">
            오늘도 화이팅!
          </h2>
          <h2 v-else-if="attendanceSuccess">출석 완료!</h2>
          <h2 v-else>이미 출석했어요</h2>

          <p v-if="!attendanceSuccess && !attendanceDisabled" class="subtitle">
            매일 출석해서 포인트를 모아보세요
          </p>
          <p v-else-if="attendanceSuccess" class="subtitle success-text">
            오늘 출석이 완료되었습니다
          </p>
          <p v-else class="subtitle disabled-text">내일 다시 와주세요!</p>
        </div>

        <button
          @click="checkAttendance"
          :disabled="isLoading || attendanceDisabled"
          class="attendance-btn"
          :class="{
            success: attendanceSuccess,
            disabled: attendanceDisabled,
            loading: isLoading,
          }"
        >
          <span v-if="isLoading">처리중...</span>
          <span v-else-if="attendanceSuccess">출석 완료</span>
          <span v-else-if="attendanceDisabled">출석 완료</span>
          <span v-else>출석하기</span>
        </button>
      </div>

      <div v-if="error" class="error-message">
        {{ error }}
      </div>

      <div v-if="successMessage" class="success-message">
        {{ successMessage }}
      </div>
    </div>
  </div>
</template>

<script>
import { API_ROOT } from "@/api.js";

export default {
  name: "Attendance",
  data() {
    return {
      isLoading: false,
      attendanceSuccess: false,
      attendanceDisabled: false,
      error: "",
      successMessage: "",
      currentDate: "",
    };
  },
  mounted() {
    this.setCurrentDate();
    this.checkTodayAttendance();
  },
  methods: {
    setCurrentDate() {
      const today = new Date();
      const options = {
        year: "numeric",
        month: "long",
        day: "numeric",
        weekday: "long",
      };
      this.currentDate = today.toLocaleDateString("ko-KR", options);
    },

    checkTodayAttendance() {
      // localStorage에서 오늘 출석 여부 확인
      const today = new Date().toDateString();
      const lastAttendance = localStorage.getItem("lastAttendance");
      if (lastAttendance === today) {
        this.attendanceDisabled = true;
      }
    },

    async checkAttendance() {
      if (!localStorage.getItem("token")) {
        this.error = "로그인이 필요합니다";
        return;
      }

      this.isLoading = true;
      this.error = "";
      this.successMessage = "";

      try {
        // 프록시를 통한 요청 (CORS 회피)
        const response = await fetch(`${API_ROOT}/ticket/daily-attendance`, {
          method: "GET",
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });

        const result = await response.json();

        if (response.status === 200) {
          this.attendanceSuccess = true;
          this.successMessage = "출석체크가 완료되었습니다!";
          // 오늘 출석 완료 기록
          localStorage.setItem("lastAttendance", new Date().toDateString());

          // 3초 후 성공 상태를 비활성화 상태로 변경
          setTimeout(() => {
            this.attendanceDisabled = true;
            this.attendanceSuccess = false;
          }, 3000);
        } else if (result.code === "TICKET4003") {
          this.attendanceDisabled = true;
          this.error = "이미 출석 체크를 받았습니다";
        } else {
          this.error = result.message || "출석체크에 실패했습니다";
        }
      } catch (e) {
        this.error = "네트워크 오류가 발생했습니다";
      } finally {
        this.isLoading = false;
      }
    },
  },
};
</script>

<style scoped>
.attendance-page {
  min-height: 100vh;
  background: #0a0a0a;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.attendance-container {
  max-width: 400px;
  width: 100%;
}

.attendance-header {
  text-align: center;
  margin-bottom: 30px;
  color: white;
}

.attendance-header h1 {
  font-size: 2.5rem;
  margin: 0 0 10px 0;
  font-weight: 700;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562, #e0a04a);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: gradient 8s linear infinite;
  background-size: 300%;
}

.date {
  font-size: 1.1rem;
  opacity: 0.9;
  margin: 0;
}

.attendance-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 40px 30px;
  text-align: center;
  box-shadow: 0 8px 32px 0 rgba(200, 50, 50, 0.37);
  backdrop-filter: blur(12px);
  transition: transform 0.3s ease;
}

.attendance-card:hover {
  transform: translateY(-5px);
}

.attendance-icon {
  margin-bottom: 25px;
}

.check-circle {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.05);
  border: 3px solid rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
  transition: all 0.3s ease;
}

.check-circle.success {
  background: rgba(255, 107, 129, 0.2);
  border-color: #ff6b81;
  animation: successPulse 0.6s ease-out;
}

.check-circle.disabled {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.3);
}

.icon {
  font-size: 2rem;
  font-style: normal;
}

.check-circle.success .icon {
  color: #ff6b81;
}

.check-circle.disabled .icon {
  color: rgba(255, 255, 255, 0.6);
}

.icon {
  color: rgba(255, 255, 255, 0.8);
}

@keyframes successPulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}

.attendance-content h2 {
  font-size: 1.5rem;
  margin: 0 0 10px 0;
  color: white;
}

.subtitle {
  color: rgba(255, 255, 255, 0.7);
  margin: 0 0 30px 0;
  line-height: 1.5;
}

.success-text {
  color: #ff6b81;
}

.disabled-text {
  color: rgba(255, 255, 255, 0.5);
}

.attendance-btn {
  width: 100%;
  padding: 15px;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562, #e0a04a);
  background-size: 300%;
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  animation: gradient 8s linear infinite;
}

.attendance-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 107, 129, 0.4);
}

.attendance-btn.success {
  background: #ff6b81;
  animation: none;
}

.attendance-btn.disabled {
  background: rgba(255, 255, 255, 0.2);
  cursor: not-allowed;
  animation: none;
}

.attendance-btn.loading {
  background: rgba(255, 255, 255, 0.2);
  cursor: not-allowed;
  animation: none;
}

.attendance-btn:disabled {
  transform: none;
  box-shadow: none;
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

.success-message {
  background: rgba(255, 107, 129, 0.2);
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

@media (max-width: 480px) {
  .attendance-header h1 {
    font-size: 2rem;
  }

  .attendance-card {
    padding: 30px 20px;
  }

  .check-circle {
    width: 70px;
    height: 70px;
  }

  .icon {
    font-size: 1.5rem;
  }
}
</style>
