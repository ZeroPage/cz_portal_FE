<template>
  <div class="attendance-page">
    <div class="attendance-container">
      <!-- 로그인 안내 화면 -->
      <div v-if="!isLoggedIn" class="login-required">
        <div class="login-icon">🔒</div>
        <h2>로그인이 필요합니다</h2>
        <p>출석체크를 이용하려면 로그인 후 이용해주세요</p>
        <router-link to="/login" class="login-btn">로그인하러 가기</router-link>
      </div>

      <!-- 출석체크 화면 -->
      <div v-else>
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

        <!-- 월별 출석 달력 -->
        <div class="calendar-container">
          <div class="calendar-header">
            <h3>{{ currentMonthText }} 출석 현황</h3>
            <p class="attendance-stats">
              이번 달 출석: {{ monthlyData.totalAttendanceDays || 0 }}일 / {{ monthlyData.totalDaysInMonth || 0 }}일
            </p>
          </div>
          
          <div class="calendar">
            <div class="calendar-weekdays">
              <div class="weekday">일</div>
              <div class="weekday">월</div>
              <div class="weekday">화</div>
              <div class="weekday">수</div>
              <div class="weekday">목</div>
              <div class="weekday">금</div>
              <div class="weekday">토</div>
            </div>
            
            <div class="calendar-days">
              <div 
                v-for="day in calendarDays" 
                :key="day.key"
                class="calendar-day"
                :class="{
                  'other-month': !day.isCurrentMonth,
                  'today': day.isToday,
                  'attended': day.isAttended,
                  'future': day.isFuture
                }"
              >
                <span class="day-number">{{ day.date }}</span>
                <div v-if="day.isAttended" class="attendance-mark">✓</div>
              </div>
            </div>
          </div>
        </div>
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
      userInfo: {},
      isLoggedIn: !!localStorage.getItem("token"),
      monthlyData: {
        attendanceDates: [],
        totalAttendanceDays: 0,
        totalDaysInMonth: 0
      },
      currentMonthText: "",
      calendarDays: []
    };
  },
  mounted() {
    this.setCurrentDate();
    this.setCurrentMonthText();
    if (this.isLoggedIn) {
      this.loadUserInfo();
      this.loadMonthlyAttendance();
    } else {
      this.generateCalendarDays();
    }
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

    setCurrentMonthText() {
      const today = new Date();
      const options = {
        year: "numeric",
        month: "long",
      };
      this.currentMonthText = today.toLocaleDateString("ko-KR", options);
    },

    async loadMonthlyAttendance() {
      if (!localStorage.getItem("token")) {
        return;
      }

      try {
        const today = new Date();
        const year = today.getFullYear();
        const month = today.getMonth() + 1;

        const response = await fetch(
          `${API_ROOT}/ticket/monthly-attendance-dates?year=${year}&month=${month}`,
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("token")}`,
            },
          }
        );

        if (response.status === 200) {
          const result = await response.json();
          this.monthlyData = result.data;
          this.generateCalendarDays();
        }
      } catch (e) {
        console.error("월별 출석 데이터 로드 실패:", e);
        this.generateCalendarDays();
      }
    },

    generateCalendarDays() {
      const today = new Date();
      const year = today.getFullYear();
      const month = today.getMonth();
      const todayDate = today.getDate();

      // 이번 달의 첫 번째 날과 마지막 날
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);
      const daysInMonth = lastDay.getDate();

      // 달력 시작 요일 (일요일 = 0)
      const startDayOfWeek = firstDay.getDay();

      // 달력 배열 초기화
      const calendarDays = [];

      // 이전 달의 마지막 날들
      const prevMonth = new Date(year, month - 1, 0);
      const prevMonthDays = prevMonth.getDate();
      
      for (let i = startDayOfWeek - 1; i >= 0; i--) {
        calendarDays.push({
          key: `prev-${prevMonthDays - i}`,
          date: prevMonthDays - i,
          isCurrentMonth: false,
          isToday: false,
          isAttended: false,
          isFuture: false
        });
      }

      // 이번 달의 날들
      for (let day = 1; day <= daysInMonth; day++) {
        const isToday = day === todayDate;
        const isFuture = day > todayDate;
        const isAttended = this.monthlyData.attendanceDates?.includes(day) || false;

        calendarDays.push({
          key: `current-${day}`,
          date: day,
          isCurrentMonth: true,
          isToday,
          isAttended,
          isFuture
        });
      }

      // 다음 달의 첫 번째 날들 (42개까지 채우기)
      const totalCells = 42;
      const remainingCells = totalCells - calendarDays.length;
      
      for (let day = 1; day <= remainingCells; day++) {
        calendarDays.push({
          key: `next-${day}`,
          date: day,
          isCurrentMonth: false,
          isToday: false,
          isAttended: false,
          isFuture: false
        });
      }

      this.calendarDays = calendarDays;
    },

    checkTodayAttendance() {
      // API에서 받은 사용자 정보를 기반으로 출석 상태 확인
      if (this.userInfo.attendanceToday === true) {
        this.attendanceDisabled = true;
      }
    },

    async loadUserInfo() {
      if (!localStorage.getItem("token")) {
        return;
      }

      try {
        const response = await fetch(`${API_ROOT}/auth/me`, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
          },
        });

        if (response.status === 200) {
          const result = await response.json();
          this.userInfo = result.data;
          this.checkTodayAttendance();
        }
      } catch (e) {
        console.error("사용자 정보 로드 실패:", e);
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

          // 사용자 정보 다시 로드해서 상태 업데이트
          await this.loadUserInfo();
          // 월별 출석 데이터 다시 로드
          await this.loadMonthlyAttendance();

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
  min-height: calc(100vh - 80px);
  background: #0a0a0a;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding: 20px;
  padding-top: 40px;
}

.attendance-container {
  max-width: 400px;
  width: 100%;
  margin: 0 auto;
}

.login-required {
  text-align: center;
  color: white;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 60px 40px;
  box-shadow: 0 8px 32px 0 rgba(200, 50, 50, 0.37);
  backdrop-filter: blur(12px);
}

.login-icon {
  font-size: 4rem;
  margin-bottom: 20px;
  opacity: 0.8;
}

.login-required h2 {
  font-size: 1.8rem;
  margin: 0 0 15px 0;
  color: #ff6b81;
}

.login-required p {
  font-size: 1.1rem;
  opacity: 0.9;
  margin: 0 0 30px 0;
  line-height: 1.5;
}

.login-btn {
  display: inline-block;
  padding: 15px 30px;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562, #e0a04a);
  background-size: 300%;
  color: white;
  text-decoration: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 1.1rem;
  transition: all 0.3s ease;
  animation: gradient 8s linear infinite;
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 107, 129, 0.4);
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

/* 달력 스타일 */
.calendar-container {
  margin-top: 30px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 25px;
  box-shadow: 0 8px 32px 0 rgba(200, 50, 50, 0.37);
  backdrop-filter: blur(12px);
}

.calendar-header {
  text-align: center;
  margin-bottom: 20px;
}

.calendar-header h3 {
  font-size: 1.4rem;
  margin: 0 0 10px 0;
  color: white;
  background: linear-gradient(45deg, #ff2e63, #ff6b81, #ffb562, #e0a04a);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: gradient 8s linear infinite;
  background-size: 300%;
}

.attendance-stats {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.95rem;
  margin: 0;
}

.calendar {
  width: 100%;
}

.calendar-weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 2px;
  margin-bottom: 8px;
}

.weekday {
  text-align: center;
  padding: 8px;
  font-weight: 600;
  color: #ff6b81;
  font-size: 0.9rem;
}

.calendar-days {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 2px;
}

.calendar-day {
  position: relative;
  aspect-ratio: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  transition: all 0.3s ease;
  cursor: default;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.calendar-day.other-month {
  opacity: 0.3;
  background: rgba(255, 255, 255, 0.02);
}

.calendar-day.today {
  background: rgba(255, 107, 129, 0.3);
  border-color: #ff6b81;
  box-shadow: 0 0 10px rgba(255, 107, 129, 0.5);
}

.calendar-day.attended {
  background: rgba(76, 175, 80, 0.3);
  border-color: #4caf50;
}

.calendar-day.future {
  opacity: 0.5;
  background: rgba(255, 255, 255, 0.02);
}

.day-number {
  color: white;
  font-weight: 500;
  font-size: 0.9rem;
  z-index: 1;
}

.calendar-day.other-month .day-number {
  color: rgba(255, 255, 255, 0.4);
}

.calendar-day.attended .day-number {
  color: #4caf50;
  font-weight: 600;
}

.attendance-mark {
  position: absolute;
  top: 2px;
  right: 2px;
  width: 16px;
  height: 16px;
  background: #4caf50;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  color: white;
  font-weight: bold;
  box-shadow: 0 2px 4px rgba(76, 175, 80, 0.4);
}

.calendar-day:hover:not(.other-month):not(.future) {
  transform: scale(1.05);
  background: rgba(255, 255, 255, 0.1);
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
  .attendance-page {
    padding: 10px;
    padding-top: 20px;
    min-height: calc(100vh - 80px);
  }

  .attendance-header h1 {
    font-size: 2rem;
  }

  .attendance-card {
    padding: 25px 15px;
  }

  .check-circle {
    width: 70px;
    height: 70px;
  }

  .icon {
    font-size: 1.5rem;
  }

  .calendar-container {
    padding: 15px;
    margin-top: 20px;
  }

  .calendar-header h3 {
    font-size: 1.2rem;
  }

  .weekday {
    padding: 4px;
    font-size: 0.75rem;
  }

  .day-number {
    font-size: 0.75rem;
  }

  .attendance-mark {
    width: 12px;
    height: 12px;
    font-size: 7px;
    top: 1px;
    right: 1px;
  }

  .attendance-container {
    max-width: 100%;
  }
}
</style>
