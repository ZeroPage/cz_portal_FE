# 프론트엔드 Dockerfile (Production)
FROM node:18-alpine

WORKDIR /app

# package.json과 package-lock.json 복사
COPY package*.json ./

# 의존성 설치
RUN npm ci --only=production

# 소스 코드 복사
COPY . .

# 빌드
RUN npm run build

# 포트 노출
EXPOSE 4173

# Vite preview 서버로 빌드된 파일 서빙
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "4173"]
