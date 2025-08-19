<template>
  <div class="study-container">
    <transition name="fade-title">
      <h1 v-if="show" class="title">Active Studies</h1>
    </transition>

    <transition name="fade-content">
      <div v-if="show" class="study-grid">
        <div
          v-for="study in studies"
          :key="study.id"
          class="study-card"
        >
          <h2 class="study-name">{{ study.name }}</h2>
          <p class="capacity">
            인원: <span class="highlight">{{ study.currentMembers }}/{{ study.totalMembers }}</span>
          </p>
          <p class="application-criteria">
            신청 조건: {{ study.applicationCriteria }}
          </p>
          <p class="greeting">
            스터디 소개: "{{ study.greeting }}"
          </p>
          <p class="mentor">
            스터디장: <span class="highlight">{{ study.leader }}</span>
          </p>
          <p class="contact">
            가입 방법: <span class="contact">{{ study.contact }}</span>
          </p>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
  name: "StudySection",
  setup() {
    const show = ref(false);
    const studies = ref([]);

    const fetchStudies = async () => {
      try {
        const response = await fetch("/study.json");
        const data = await response.json();
        studies.value = data.studies;
      } catch (error) {
        console.error("Error fetching studies:", error);
      }
    };

    onMounted(async () => {
      show.value = true;
      await fetchStudies();
    });

    return {
      show,
      studies
    };
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&family=Noto+Sans+KR:wght@400;700&display=swap');

.study-container {
  margin-top: clamp(60px, 10vh, 100px);
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: clamp(20px, 5vw, 40px) clamp(16px, 5vw, 32px);
  font-family: 'Poppins', 'Noto Sans KR', sans-serif;
  color: white;
}

.study-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: clamp(16px, 3vw, 24px);
  width: 100%;
  max-width: 1200px;
}

.study-card {
  background: rgba(255, 255, 255, 0.1);
  padding: clamp(16px, 4vw, 24px);
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);
  transition: transform 0.3s ease;
}

.study-card:hover {
  transform: translateY(-5px);
}

.study-name {
  font-size: clamp(1.2rem, 3vw, 1.8rem);
  margin-bottom: clamp(8px, 1vh, 12px);
  font-weight: bold;
}

.capacity,
.application-criteria,
.greeting,
.contact,
.mentor {
  font-size: clamp(0.9rem, 2.2vw, 1.1rem);
  margin: clamp(6px, 1vh, 10px) 0;
}

.highlight {
  color: #ffd700;
  font-weight: 700;
}

/* 반응형: 화면이 768px 이하일 때 한 열로 변경 */
@media (max-width: 768px) {
  .study-grid {
    grid-template-columns: 1fr;
  }
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
