const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../db'); // db.js에서 Connection Pool 가져오기

const router = express.Router();

// 일반 로그인 API
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: '아이디와 비밀번호를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 사용자 조회
    const [rows] = await connection.query(
      `SELECT * FROM users WHERE username = ?`,
      [username]
    );

    connection.release();

    if (rows.length === 0) {
      return res.status(401).json({ message: '존재하지 않는 아이디입니다.' });
    }

    const user = rows[0];

    // 비밀번호 검증
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);

    if (!isPasswordValid) {
      return res.status(401).json({ message: '비밀번호가 일치하지 않습니다.' });
    }

    res.status(200).json({
      message: '로그인 성공!',
      user: {
        id: user.id,
        username: user.username,
        nickname: user.nickname,
        is_kakao_linked: !!user.is_kakao_linked,
      },
    });
  } catch (error) {
    console.error('로그인 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

// 회원가입 API
router.post('/register', async (req, res) => {
  const { username, password, nickname } = req.body;

  if (!username || !password || !nickname) {
    return res.status(400).json({ message: '모든 필드를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 아이디 중복 확인
    const [rows] = await connection.query(
      `SELECT COUNT(*) AS count FROM users WHERE username = ?`,
      [username]
    );

    if (rows[0].count > 0) {
      connection.release();
      return res.status(400).json({ message: '이미 존재하는 아이디입니다.' });
    }

    // 비밀번호 해싱
    const hashedPassword = await bcrypt.hash(password, 10);

    // 사용자 데이터 삽입
    await connection.query(
      `INSERT INTO users (username, password_hash, nickname) VALUES (?, ?, ?)`,
      [username, hashedPassword, nickname]
    );

    connection.release();
    res.status(201).json({ message: '회원가입 성공!' });
  } catch (error) {
    console.error('회원가입 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

// 카카오 로그인 API
router.post('/kakao/login', async (req, res) => {
  const { kakaoId } = req.body;

  if (!kakaoId) {
    return res.status(400).json({ message: '카카오 ID를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 카카오 ID로 사용자 조회
    const [rows] = await connection.query(
      `SELECT * FROM users WHERE kakao_id = ?`,
      [kakaoId]
    );

    if (rows.length > 0) {
      // 기존 사용자 로그인 처리
      const user = rows[0];
      connection.release();
      return res.status(200).json({
        message: '로그인 성공!',
        user: {
          id: user.id,
          kakaoId: user.kakao_id,
          username: user.username,
          nickname: user.nickname,
          is_kakao_linked: !!user.is_kakao_linked,
        },
      });
    }

    // 카카오 ID가 없으면 회원가입 유도
    connection.release();
    return res.status(404).json({ message: '회원가입이 필요합니다.' });
  } catch (error) {
    console.error('카카오 로그인 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

// 카카오 회원가입 API
router.post('/kakao/register', async (req, res) => {
  const { kakaoId, username, password, nickname } = req.body;

  if (!kakaoId || !username || !password || !nickname) {
    return res.status(400).json({ message: '모든 필드를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 아이디 중복 확인
    const [existingUsername] = await connection.query(
      `SELECT COUNT(*) AS count FROM users WHERE username = ?`,
      [username]
    );

    if (existingUsername[0].count > 0) {
      connection.release();
      return res.status(400).json({ message: '이미 존재하는 아이디입니다.' });
    }

    // 비밀번호 해싱
    const hashedPassword = await bcrypt.hash(password, 10);

    // 새로운 사용자 추가 (is_kakao_linked = TRUE)
    await connection.query(
      `INSERT INTO users (kakao_id, username, password_hash, nickname, is_kakao_linked) VALUES (?, ?, ?, ?, TRUE)`,
      [kakaoId, username, hashedPassword, nickname]
    );

    connection.release();
    res.status(201).json({ message: '회원가입 성공!' });
  } catch (error) {
    console.error('카카오 회원가입 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

// 카카오 연동하기 API
router.post('/kakao/link', async (req, res) => {
  const { userId, kakaoId } = req.body;

  if (!userId || !kakaoId) {
    return res.status(400).json({ message: '유저 ID와 카카오 ID를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 동일한 kakao_id가 이미 다른 계정에 존재하는지 확인
    const [existingKakaoId] = await connection.query(
      `SELECT username FROM users WHERE kakao_id = ?`,
      [kakaoId]
    );

    if (existingKakaoId.length > 0) {
      connection.release();
      return res.status(400).json({
        message: '다른 계정에서 이미 연동된 카카오 계정입니다.',
      });
    }

    // 유저 데이터 업데이트
    await connection.query(
      `UPDATE users SET kakao_id = ?, is_kakao_linked = TRUE WHERE username = ?`,
      [kakaoId, userId]
    );

    connection.release();
    res.status(200).json({ message: '카카오 연동이 완료되었습니다.' });
  } catch (error) {
    console.error('카카오 연동 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

// 카카오 연결 해제 API
router.post('/kakao/unlink', async (req, res) => {
  const { userId } = req.body;

  if (!userId) {
    return res.status(400).json({ message: '유저 ID를 입력하세요.' });
  }

  try {
    const connection = await pool.getConnection();

    // 유저 데이터 초기화
    await connection.query(
      `UPDATE users SET kakao_id = NULL, is_kakao_linked = FALSE WHERE username = ?`,
      [userId]
    );

    connection.release();
    res.status(200).json({ message: '카카오 연결이 해제되었습니다.' });
  } catch (error) {
    console.error('카카오 연결 해제 오류:', error);
    res.status(500).json({ message: '서버 오류가 발생했습니다.' });
  }
});

module.exports = router;
