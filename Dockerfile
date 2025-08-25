# 1단계: 빌드 환경 (Builder Stage)
# 모든 의존성을 설치하고 앱을 빌드합니다.
FROM node:18-alpine AS builder

# 앱 디렉터리 설정
WORKDIR /app

# package.json과 package-lock.json 복사 (캐시 활용)
COPY package*.json ./

# 모든 의존성 설치 (개발 + 프로덕션)
RUN npm ci

# 소스 코드 복사
COPY . .

# 프로덕션용 빌드
RUN npm run build

# 2단계: 실행 환경 (Production Stage)
# 빌드 결과물과 프로덕션 의존성만 복사하여 이미지 크기를 최소화합니다.
FROM node:18-alpine

# 앱 디렉터리 설정
WORKDIR /app

# 빌드 단계에서 생성된 dist 폴더만 복사
COPY --from=builder /app/dist ./

# serve 패키지 설치
RUN npm install -g serve

# 포트 노출
EXPOSE 4173

# 프로덕션 서버 실행
CMD ["serve", "dist", "-l", "4173", "--single"]