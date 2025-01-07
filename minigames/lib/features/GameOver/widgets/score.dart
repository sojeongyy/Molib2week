import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/ScoreManager.dart';
import '../../../core/colors.dart';

class Score extends StatefulWidget {
  final ScoreManager scoreManager;

  const Score({super.key, required this.scoreManager});

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  List<int> topScores = [];
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _submitScoreAndFetchTopScores(); // 초기화 시점에 점수 처리
  }

  Future<void> _submitScoreAndFetchTopScores() async {
    try {
      final score = widget.scoreManager.score;

      // 1. 스코어를 서버에 업로드
      await _submitScore(score);

      // 2. 상위 3개의 스코어를 가져옴
      final fetchedScores = await _fetchTopScores();

      // 점수 부족 시 0으로 채움
      while (fetchedScores.length < 3) {
        fetchedScores.add(0);
      }

      setState(() {
        topScores = fetchedScores;
        isLoading = false; // 로딩 완료
      });
    } catch (error) {
      print('오류 발생: $error');
      setState(() {
        isLoading = false; // 로딩 중단
      });
    }
  }

  Future<void> _submitScore(int score) async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) {
      throw Exception('사용자 ID를 찾을 수 없습니다.');
    }
    final response = await http.post(
      Uri.parse('$apiUrl/score/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId, // SharedPreferences에서 가져와야 함
        'score': score,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('스코어 업로드 실패: ${response.body}');
    }
  }

  Future<List<int>> _fetchTopScores() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) {
      throw Exception('사용자 ID를 찾을 수 없습니다.');
    }
    final response = await http.get(
      Uri.parse('$apiUrl/score/top3?userId=$userId'), // SharedPreferences에서 유저 ID 가져와야 함
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<int>.from(data['topScores'].map((score) => score['score']));
    } else {
      throw Exception('상위 점수 가져오기 실패: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = 280;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.customYellow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 10), // 아래 방향
            spreadRadius: 2,
          ),
        ],
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중 표시
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 타이틀 : SCOREBOARD
          Container(
            width: width,
            padding: const EdgeInsets.all(10), // 내부 여백 추가
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'SCORE : ${widget.scoreManager.score}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 정확히 3등분하는 상자
          Container(
            height: 171,
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: List.generate(
                topScores.length,
                    (index) => Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          topScores[index].toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (index < topScores.length - 1)
                        const Divider(
                          color: AppColors.customYellow,
                          thickness: 1.5,
                          height: 0,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

