const mysql = require('mysql2/promise');

// MySQL 연결 풀 설정
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',   // DB 호스트
  user: process.env.DB_USER || 'root',        // DB 사용자 이름
  password: process.env.DB_PASSWORD || 'password', // DB 비밀번호
  database: process.env.DB_NAME || 'my_database',  // DB 이름
  charset: 'utf8mb4',
  waitForConnections: true,
  connectionLimit: 10, // 최대 연결 수
  queueLimit: 0,
});

// 연결 테스트 (선택)
(async () => {
  try {
    const connection = await pool.getConnection();
    console.log('MySQL 연결 성공!');
    connection.release();
  } catch (err) {
    console.error('MySQL 연결 실패:', err.message);
  }
})();

module.exports = pool;
