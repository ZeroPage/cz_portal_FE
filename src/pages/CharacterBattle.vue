<template>
  <div class="character-battle-container">
    <div class="content">
      <transition name="fade-title">
        <h1 v-if="show" class="title">⚔️ 캐릭터 배틀</h1>
      </transition>

      <!-- 탭 네비게이션 -->
      <transition name="fade-content">
        <div v-if="show" class="tab-navigation">
          <button 
            :class="['tab-btn', { active: activeTab === 'create' }]"
            @click="activeTab = 'create'"
          >
            캐릭터 생성
          </button>
          <button 
            :class="['tab-btn', { active: activeTab === 'battle' }]"
            @click="activeTab = 'battle'"
          >
            전투
          </button>
          <button 
            :class="['tab-btn', { active: activeTab === 'ranking' }]"
            @click="activeTab = 'ranking'"
          >
            순위
          </button>
        </div>
      </transition>

      <!-- 캐릭터 생성 탭 -->
      <transition name="fade-content">
        <div v-if="show && activeTab === 'create'" class="create-section">
          <div class="create-card">
            <h3>새로운 캐릭터 만들기</h3>
            <form @submit.prevent="createCharacter" class="character-form">
              <div class="form-group">
                <label for="characterName">캐릭터 이름</label>
                <input
                  id="characterName"
                  v-model="newCharacter.name"
                  type="text"
                  placeholder="캐릭터 이름을 입력하세요 (최대 100자)"
                  maxlength="100"
                  required
                />
              </div>
              
              <div class="form-group">
                <label for="characterDescription">캐릭터 설정/스토리</label>
                <textarea
                  id="characterDescription"
                  v-model="newCharacter.description"
                  placeholder="캐릭터의 배경, 능력, 특징 등을 자세히 설명해주세요. 더 자세할수록 전투에서 유리합니다!"
                  rows="6"
                  required
                ></textarea>
              </div>
              
              <div class="form-group">
                <label for="characterContact">연락처</label>
                <input
                  id="characterContact"
                  v-model="newCharacter.contact"
                  type="text"
                  placeholder="상위 랭커 상품 수령을 위한 연락처 (카카오톡 ID, 디스코드 등)"
                  required
                />
                <small class="contact-info">
                  🏆 1, 2, 3등 상품 지급을 위한 연락처입니다. 행사 종료 후 파기됩니다.
                </small>
              </div>
              
              <button 
                type="submit" 
                :disabled="isCreating"
                class="create-btn"
              >
                <span v-if="isCreating">생성 중...</span>
                <span v-else>캐릭터 생성</span>
              </button>
            </form>
            
            <div v-if="createMessage" :class="['message', createMessageType]">
              {{ createMessage }}
            </div>
          </div>
        </div>
      </transition>

      <!-- 전투 탭 -->
      <transition name="fade-content">
        <div v-if="show && activeTab === 'battle'" class="battle-section">
          <!-- 캐릭터 선택 -->
          <div v-if="!selectedCharacter && !battleResult" class="character-selection">
            <h3>전투할 캐릭터를 선택하세요</h3>
            <div v-if="loadingCharacters" class="loading">
              <div class="spinner"></div>
              <p>캐릭터 목록을 불러오는 중...</p>
            </div>
            <div v-else-if="characters.length === 0" class="no-characters">
              <p>아직 생성된 캐릭터가 없습니다.</p>
              <button @click="activeTab = 'create'" class="create-first-btn">
                첫 캐릭터 만들기
              </button>
            </div>
            <div v-else class="character-grid">
              <div 
                v-for="character in characters" 
                :key="character.id"
                class="character-card"
                @click="selectCharacterForBattle(character)"
              >
                <h4>{{ character.name }}</h4>
                <p class="character-desc">{{ character.description.substring(0, 80) }}...</p>
                <div class="character-stats">
                  <span class="elo">ELO: {{ character.eloRating }}</span>
                  <span class="record">{{ character.wins }}승 {{ character.losses }}패</span>
                  <span class="winrate">승률: {{ character.winRate }}%</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 전투 진행 중 -->
          <div v-if="selectedCharacter && !battleResult && isBattling" class="battle-loading">
            <div class="battle-animation">
              <div class="fighter fighter-1">
                <h4>{{ selectedCharacter.name }}</h4>
                <div class="character-avatar">⚔️</div>
              </div>
              <div class="vs">VS</div>
              <div class="fighter fighter-2">
                <h4>???</h4>
                <div class="character-avatar">🛡️</div>
              </div>
            </div>
            <div class="loading-text">
              <div class="spinner"></div>
              <p>전투 중...</p>
              <small>AI가 전투를 시뮬레이션하고 있습니다. 잠시만 기다려주세요.</small>
            </div>
          </div>

          <!-- 전투 결과 -->
          <div v-if="battleResult" class="battle-result">
            <h3>⚔️ 전투 결과</h3>
            
            <div class="battle-summary">
              <div class="fighters">
                <div class="fighter-result">
                  <h4>{{ battleResult.character1.name }}</h4>
                  <div class="elo-change">
                    {{ battleResult.character1EloBeforeBattle }} 
                    → {{ battleResult.character1EloAfterBattle }}
                    <span :class="getEloChangeClass(battleResult.character1EloAfterBattle - battleResult.character1EloBeforeBattle)">
                      ({{ battleResult.character1EloAfterBattle > battleResult.character1EloBeforeBattle ? '+' : '' }}{{ battleResult.character1EloAfterBattle - battleResult.character1EloBeforeBattle }})
                    </span>
                  </div>
                </div>
                
                <div class="vs-result">
                  <div class="winner-crown" v-if="battleResult.winner.id === battleResult.character1.id">👑</div>
                  <span>VS</span>
                  <div class="winner-crown" v-if="battleResult.winner.id === battleResult.character2.id">👑</div>
                </div>
                
                <div class="fighter-result">
                  <h4>{{ battleResult.character2.name }}</h4>
                  <div class="elo-change">
                    {{ battleResult.character2EloBeforeBattle }} 
                    → {{ battleResult.character2EloAfterBattle }}
                    <span :class="getEloChangeClass(battleResult.character2EloAfterBattle - battleResult.character2EloBeforeBattle)">
                      ({{ battleResult.character2EloAfterBattle > battleResult.character2EloBeforeBattle ? '+' : '' }}{{ battleResult.character2EloAfterBattle - battleResult.character2EloBeforeBattle }})
                    </span>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="winner-announcement">
              🏆 승자: <strong>{{ battleResult.winner.name }}</strong>
            </div>
            
            <div class="battle-description">
              <h4>전투 스토리</h4>
              <p>{{ battleResult.battleDescription }}</p>
            </div>
            
            <div class="battle-actions">
              <button @click="resetBattle" class="new-battle-btn">새로운 전투</button>
              <button @click="activeTab = 'ranking'" class="view-ranking-btn">순위 보기</button>
            </div>
          </div>
        </div>
      </transition>

      <!-- 순위 탭 -->
      <transition name="fade-content">
        <div v-if="show && activeTab === 'ranking'" class="ranking-section">
          <h3>🏆 캐릭터 순위</h3>
          
          <div class="ranking-controls">
            <select v-model="rankingOrderBy" @change="loadRanking" class="order-select">
              <option value="eloRating">ELO 순위</option>
              <option value="wins">승수 순위</option>
              <option value="winRate">승률 순위</option>
            </select>
          </div>
          
          <div v-if="loadingRanking" class="loading">
            <div class="spinner"></div>
            <p>순위를 불러오는 중...</p>
          </div>
          
          <div v-else class="ranking-list">
            <div 
              v-for="(character, index) in ranking" 
              :key="character.id"
              :class="['ranking-item', { 'top-3': index < 3 }]"
            >
              <div class="rank-number">
                <span v-if="index === 0">🥇</span>
                <span v-else-if="index === 1">🥈</span>
                <span v-else-if="index === 2">🥉</span>
                <span v-else>{{ index + 1 }}</span>
              </div>
              <div class="character-info">
                <h4>{{ character.name }}</h4>
                <p>{{ character.description.substring(0, 60) }}...</p>
              </div>
              <div class="character-stats">
                <div class="stat">
                  <span class="label">ELO</span>
                  <span class="value">{{ character.eloRating }}</span>
                </div>
                <div class="stat">
                  <span class="label">전적</span>
                  <span class="value">{{ character.wins }}승 {{ character.losses }}패</span>
                </div>
                <div class="stat">
                  <span class="label">승률</span>
                  <span class="value">{{ character.winRate }}%</span>
                </div>
              </div>
            </div>
            
            <div v-if="ranking.length === 0" class="no-ranking">
              <p>아직 순위에 등록된 캐릭터가 없습니다.</p>
            </div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { API_ROOT } from '@/api.js';

