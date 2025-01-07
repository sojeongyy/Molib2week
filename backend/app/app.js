const express = require('express');
const app = express();
require('dotenv').config();

const authRoutes = require('./routes/auth'); // routes/auth.js 연결
const scoreRoutes = require('./routes/score'); // routes/score.js 연결
const pool = require('./db'); // db.js에서 MySQL 연결 가져오기

// Middleware
app.use(express.json());

// Test MySQL connection
app.get('/test-db', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT NOW()'); // 현재 시간을 가져오는 쿼리
    res.json({ message: 'DB 연결 성공!', current_time: rows[0].current_time });
  } catch (err) {
    console.error('DB 연결 오류:', err.message);
    res.status(500).json({ error: 'DB 연결 실패' });
  }
});

// Routes
app.use('/auth', authRoutes); // auth.js 라우터 사용
app.use('/score', scoreRoutes); // score.js 라우터 사용

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
