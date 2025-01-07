const express = require('express');
const router = express.Router();
const pool = require('../db'); // db.js에서 MySQL 연결 가져오기

// 새로운 스코어 추가 API
router.post('/add', async (req, res) => {
  const { userId, score } = req.body;

  if (!userId || score === undefined) {
    return res.status(400).json({ message: '유저 ID와 점수를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 새로운 스코어 추가
    await connection.query(
      'INSERT INTO user_scores (user_id, score) VALUES (?, ?)',
      [userId, score]
    );

    connection.release();
    res.status(201).json({ message: '점수가 추가되었습니다.' });
  } catch (error) {
    console.error('점수 추가 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

// 개인 상위 3개의 점수 가져오기 API
router.get('/top3', async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ message: '유저 ID를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 상위 3개 점수 가져오기
    const [rows] = await connection.query(
      'SELECT score FROM user_scores WHERE user_id = ? ORDER BY score DESC LIMIT 3',
      [userId]
    );

    connection.release();
    res.status(200).json({ topScores: rows });
  } catch (error) {
    console.error('상위 점수 가져오기 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

module.exports = router;
