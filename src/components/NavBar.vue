<template>
  <nav class="navbar">
    <div class="navbar-container" ref="navbarRef">
      <div class="logo">
        <span class="logo-text">CLUG X ZeroPage</span>
        <img src="/czlogo.png" alt="Logo" class="logo-img" />
      </div>
      <button class="toggle-button" @click="toggleMenu">☰</button>
      <ul class="nav-links" :class="{ open: isMenuOpen }">
        <li><router-link to="/" @click="closeMenu">Home</router-link></li>
        <li><router-link to="/about" @click="closeMenu">About</router-link></li>
        <li>
          <router-link to="/baekjoonking" @click="closeMenu"
            >BaekjoonKing</router-link
          >
        </li>
        <li>
          <router-link to="/notice" @click="closeMenu">Notice</router-link>
        </li>
        <li>
          <router-link to="/oms_week" @click="closeMenu">OMS</router-link>
        </li>
        <li>
          <router-link to="/attendance" @click="closeMenu"
            >출석체크</router-link
          >
        </li>
        <li>
          <router-link to="/gacha" @click="closeMenu">뽑기</router-link>
        </li>
        <li v-if="!isLoggedIn">
          <router-link to="/login" @click="closeMenu">로그인</router-link>
        </li>
        <li v-if="isLoggedIn">
          <a @click="logout" href="#" style="cursor: pointer">로그아웃</a>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed } from "vue";

const isMenuOpen = ref(false);
const navbarRef = ref(null);

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value;
};

const closeMenu = () => {
  isMenuOpen.value = false;
};

const logout = () => {
  localStorage.removeItem("token");
  isLoggedIn.value = false; // 즉시 상태 업데이트
  closeMenu();
  // 홈으로 리다이렉트 (필요시)
  window.location.href = "/";
};

const handleOutsideClick = (event) => {
  if (
    isMenuOpen.value &&
    navbarRef.value &&
    !navbarRef.value.contains(event.target)
  ) {
    closeMenu();
  }
};

onMounted(() => {
  document.addEventListener("click", handleOutsideClick);
  // localStorage 변경 감지
  window.addEventListener("storage", updateLoginStatus);
});

onBeforeUnmount(() => {
  document.removeEventListener("click", handleOutsideClick);
  window.removeEventListener("storage", updateLoginStatus);
});

// 로그인 상태 반응형 변수
const isLoggedIn = ref(!!localStorage.getItem("token"));

// localStorage 변경 감지 함수
const updateLoginStatus = () => {
  isLoggedIn.value = !!localStorage.getItem("token");
};
</script>

<style>
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  padding: 1rem 5%;
  backdrop-filter: blur(12px);
  background: var(--glass-bg);
  border-bottom: var(--border);
  z-index: 1000;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: var(--shadow);
  height: 80px;
  display: flex;
  align-items: center;
}

.navbar-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 1rem;
  width: 100%;
  height: 100%;
}

.logo {
  display: flex;
  align-items: center;
  height: 40px;
  flex-shrink: 0;
  margin-right: 2rem;
}

/* 기본값: 텍스트 보이고 이미지 숨김 */
.logo-text {
  font-size: clamp(1.5rem, 1.8vw, 1.8rem);
  font-weight: 700;
  background: var(--gradient);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: gradient 8s linear infinite;
  background-size: 300%;
  letter-spacing: -0.5px;
}

.logo-img {
  display: none;
  height: 100%;
}

.toggle-button {
  display: none;
  font-size: 2rem;
  background: none;
  border: none;
  color: white;
  cursor: pointer;
  margin-left: auto;
}

.nav-links {
  display: flex;
  gap: 2.5rem;
  list-style: none;
  transition: max-height 0.3s ease;
  margin: 0;
  flex: 1;
  justify-content: flex-end;
}

.nav-links a {
  color: white;
  text-decoration: none;
  font-weight: 500;
  position: relative;
  padding: 0.5rem 0;
  transition: all 0.3s ease;
  font-size: 1.05rem;
  letter-spacing: 0.3px;
}

.nav-links a::before,
.nav-links a::after {
  content: "";
  position: absolute;
  width: 0;
  height: 2px;
  background: var(--gradient);
  background-size: 300%;
  transition: width 0.3s ease;
}

.nav-links a::before {
  top: -4px;
  left: 0;
}

.nav-links a::after {
  bottom: -4px;
  right: 0;
}

.nav-links a:hover {
  color: #fff;
  text-shadow: 0 0 8px rgba(255, 255, 255, 0.3);
}

.nav-links a:hover::before,
.nav-links a:hover::after {
  width: 100%;
  animation: gradient 8s linear infinite;
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

/* ===== Responsive ===== */
@media (max-width: 1024px) {
  .nav-links {
    gap: 1.8rem;
  }
  
  .logo {
    margin-right: 1.5rem;
  }
  
  .logo-text {
    font-size: 1.5rem;
  }
}

@media (max-width: 768px) {
  .navbar {
    height: 80px;
    padding: 0.5rem 3%;
  }

  .navbar-container {
    flex-direction: column;
    align-items: flex-start;
    position: relative;
    height: 100%;
  }

  .logo {
    margin-right: 0;
    margin-bottom: 0;
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
  }

  .logo-text {
    font-size: 1.3rem;
  }

  .toggle-button {
    display: block;
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    z-index: 1001;
    font-size: 1.5rem;
    padding: 0.5rem;
  }

  .nav-links {
    flex-direction: column;
    width: 100%;
    gap: 0;
    margin: 0;
    padding: 0;
    position: absolute;
    top: 100%;
    left: 0;
    background: rgba(0, 0, 0, 0.98);
    backdrop-filter: blur(12px);
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    
    max-height: 0;
    overflow: hidden;
    opacity: 0;
    transition: all 0.4s ease;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
    z-index: 999;
  }

  .nav-links.open {
    max-height: 500px;
    opacity: 1;
    padding: 0.5rem 0 1rem 0;
  }

  .nav-links li {
    width: 100%;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }

  .nav-links li:last-child {
    border-bottom: none;
  }

  .nav-links a {
    display: block;
    width: 100%;
    padding: 1.2rem 2rem;
    font-size: 1.1rem;
    color: white;
    text-decoration: none;
    transition: all 0.3s ease;
    border-left: 3px solid transparent;
    font-weight: 500;
  }

  .nav-links a:hover {
    background: rgba(255, 107, 129, 0.15);
    color: #ff6b81;
    border-left-color: #ff6b81;
    transform: translateX(5px);
  }
}

/* 480px 이하일 때: 텍스트 숨기고 이미지 보이기 */
@media (max-width: 480px) {
  .logo-text {
    display: none;
  }

  .logo-img {
    display: block;
  }
}
</style>
