<template>
  <div class="event-container">
    <div class="content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">Mini Games</h1>
      </transition>
      
      <transition name="fade-description">
        <p v-if="show" class="description">소프트웨어 축제 박람회를 위한 기능들입니다</p>
      </transition>

      <transition name="fade-content">
        <div v-if="show" class="event-grid">
          <div class="event-card typing-game" @click="goToTypingGame">
            <div class="card-icon">⌨️</div>
            <h3>타자 빨리치기</h3>
            <p>빠르고 정확한 타이핑으로 최고 기록을 달성해보세요!</p>
            <div class="card-hover-effect"></div>
          </div>

          <div class="event-card tarot" @click="goToTarot">
            <div class="card-icon">🔮</div>
            <h3>타로 점보기</h3>
            <p>학업, 연애, 재물 운세를 타로카드로 알아보세요!</p>
            <div class="card-hover-effect"></div>
          </div>

          <div class="event-card battle" @click="goToCharacterBattle">
            <div class="card-icon">⚔️</div>
            <h3>캐릭터 배틀</h3>
            <p>나만의 캐릭터를 만들고 다른 캐릭터와 전투해보세요!</p>
            <div class="card-hover-effect"></div>
          </div>

          <!-- 향후 확장을 위한 더미 카드 -->
          <div class="event-card coming-soon">
            <div class="card-icon">🎮</div>
            <h3>Coming Soon</h3>
            <p>더 많은 재미있는 미니게임이 곧 출시됩니다!</p>
            <div class="coming-soon-overlay">
              <span>준비 중</span>
            </div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

export default {
  name: 'Event',
  setup() {
    const show = ref(false);
    const router = useRouter();

    const goToTypingGame = () => {
      router.push('/event/typing-game');
    };

    const goToTarot = () => {
      router.push('/event/tarot');
    };

    const goToCharacterBattle = () => {
      router.push('/event/character-battle');
    };

    onMounted(() => {
      setTimeout(() => {
        show.value = true;
      }, 100);
    });

    return {
      show,
      goToTypingGame,
      goToTarot,
      goToCharacterBattle
    };
  }
};
</script>

<style scoped>
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
  transform: translateY(20px);
}

.fade-description-enter-active {
  transition: opacity 1s ease 0.3s, transform 0.8s ease 0.3s;
}
.fade-description-enter-from {
  opacity: 0;
  transform: translateY(15px);
}

.event-container {
  min-height: calc(100vh - 80px);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: clamp(40px, 8vh, 80px) clamp(20px, 5vw, 40px);
  padding-top: 120px;
}

.content {
  max-width: 1200px;
  width: 100%;
  text-align: center;
}

.title {
  background: linear-gradient(45deg, #ff6b81, #ffb562, #a8e6cf, #88d8c0);
  font-size: clamp(2.5rem, 6vw, 4.5rem);
  font-weight: 800;
  margin-bottom: 1rem;
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 300%;
  animation: gradient 8s linear infinite;
}

.description {
  color: rgba(255, 255, 255, 0.8);
  font-size: clamp(1rem, 2.5vw, 1.3rem);
  font-weight: 400;
  margin-bottom: 3rem;
  text-align: center;
}

@keyframes gradient {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.event-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  max-width: 900px;
  margin: 0 auto;
}

.event-card {
  position: relative;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 2.5rem 2rem;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(15px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  overflow: hidden;
  text-align: center;
  min-height: 250px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.event-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.05), transparent);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.event-card:hover::before {
  opacity: 1;
}

.event-card:hover {
  transform: translateY(-8px) scale(1.02);
  border-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.4);
}

.card-icon {
  font-size: 4rem;
  margin-bottom: 1.5rem;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
}

.event-card h3 {
  color: white;
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
  background: linear-gradient(45deg, #ff6b81, #ffb562);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.event-card p {
  color: rgba(255, 255, 255, 0.8);
  font-size: 1rem;
  line-height: 1.6;
  margin: 0;
}

.typing-game:hover {
  background: rgba(255, 107, 129, 0.1);
}

.tarot:hover {
  background: rgba(136, 216, 192, 0.1);
}

.battle:hover {
  background: rgba(255, 69, 58, 0.1);
}

.coming-soon {
  position: relative;
  opacity: 0.6;
  cursor: not-allowed;
}

.coming-soon:hover {
  transform: none;
  border-color: rgba(255, 255, 255, 0.15);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.coming-soon-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 20px;
  backdrop-filter: blur(5px);
}

.coming-soon-overlay span {
  color: white;
  font-size: 1.2rem;
  font-weight: 600;
  padding: 0.5rem 1rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.card-hover-effect {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: all 0.6s ease;
  pointer-events: none;
}

.event-card:hover .card-hover-effect {
  width: 400px;
  height: 400px;
}

/* 모바일 대응 */
@media (max-width: 768px) {
  .event-container {
    padding: 100px 20px 40px;
  }

  .title {
    font-size: clamp(2rem, 8vw, 3rem);
    margin-bottom: 2rem;
  }

  .event-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .event-card {
    padding: 2rem 1.5rem;
    min-height: 200px;
  }

  .card-icon {
    font-size: 3rem;
    margin-bottom: 1rem;
  }

  .event-card h3 {
    font-size: 1.3rem;
  }

  .event-card p {
    font-size: 0.9rem;
  }
}

@media (max-width: 480px) {
  .event-card {
    padding: 1.5rem 1rem;
  }
  
  .card-icon {
    font-size: 2.5rem;
  }
}
</style>