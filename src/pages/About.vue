<template>
  <div class="about-container">

    <transition name="fade-title">
      <div v-if="show">
        <h1 class="title">About Us</h1>
      </div>
    </transition>

    <transition name="fade-content">
      <div v-if="show">
        <p class="description">
          select club you want to learn more
        </p>
      </div>
    </transition>

    <transition name="fade-content">
      <div v-if="show" class="selection-container">
        <router-link to="/clug" class="btn">CLUG</router-link>
        <router-link to="/zeropage" class="btn">ZeroPage</router-link>
      </div>
    </transition>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";

export default {
  name: "About",
  setup() {
    const show = ref(false);

    onMounted(() => {
      show.value = true;
    })
    return { show };
  },
};
</script>

<style scoped>

.description {
  font-size: clamp(1.2rem, 2.5vw, 2rem);
  max-width: 800px;
  margin: 0 auto;
  line-height: 1.6;
  opacity: 0.8;
  color: white;
}

.about-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.description {
  margin-bottom: 20px;
}

.selection-container {
  display: flex;
  justify-content: center;
  gap: clamp(15px, 5vw, 20px);
  margin-top: clamp(20px, 5vh, 40px);
}

.btn {
  width: clamp(70px, 20vw, 125px);
  height: clamp(20px, 6vh, 35px);
  font-size: clamp(1rem, 2.5vw, 1.2rem);
  color: white;
  text-decoration: none;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 15px rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease-in-out;
  border: none;
  cursor: pointer;
}

.btn:hover {
  background: rgba(255, 255, 255, 0.4);
  box-shadow: 0 6px 20px rgba(255, 255, 255, 0.2);
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
