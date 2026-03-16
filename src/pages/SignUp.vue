<template>
  <div class="signup-container">
    <h2>회원가입</h2>
    <form @submit.prevent="handleSignUp">
      <div class="form-group">
        <label for="userId">사용자 ID</label>
        <input v-model="form.userId" id="userId" required />
      </div>
      <div class="form-group">
        <label for="emailAddress">이메일 주소</label>
        <input
          v-model="form.emailAddress"
          id="emailAddress"
          type="email"
          required
        />
      </div>
      <div class="form-group">
        <label for="userName">실명</label>
        <input v-model="form.userName" id="userName" required />
      </div>
      <div class="form-group">
        <label for="nickName">닉네임</label>
        <input v-model="form.nickName" id="nickName" required />
      </div>
      <div class="form-group">
        <label for="password">비밀번호</label>
        <input v-model="form.password" id="password" type="password" required />
      </div>
      <div class="form-group">
        <label for="confirmPassword">비밀번호 확인</label>
        <input
          v-model="form.confirmPassword"
          id="confirmPassword"
          type="password"
          required
        />
      </div>
      <button type="submit" :disabled="isLoading">
        {{ isLoading ? "회원가입 중..." : "회원가입" }}
      </button>
    </form>
    <div v-if="error" class="error">{{ error }}</div>
    <div v-if="success" class="success">회원가입이 완료되었습니다!</div>

    <div class="login-link">
      <p>
        이미 계정이 있으신가요? <router-link to="/login">로그인</router-link>
      </p>
    </div>
  </div>
</template>

<script>
import { API_ROOT } from "@/api.js";

export default {
  name: "SignUp",
  data() {
    return {
      form: {
        userId: "",
        emailAddress: "",
        userName: "",
        nickName: "",
        password: "",
        confirmPassword: "",
      },
      error: "",
      success: false,
      isLoading: false,
    };
  },
  methods: {
    async handleSignUp() {
      this.error = "";
      this.success = false;
      this.isLoading = true;

      // 비밀번호 확인 검증
      if (this.form.password !== this.form.confirmPassword) {
        this.error = "비밀번호가 일치하지 않습니다";
        this.isLoading = false;
        return;
      }

      // confirmPassword는 서버로 보내지 않음
      const { confirmPassword, ...formData } = this.form;

      try {
        const response = await fetch(`${API_ROOT}/auth/register`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(formData),
        });
        const result = await response.json();
        if (
          response.status === 201 &&
          result.data &&
          result.data.access_token
        ) {
          // access_token 저장 (data 객체 안에 있음)
          localStorage.setItem("token", result.data.access_token);
          console.log("회원가입 성공, 토큰 저장됨:", result.data.access_token);
          // 네비게이션 바 상태 업데이트를 위한 이벤트 발생
          window.dispatchEvent(new Event("storage"));
          this.success = true;
          // 홈으로 즉시 리다이렉트
          this.$router.push("/");
        } else if (result.code === "AUTH4001") {
          this.error = "이미 존재하는 사용자입니다";
        } else if (result.code === "AUTH4005") {
          this.error = "이미 사용 중인 이메일입니다";
        } else if (result.code === "AUTH4007") {
          this.error = "이미 ZeroPage에 존재하는 사용자 ID입니다";
        } else if (result.code === "AUTH4008") {
          this.error = "이미 ZeroPage에 등록된 이메일입니다";
        } else if (result.code === "AUTH4009") {
          this.error = "이미 ZeroPage에 존재하는 닉네임입니다";
        } else if (response.status === 422) {
          this.error = "요청 데이터 검증에 실패했습니다";
        } else {
          console.log("회원가입 응답:", response.status, result);
          this.error = result.message || "회원가입에 실패했습니다";
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
.signup-container {
  max-width: 500px;
  width: 90%;
  margin: 0 auto;
  padding: 32px;
  background: #222;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
  color: #f1f1f1;
  position: relative;
  top: auto;
  left: auto;
  transform: none;
  margin-top: 40px;
  margin-bottom: 40px;
  min-height: fit-content;
}

/* 데스크톱에서 중앙 정렬이 필요한 경우 */
@media (min-width: 769px) {
  .signup-container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    margin-top: 0;
    margin-bottom: 0;
    /* 하지만 최소 상단 여백 확보 */
    min-height: fit-content;
    max-height: calc(100vh - 160px);
    overflow-y: auto;
  }

  /* 화면이 충분히 클 때만 중앙 정렬 */
  @media (min-height: 800px) {
    .signup-container {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
    }
  }

  /* 화면이 작을 때는 상단 정렬 */
  @media (max-height: 799px) {
    .signup-container {
      position: relative;
      top: auto;
      left: auto;
      transform: none;
      margin-top: 40px;
      margin-bottom: 40px;
    }
  }
}

/* 모바일 대응 */
@media (max-width: 768px) {
  .signup-container {
    position: relative;
    top: auto;
    left: auto;
    transform: none;
    margin: 20px auto;
    min-height: auto;
    max-height: none;
    overflow-y: visible;
    padding: 24px;
    max-width: 100%;
    width: calc(100% - 20px);
  }

  h2 {
    margin-bottom: 20px;
    font-size: 1.5rem;
  }

  .form-group {
    margin-bottom: 14px;
  }

  input {
    padding: 14px;
    font-size: 16px; /* iOS에서 줌 방지 */
  }

  button {
    padding: 14px;
    font-size: 16px;
  }
}

@media (max-width: 480px) {
  .signup-container {
    margin: 10px auto;
    padding: 20px;
    width: calc(100% - 10px);
  }

  h2 {
    font-size: 1.3rem;
  }

  input {
    padding: 12px;
  }

  button {
    padding: 12px;
  }
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

.success {
  color: #4caf50;
  margin-top: 12px;
  text-align: center;
}

.login-link {
  margin-top: 24px;
  text-align: center;
  padding-top: 16px;
  border-top: 1px solid #444;
}

.login-link p {
  margin: 0;
  color: #aaa;
  font-size: 14px;
}

.login-link a {
  color: #1565c0;
  text-decoration: none;
  font-weight: 500;
}

.login-link a:hover {
  text-decoration: underline;
}
</style>
