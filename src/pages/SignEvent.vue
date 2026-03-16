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
        <div class="form-section">
          <label for="baekjoon-id" class="form-label">백준 아이디</label>
          <input
            type="text"
            id="baekjoon-id"
            class="form-input"
            v-model="baekjoonId"
            placeholder="백준에서 사용하는 아이디를 입력하세요"
          />
          <small class="form-hint">백준 온라인 저지에서 사용하는 실제 아이디를 입력해주세요</small>
        </div>

        <div class="form-section">
          <label for="display-nickname" class="form-label">표시될 닉네임 (선택사항)</label>
          <input
            type="text"
            id="display-nickname"
            class="form-input"
            v-model="displayNickname"
            placeholder="미입력시 기본 닉네임이 사용됩니다"
          />
          <small class="form-hint">백준킹 랭킹에서 표시될 별도의 닉네임입니다 (비워두면 기본 닉네임 사용)</small>
        </div>

        <button class="submit-btn" @click="startEvent">시작하기</button>
      </div>
    </transition>
  </div>
</template>

<script>
import { onMounted, ref } from "vue";
import { API_ROOT } from "@/api.js";

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
      displayNickname: ""
    };
  },
  methods: {
    async startEvent() {
      if (!this.baekjoonId) {
        alert("백준 아이디를 입력해주세요!");
        return;
      }
      
      const payload = {
        baekjoonId: this.baekjoonId
      };

      // displayName이 입력된 경우에만 포함
      if (this.displayNickname.trim()) {
        payload.displayName = this.displayNickname;
      }

      try {
        const response = await fetch(`${API_ROOT}/baekjoon/create-profile`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            ...(localStorage.getItem("token") && {
              Authorization: `Bearer ${localStorage.getItem("token")}`
            })
          },
          body: JSON.stringify(payload)
        });

        const result = await response.json();

        if (response.ok) {
          alert("정보가 성공적으로 등록되었습니다.");
          console.log(result);
        } else {
          // 에러 코드에 따른 예외처리
          if (result.code) {
            switch (result.code) {
              case "MEMBER4003":
                alert("사용자가 없습니다.");
                break;
              case "MEMBER4002":
                alert("닉네임은 필수입니다.");
                break;
              case "MEMBER4004":
                alert("이미 존재하는 사용자입니다.");
                break;
              case "MEMBER4001":
                alert("백준 아이디가 유효하지 않습니다.");
                break;
              default:
                alert(result.message || "정보 등록 중 오류가 발생했습니다. 백준 아이디를 확인해주세요!");
            }
          } else {
            alert("정보 등록 중 오류가 발생했습니다. 백준 아이디를 확인해주세요!");
          }
        }
      } catch (error) {
        console.error("API 호출 오류:", error);
        alert("네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
      }
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
  gap: clamp(16px, 4vw, 20px);
  background: #1e1e1e;
  padding: clamp(20px, 5vw, 30px);
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(255, 85, 125, 0.3);
  width: clamp(260px, 80vw, 360px);
}

.form-section {
  width: 100%;
  margin-bottom: clamp(8px, 2vw, 12px);
}

.form-label {
  font-size: clamp(0.9rem, 4vw, 1rem);
  color: #ff557d;
  text-align: left;
  width: 100%;
  font-weight: 500;
  margin-bottom: 6px;
  display: block;
}

.form-hint {
  display: block;
  font-size: clamp(0.75rem, 3vw, 0.85rem);
  color: rgba(255, 255, 255, 0.6);
  margin-top: 4px;
  line-height: 1.3;
  text-align: left;
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

