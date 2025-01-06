# Node.js 이미지 사용
FROM node:16

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json 복사
COPY ./app/package.json ./package.json
COPY ./app/package-lock.json ./package-lock.json
# 의존성 설치
RUN npm install

# 소스 코드 복사
COPY ./app .

# 애플리케이션 실행
CMD ["npm", "start"]

# 컨테이너에서 열리는 포트
EXPOSE 3000
