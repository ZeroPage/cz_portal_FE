<template>
  <div class="notice-container">
    <transition name="fade-title">
      <h1 v-if="show" class="title">
        NOTICES
      </h1>
    </transition>

    <transition name="fade-content">
      <div v-if="show" class="notice-content">
        <!-- 왼쪽 -->
        <div class="notice-list">
          <div
              v-for="notice in notices"
              :key="notice.id"
              class="notice-item"
              @click="selectedNotice = notice"
              :class="{
              'important-notice': notice.flag === 1,
              'selected-notice': selectedNotice && selectedNotice.id === notice.id
            }"
          >
            <h3 class="notice-title">{{ notice.title }}</h3>
            <p class="notice-date">{{ notice.date }}</p>
          </div>
        </div>

        <!-- 오른쪽 -->
        <div class="notice-detail">
          <transition name="fade-detail">
            <div v-if="selectedNotice" :key="selectedNotice.id">
              <div class="detail-header">
                <h2 class="detail-title">{{ selectedNotice.title }}</h2>
                <p class="detail-date">
                  게시: {{ selectedNotice.date }}
                  <span
                      :class="{
                      'status-icon active': selectedNotice.flag === 1,
                      'status-icon inactive': selectedNotice.flag === 0
                    }"
                  >●</span>
                  <span class="status-text">{{ selectedNotice.flag === 1 ? '진행' : '종료' }}</span>
                </p>
              </div>
              <p class="detail-text" v-html="formattedContent"></p>
            </div>
            <p v-else key="placeholder" class="detail-placeholder">공지사항을 선택하세요.</p>
          </transition>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
  name: "Notice",
  computed: {
    formattedContent() {
      return this.selectedNotice
          ? this.selectedNotice.content.replace(/\n/g, "<br>")
          : "";
    },
  },
  setup() {
    const show = ref(false);

    onMounted(() => {
      show.value = true;
    });

    return { show };
  },
  data() {
    return {
      selectedNotice: null,
      notices: [],
    };
  },
  async created() {
    await this.loadNotices();
  },
  methods: {
    async loadNotices() {
      try {
        const response = await fetch("/notices.json");
        let notices = await response.json();

        // 중요 공지 우선, 최신 순 정렬
        notices.sort((a, b) => {
          if (a.flag !== b.flag) {
            return b.flag - a.flag;
          }
          return new Date(b.date) - new Date(a.date);
        });

        this.notices = notices;
      } catch (error) {
        console.error("Failed to load notices:", error);
      }
    },
  },
};
</script>

<style scoped>
.title {
  margin-top: clamp(2rem, 6vh, 4rem);
}

.notice-container {
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  color: white;
  text-align: center;
  position: relative;
  padding-top: clamp(60px, 8vh, 80px); /* 반응형 */
  padding-bottom: clamp(60px, 8vh, 80px);
}

.notice-content {
  display: flex;
  width: 80%;
  height: 60vh;
  gap: clamp(10px, 2vw, 20px);
}

.notice-list {
  flex: 1;
  background: rgba(255, 255, 255, 0.1);
  padding: clamp(15px, 2vw, 20px);
  border-radius: clamp(8px, 1vw, 10px);
  overflow-y: auto;
  height: 100%;
  box-shadow: 0 8px 32px rgba(255, 255, 255, 0.1);
}

.notice-list::-webkit-scrollbar {
  width: clamp(6px, 0.6vw, 8px);
}
.notice-list::-webkit-scrollbar-track {
  background: transparent;
}
.notice-list::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}
.notice-list::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

.notice-item {
  padding: 8px;
  margin-bottom: clamp(8px, 1.5vw, 10px);
  background: rgba(255, 255, 255, 0.2);
  border-radius: clamp(6px, 1vw, 8px);
  cursor: pointer;
  transition: all 0.3s ease-in-out;
  border: 2px solid transparent;
}
.important-notice {
  border: 1.5px solid rgba(229, 115, 115, 0.8);
}
.notice-item:hover,
.selected-notice {
  background: rgba(255, 255, 255, 0.4);
}

.notice-title {
  font-size: clamp(0.9rem, 1.2vw, 1rem);
  font-weight: bold;
}
.notice-date {
  font-size: clamp(0.7rem, 1vw, 0.8rem);
  opacity: 0.7;
}

.notice-detail {
  flex: 1;
  background: rgba(255, 255, 255, 0.1);
  padding: clamp(15px, 2vw, 20px);
  border-radius: clamp(8px, 1vw, 10px);
  overflow-y: auto;
  height: 100%;
  box-shadow: 0 8px 32px rgba(255, 255, 255, 0.1);
}
.notice-detail::-webkit-scrollbar {
  width: clamp(6px, 0.6vw, 8px);
}
.notice-detail::-webkit-scrollbar-track {
  background: transparent;
}
.notice-detail::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}
.notice-detail::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.detail-title {
  font-size: clamp(1.2rem, 2vw, 1.5rem);
  font-weight: bold;
  margin-bottom: 10px;
}
.detail-date {
  font-size: clamp(0.7rem, 1vw, 0.8rem);
  opacity: 0.7;
  text-align: right;
}
.detail-text {
  font-size: clamp(0.7rem, 1.2vw, 1rem);
  text-align: left;
}
.detail-placeholder {
  font-size: clamp(0.9rem, 1.2vw, 1rem);
  opacity: 0.7;
}

.status-icon {
  font-size: clamp(0.7rem, 1vw, 0.8rem);
  margin-left: 5px;
}
.status-icon.active {
  color: #4caf50;
}
.status-icon.inactive {
  color: #9e9e9e;
}
.status-text {
  font-size: clamp(0.7rem, 1vw, 0.8rem);
  margin-left: 5px;
  font-weight: bold;
}

/* 페이드 애니메이션 */
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
.fade-detail-enter-active {
  transition: opacity 0.5s ease, transform 0.3s ease;
}
.fade-detail-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

/* 반응형 (중단점 이하일 때) */
@media (max-width: 1024px) {
  .notice-container {
    height: 100vh;
    display: flex;
    flex-direction: column;
    padding-top: clamp(60px, 8vh, 80px);
    overflow: hidden;
    padding-bottom: clamp(60px, 8vh, 80px);
  }

  .notice-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: clamp(8px, 1vw, 12px);
    overflow: hidden;
  }

  /* ⬇️ 여기 비율 조정 */
  .notice-list {
    flex: 0 0 40%;
    min-height: 0;
    overflow-y: auto;
  }

  .notice-detail {
    flex: 0 0 60%;
    min-height: 0;
    overflow-y: auto;
    margin-bottom: clamp(30px, 4vh, 40px);
  }

  .detail-header {
    flex-direction: column;
    align-items: flex-start;
    gap: clamp(8px, 1vw, 10px);
  }

  .detail-title {
    font-size: clamp(1.1rem, 1.8vw, 1.3rem);
  }

  .detail-text {
    font-size: clamp(0.9rem, 1.1vw, 0.95rem);
  }

  .notice-title {
    font-size: clamp(0.85rem, 1vw, 0.95rem);
  }

  .notice-date,
  .detail-date {
    font-size: clamp(0.65rem, 0.9vw, 0.75rem);
  }
}

</style>