<template>
  <div v-if="oms" class="oms-detail-container">
    <!-- 제목: 큼직하게 위에 -->
    <div class="pdf-title-container">
      <h2 class="pdf-title">{{ oms.title }}</h2>
    </div>

    <!-- 발표자와 날짜: 같은 줄, 좌우 정렬 -->
    <div class="pdf-meta-container">
      <p class="pdf-presenter">발표자: {{ oms.presenter }}</p>
      <p class="pdf-date">{{ oms.date }}</p>
    </div>

    <!-- PDF 뷰어 -->
    <div v-if="pdfExists" class="pdf-viewer">
      <iframe :src="pdfUrl" width="100%" height="800px" />
    </div>
    <div v-else class="no-pdf">
      <p>아직 PDF 자료가 업로드되지 않았습니다.</p>
    </div>
  </div>

  <div v-else>
    <p style="text-align: center; padding: 50px; color: white;">
      자료를 찾을 수 없습니다.
    </p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const oms = ref(null);
const pdfUrl = ref('');
const pdfExists = ref(false);

onMounted(async () => {
  try {
    const response = await fetch('/omss.json');
    const omssData = await response.json();

    const id = parseInt(route.params.id);
    const data = omssData.find(item => item.id === id);

    if (data) {
      oms.value = data;
      pdfUrl.value = `/pdfs/oms${id}.pdf`;

      const pdfCheck = await fetch(pdfUrl.value, { method: 'HEAD' });
      pdfExists.value = pdfCheck.ok;
    }
  } catch (error) {
    console.error('OMSS 데이터를 불러오지 못했습니다:', error);
  }
});
</script>

<style scoped>
.oms-detail-container {
  max-width: 1000px;
  margin: clamp(100px, 10vh, 120px) auto 0;
  padding: 0 clamp(16px, 4vw, 40px) clamp(40px, 6vh, 60px);
  color: #fff;
}

/* 제목 영역 */
.pdf-title-container {
  margin-bottom: clamp(4px, 1.5vh, 16px);
}

.pdf-title {
  font-size: clamp(1.5rem, 4vw, 2.5rem);
  font-weight: bold;
  margin: 0;
}

.pdf-meta-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: clamp(4px, 1.5vh, 16px);
  padding: 0 clamp(4px, 1vw, 10px);
}

.pdf-presenter,
.pdf-date {
  font-size: clamp(0.9rem, 2vw, 1.1rem);
  color: rgba(255, 255, 255, 0.7);
}

.pdf-viewer {
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 15px;
  overflow: hidden;
}

/* PDF가 없는 경우 */
.no-pdf {
  margin-top: clamp(20px, 4vh, 30px);
  padding: clamp(20px, 4vw, 40px);
  text-align: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  font-size: clamp(1rem, 2vw, 1.2rem);
  color: rgba(255, 255, 255, 0.8);
}
</style>

