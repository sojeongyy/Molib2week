const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../db'); // db.js에서 Connection Pool 가져오기

const router = express.Router();

// 회원가입 API
router.post('/register', async (req, res) => {
  const { username, password, nickname } = req.body;

  if (!username || !password || !nickname) {
    return res.status(400).json({ message: '모든 필드를 입력하세요.' });
  }

  try {
    // MySQL 연결 가져오기
    const connection = await pool.getConnection();

    // 중복 사용자 확인
    const [rows] = await connection.query(
      `SELECT COUNT(*) AS count FROM users WHERE username = ?`,
      [username]
    );

    if (rows[0].count > 0) {
      connection.release(); // 연결 반환
      return res.status(400).json({ message: '이미 존재하는 아이디입니다.' });
    }

    // 비밀번호 해싱
    const hashedPassword = await bcrypt.hash(password, 10);

    // 사용자 데이터 삽입
    await connection.query(
      `INSERT INTO users (username, password_hash, nickname) VALUES (?, ?, ?)`,
      [username, hashedPassword, nickname]
    );

    connection.release(); // 연결 반환
    res.status(201).json({ message: '회원가입 성공!' });
  } catch (error) {
    console.error('회원가입 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

module.exports = router;
