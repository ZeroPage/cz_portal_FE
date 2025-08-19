<template>
  <div class="sign-container">
    <div class="header">
      <transition name="fade-title">
        <h1 v-if="show" class="title">
          <span class="full-title">JOIN THE BAEKJOONKING</span>
          <span class="short-title">JOIN BJKING</span>
        </h1>
      </transition>

      <transition name="fade-content">
        <h2 v-if="show" class="subtitle">Challenge Yourself to Become the Next Baekjoon King!</h2>
      </transition>
    </div>

    <transition name="fade-content">
      <div v-if="show" class="form-container">
        <label for="baekjoon-id" class="form-label">백준 아이디</label>
        <input
          type="text"
          id="baekjoon-id"
          class="form-input"
          v-model="baekjoonId"
          placeholder="Enter your Baekjoon ID"
        />

        <label for="nickname" class="form-label">닉네임</label>
        <input
          type="text"
          id="nickname"
          class="form-input"
          v-model="nickname"
          placeholder="Enter your nickname"
        />

        <button class="submit-btn" @click="startEvent">시작하기</button>
      </div>
    </transition>
  </div>
</template>

<script>
import { onMounted, ref } from "vue";
import axios from "axios";

export default {
  name: "SignEvent",
  setup() {
    const show = ref(false);
    onMounted(() => {
      show.value = true; // 페이지 로드시 애니메이션 실행
    });
    return { show };
  },
  data() {
    return {
      baekjoonId: "",
      nickname: ""
    };
  },
  methods: {
    startEvent() {
      if (!this.baekjoonId || !this.nickname) {
        alert("모든 항목을 입력해주세요!");
        return;
      }
      
      const payload = {
        username: this.baekjoonId, // 백엔드 DTO의 username 필드에 매핑
        nickname: this.nickname
      };

      axios
        .post("https://czportal.site/api/infos/post", payload)
        .then(response => {
          alert("정보가 성공적으로 등록되었습니다.");
          console.log(response.data);
        })
        .catch(error => {
          // error.response.data가 존재하는 경우 에러코드에 따른 예외처리
          if (error.response && error.response.data && error.response.data.code) {
            const code = error.response.data.code;
            switch (code) {
              case "MEMBER4003":
                alert("사용자가 없습니다.");
                break;
              case "MEMBER4002":
                alert("닉네임은 필수 입니다.");
                break;
              case "MEMBER4004":
                alert("이미 존재하는 사용자입니다.");
                break;
              default:
                alert("정보 등록 중 오류가 발생했습니다. 백준 아이디를 확인해주세요!");
            }
          } else {
            alert("정보 등록 중 오류가 발생했습니다. 백준 아이디를 확인해주세요!");
          }
          console.error(error);
        });
    }
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
.full-title {
  display: inline;
}
.short-title {
  display: none;
}
.sign-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  color: white;
  text-align: center;
  font-family: 'Poppins', sans-serif;
  padding: clamp(20px, 5vw, 60px);
}

.header {
  margin-bottom: clamp(20px, 5vh, 40px);
}

.subtitle {
  font-size: clamp(1rem, 5.5vw, 1.4rem);
  opacity: 0.8;
  margin-bottom: clamp(20px, 1vw, 40px);
  line-height: 1.4;
}

.form-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: clamp(12px, 4vw, 16px);
  background: #1e1e1e;
  padding: clamp(20px, 5vw, 30px);
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(255, 85, 125, 0.3);
  width: clamp(260px, 80vw, 360px);
}

.form-label {
  font-size: clamp(0.9rem, 4vw, 1rem);
  color: #ff557d;
  text-align: left;
  width: 100%;
  font-weight: 500;
  margin-bottom: -10px;
}

.form-input {
  width: 100%;
  padding: clamp(8px, 2vw, 12px);
  border: none;
  border-radius: 6px;
  background: #333;
  color: white;
  font-size: clamp(0.9rem, 4vw, 1rem);
  margin-bottom: 10px;
}

.submit-btn {
  width: 100%;
  padding: clamp(10px, 3vw, 14px);
  border: none;
  border-radius: 6px;
  background: linear-gradient(90deg, #ff557d, #ff6b81);
  color: white;
  font-size: clamp(1rem, 4vw, 1.2rem);
  font-weight: 500;
  cursor: pointer;
  transition: opacity 0.3s;
}

.submit-btn:hover {
  opacity: 0.8;
}

/* Transitions */
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

@media(max-width: 768px){
  .subtitle{
    display: none;
  }
}

@media(max-width: 550px){
  .full-title {
    display: none;
  }
  .short-title {
    display: inline;
  }
}
</style>

