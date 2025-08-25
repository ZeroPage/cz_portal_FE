# 1단계: 빌드 환경 (Builder Stage)
FROM node:18-alpine AS builder

# 앱 디렉터리 설정
WORKDIR /app

# 패키지 파일 복사 (캐시 활용)
COPY package*.json ./

# 모든 의존성 설치
RUN npm ci

# 소스 코드 복사
COPY . .

# 프로덕션용 빌드
RUN npm run build

# 2단계: 실행 환경 (Production Stage)
FROM node:18-alpine

# 앱 디렉터리 설정
WORKDIR /app

# 빌드 단계에서 생성된 빌드 결과물과 패키지 파일만 복사
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json

# 프로덕션 의존성만 설치
RUN npm ci

# 포트 노출
EXPOSE 4173

# 프로덕션 서버 실행 (serve 패키지 사용)
RUN npm install -g serve
CMD ["serve", "dist", "-l", "4173"]