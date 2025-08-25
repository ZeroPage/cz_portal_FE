<template>
  <div class="login-container">
    <h2>로그인</h2>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label for="studentNumber">학번</label>
        <input v-model="form.studentNumber" id="studentNumber" required />
      </div>
      <div class="form-group">
        <label for="password">비밀번호</label>
        <input v-model="form.password" id="password" type="password" required />
      </div>
      <button type="submit" :disabled="isLoading">
        {{ isLoading ? "로그인 중..." : "로그인" }}
      </button>
    </form>
    <div v-if="error" class="error">{{ error }}</div>

    <div class="signup-link">
      <p>계정이 없으신가요? <router-link to="/signup">회원가입</router-link></p>
    </div>
  </div>
</template>

<script>
import { API_ROOT } from "@/api.js";

export default {
  name: "Login",
  data() {
    return {
      form: {
        studentNumber: "",
        password: "",
      },
      error: "",
      isLoading: false,
    };
  },
  methods: {
    async handleLogin() {
      this.error = "";
      this.isLoading = true;

      try {
        const response = await fetch(`${API_ROOT}/auth/login`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(this.form),
        });

        const result = await response.json();

        if (
          response.status === 201 &&
          result.data &&
          result.data.access_token
        ) {
          // access_token 저장 (data 객체 안에 있음)
          localStorage.setItem("token", result.data.access_token);
          console.log("로그인 성공, 토큰 저장됨:", result.data.access_token);
          // 네비게이션 바 상태 업데이트를 위한 이벤트 발생
          window.dispatchEvent(new Event("storage"));
          // 홈으로 리다이렉트
          this.$router.push("/");
        } else if (result.code === "AUTH4002") {
          this.error = "이메일 또는 비밀번호가 올바르지 않습니다";
        } else {
          console.log("로그인 응답:", response.status, result);
          this.error = result.message || "로그인에 실패했습니다";
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
.login-container {
  max-width: 500px;
  width: 90%;
  margin: 0 auto;
  padding: 32px;
  background: #222;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
  color: #f1f1f1;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

h2 {
  text-align: center;
  margin-bottom: 24px;
  color: #f1f1f1;
}

.form-group {
  margin-bottom: 16px;
}

label {
  display: block;
  margin-bottom: 6px;
  font-weight: 500;
}

input {
  width: 100%;
  padding: 12px;
  border: 1px solid #444;
  border-radius: 4px;
  background: #333;
  color: #f1f1f1;
  font-size: 16px;
}

input:focus {
  outline: none;
  border-color: #1565c0;
}

button {
  width: 100%;
  padding: 12px;
  background: #1565c0;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s;
}

button:hover:not(:disabled) {
  background: #1976d2;
}

button:disabled {
  background: #555;
  cursor: not-allowed;
}

.error {
  color: #f44336;
  margin-top: 12px;
  text-align: center;
}

.signup-link {
  margin-top: 24px;
  text-align: center;
  padding-top: 16px;
  border-top: 1px solid #444;
}

.signup-link p {
  margin: 0;
  color: #aaa;
  font-size: 14px;
}

.signup-link a {
  color: #1565c0;
  text-decoration: none;
  font-weight: 500;
}

.signup-link a:hover {
  text-decoration: underline;
}
</style>