export default {
  name: 'CharacterBattle',
  setup() {
    const show = ref(false);
    const activeTab = ref('create');
    
    // 캐릭터 생성 관련
    const newCharacter = ref({
      name: '',
      description: '',
      contact: ''
    });
    const isCreating = ref(false);
    const createMessage = ref('');
    const createMessageType = ref('');
    
    // 전투 관련
    const characters = ref([]);
    const selectedCharacter = ref(null);
    const battleResult = ref(null);
    const isBattling = ref(false);
    const loadingCharacters = ref(false);
    
    // 순위 관련
    const ranking = ref([]);
    const loadingRanking = ref(false);
    const rankingOrderBy = ref('eloRating');

    // 캐릭터 생성
    const createCharacter = async () => {
      if (!newCharacter.value.name || !newCharacter.value.description || !newCharacter.value.contact) {
        createMessage.value = '모든 필드를 입력해주세요.';
        createMessageType.value = 'error';
        return;
      }

      isCreating.value = true;
      createMessage.value = '';

      try {
        const response = await fetch(`${API_ROOT}/characters`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(newCharacter.value)
        });

        const result = await response.json();

        if (response.ok) {
          createMessage.value = `캐릭터 "${result.name}"가 성공적으로 생성되었습니다!`;
          createMessageType.value = 'success';
          
          // 폼 초기화
          newCharacter.value = {
            name: '',
            description: '',
            contact: ''
          };
          
          // 캐릭터 목록 새로고침
          await loadCharacters();
          
        } else {
          if (response.status === 409) {
            createMessage.value = '이미 존재하는 캐릭터 이름입니다. 다른 이름을 사용해주세요.';
          } else {
            createMessage.value = result.message || '캐릭터 생성에 실패했습니다.';
          }
          createMessageType.value = 'error';
        }
      } catch (error) {
        console.error('캐릭터 생성 오류:', error);
        createMessage.value = '네트워크 오류가 발생했습니다.';
        createMessageType.value = 'error';
      } finally {
        isCreating.value = false;
      }
    };

    // 캐릭터 목록 로드
    const loadCharacters = async () => {
      loadingCharacters.value = true;
      try {
        const response = await fetch(`${API_ROOT}/characters`);
        const result = await response.json();
        
        if (response.ok) {
          characters.value = result;
        }
      } catch (error) {
        console.error('캐릭터 목록 로드 오류:', error);
      } finally {
        loadingCharacters.value = false;
      }
    };

    // 전투할 캐릭터 선택
    const selectCharacterForBattle = async (character) => {
      selectedCharacter.value = character;
      isBattling.value = true;
      
      try {
        const response = await fetch(`${API_ROOT}/characters/battle`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            characterId: character.id
          })
        });

        const result = await response.json();

        if (response.ok) {
          battleResult.value = result;
          // 캐릭터 목록과 순위 새로고침
          await loadCharacters();
          await loadRanking();
        } else {
          alert(result.message || '전투를 시작할 수 없습니다.');
          resetBattle();
        }
      } catch (error) {
        console.error('전투 오류:', error);
        alert('네트워크 오류가 발생했습니다.');
        resetBattle();
      } finally {
        isBattling.value = false;
      }
    };

    // 순위 로드
    const loadRanking = async () => {
      loadingRanking.value = true;
      try {
        const response = await fetch(`${API_ROOT}/characters/ranking?orderBy=${rankingOrderBy.value}&limit=20`);
        const result = await response.json();
        
        if (response.ok) {
          ranking.value = result;
        }
      } catch (error) {
        console.error('순위 로드 오류:', error);
      } finally {
        loadingRanking.value = false;
      }
    };

    // 전투 초기화
    const resetBattle = () => {
      selectedCharacter.value = null;
      battleResult.value = null;
      isBattling.value = false;
    };

    // ELO 변화량 클래스
    const getEloChangeClass = (change) => {
      return change > 0 ? 'elo-up' : 'elo-down';
    };

    onMounted(() => {
      setTimeout(() => {
        show.value = true;
      }, 100);
      
      loadCharacters();
      loadRanking();
    });

    return {
      show,
      activeTab,
      newCharacter,
      isCreating,
      createMessage,
      createMessageType,
      characters,
      selectedCharacter,
      battleResult,
      isBattling,
      loadingCharacters,
      ranking,
      loadingRanking,
      rankingOrderBy,
      createCharacter,
      loadCharacters,
      selectCharacterForBattle,
      loadRanking,
      resetBattle,
      getEloChangeClass
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

.character-battle-container {
  min-height: calc(100vh - 80px);
  padding: 120px 20px 40px;
  max-width: 1400px;
  margin: 0 auto;
}

.content {
  width: 100%;
}

.title {
  background: linear-gradient(45deg, #ff4545, #ff8a00, #ffd700);
  font-size: clamp(2rem, 5vw, 3.5rem);
  font-weight: 800;
  margin-bottom: 2rem;
  text-align: center;
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 300%;
  animation: gradient 8s linear infinite;
}

@keyframes gradient {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.tab-navigation {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 3rem;
}

.tab-btn {
  padding: 1rem 2rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1rem;
  font-weight: 600;
}

.tab-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.tab-btn.active {
  background: linear-gradient(45deg, #ff4545, #ff8a00);
  border-color: #ff4545;
  box-shadow: 0 4px 15px rgba(255, 69, 69, 0.4);
}

.create-card {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 2.5rem;
  backdrop-filter: blur(15px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  max-width: 600px;
  margin: 0 auto;
}

.create-card h3 {
  color: white;
  margin-bottom: 2rem;
  text-align: center;
  font-size: 1.5rem;
}

.character-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  color: white;
  font-weight: 600;
  font-size: 1rem;
}

.form-group input,
.form-group textarea {
  padding: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
  font-family: inherit;
}

.form-group input::placeholder,
.form-group textarea::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #ff4545;
  box-shadow: 0 0 0 3px rgba(255, 69, 69, 0.2);
}

.form-group textarea {
  resize: vertical;
  min-height: 120px;
}

.contact-info {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.8rem;
  margin-top: 0.5rem;
}

.create-btn {
  padding: 1rem 2rem;
  background: linear-gradient(45deg, #ff4545, #ff8a00);
  border: none;
  border-radius: 10px;
  color: white;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 1rem;
}

.create-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(255, 69, 69, 0.4);
}

.create-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.message {
  margin-top: 1rem;
  padding: 1rem;
  border-radius: 10px;
  text-align: center;
  font-weight: 600;
}

.message.success {
  background: rgba(76, 175, 80, 0.2);
  border: 1px solid rgba(76, 175, 80, 0.5);
  color: #4CAF50;
}

.message.error {
  background: rgba(244, 67, 54, 0.2);
  border: 1px solid rgba(244, 67, 54, 0.5);
  color: #F44336;
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  padding: 2rem;
  color: white;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-left: 4px solid #ff4545;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.character-selection h3 {
  color: white;
  text-align: center;
  margin-bottom: 2rem;
  font-size: 1.3rem;
}

.no-characters {
  text-align: center;
  color: white;
  padding: 2rem;
}

.create-first-btn {
  padding: 1rem 2rem;
  background: linear-gradient(45deg, #ff4545, #ff8a00);
  border: none;
  border-radius: 10px;
  color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 1rem;
}

.character-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.character-card {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 15px;
  padding: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.character-card:hover {
  transform: translateY(-5px);
  border-color: #ff4545;
  box-shadow: 0 8px 25px rgba(255, 69, 69, 0.3);
}

.character-card h4 {
  color: white;
  margin-bottom: 0.5rem;
  font-size: 1.2rem;
}

.character-desc {
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 1rem;
  font-size: 0.9rem;
  line-height: 1.4;
}

.character-stats {
  display: flex;
  gap: 1rem;
  font-size: 0.8rem;
}

.character-stats span {
  color: rgba(255, 255, 255, 0.9);
  padding: 0.3rem 0.6rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 5px;
}

.battle-loading {
  text-align: center;
  padding: 3rem 2rem;
}

.battle-animation {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 2rem;
}

.fighter {
  text-align: center;
  animation: bounce 2s infinite;
}

.fighter h4 {
  color: white;
  margin-bottom: 1rem;
}

.character-avatar {
  font-size: 3rem;
  animation: pulse 1.5s infinite;
}

.vs {
  color: #ff4545;
  font-size: 2rem;
  font-weight: 800;
  animation: glow 2s infinite;
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-10px); }
  60% { transform: translateY(-5px); }
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}

@keyframes glow {
  0%, 100% { text-shadow: 0 0 5px #ff4545; }
  50% { text-shadow: 0 0 20px #ff4545, 0 0 30px #ff4545; }
}

.loading-text {
  color: white;
}

.loading-text p {
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
}

.loading-text small {
  color: rgba(255, 255, 255, 0.7);
}

.battle-result {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 2.5rem;
  backdrop-filter: blur(15px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  max-width: 800px;
  margin: 0 auto;
}

.battle-result h3 {
  color: white;
  text-align: center;
  margin-bottom: 2rem;
  font-size: 1.5rem;
}

.battle-summary {
  margin-bottom: 2rem;
}

.fighters {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
}

.fighter-result {
  flex: 1;
  text-align: center;
}

.fighter-result h4 {
  color: white;
  margin-bottom: 1rem;
  font-size: 1.2rem;
}

.elo-change {
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.9rem;
}

.elo-up {
  color: #4CAF50;
  font-weight: 600;
}

.elo-down {
  color: #F44336;
  font-weight: 600;
}

.vs-result {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.2rem;
  color: white;
  font-weight: 600;
}

.winner-crown {
  font-size: 2rem;
  animation: bounce 1s infinite;
}

.winner-announcement {
  text-align: center;
  font-size: 1.3rem;
  color: #ffd700;
  margin-bottom: 2rem;
  padding: 1rem;
  background: rgba(255, 215, 0, 0.1);
  border-radius: 10px;
  border: 1px solid rgba(255, 215, 0, 0.3);
}

.battle-description {
  margin-bottom: 2rem;
}

.battle-description h4 {
  color: white;
  margin-bottom: 1rem;
  font-size: 1.1rem;
}

.battle-description p {
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.6;
  font-size: 1rem;
  background: rgba(255, 255, 255, 0.05);
  padding: 1.5rem;
  border-radius: 10px;
}

.battle-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.new-battle-btn,
.view-ranking-btn {
  padding: 1rem 2rem;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-weight: 600;
}

.new-battle-btn {
  background: linear-gradient(45deg, #ff4545, #ff8a00);
  color: white;
}

.view-ranking-btn {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.new-battle-btn:hover,
.view-ranking-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
}

.ranking-section h3 {
  color: white;
  text-align: center;
  margin-bottom: 2rem;
  font-size: 1.5rem;
}

.ranking-controls {
  display: flex;
  justify-content: center;
  margin-bottom: 2rem;
}

.order-select {
  padding: 0.8rem 1.5rem;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  color: white;
  cursor: pointer;
}

.ranking-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.ranking-item {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 15px;
  padding: 1.5rem;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.ranking-item.top-3 {
  border-color: #ffd700;
  background: rgba(255, 215, 0, 0.1);
}

.ranking-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

.rank-number {
  font-size: 1.5rem;
  font-weight: 700;
  min-width: 60px;
  text-align: center;
  color: white;
}

.character-info {
  flex: 1;
}

.character-info h4 {
  color: white;
  margin-bottom: 0.5rem;
  font-size: 1.1rem;
}

.character-info p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
}

.character-stats {
  display: flex;
  gap: 1rem;
}

.stat {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.3rem;
}

.stat .label {
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.8rem;
}

.stat .value {
  color: white;
  font-weight: 600;
  font-size: 0.9rem;
}

.no-ranking {
  text-align: center;
  color: white;
  padding: 2rem;
}

/* 모바일 대응 */
@media (max-width: 768px) {
  .character-battle-container {
    padding: 100px 15px 30px;
  }

  .tab-navigation {
    flex-direction: column;
    align-items: center;
    gap: 0.5rem;
  }

  .tab-btn {
    width: 200px;
  }

  .create-card {
    padding: 2rem 1.5rem;
  }

  .character-grid {
    grid-template-columns: 1fr;
  }

  .fighters {
    flex-direction: column;
    gap: 1rem;
  }

  .battle-actions {
    flex-direction: column;
  }

  .ranking-item {
    flex-direction: column;
    text-align: center;
    gap: 1rem;
  }

  .character-stats {
    justify-content: center;
  }
}
</style>