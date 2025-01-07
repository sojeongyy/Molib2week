import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../core/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key});

  Future<List<int>> _fetchTopScores() async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) {
      throw Exception('사용자 ID를 찾을 수 없습니다.');
    }
    final response = await http.get(
      Uri.parse('$apiUrl/score/top3?userId=$userId'),
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
    double width = 290;

    return FutureBuilder<List<int>>(
      future: _fetchTopScores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // 로딩 상태 표시
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '오류 발생: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final scores = snapshot.data ?? [0, 0, 0];
          return Container(
            width: width,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.customYellow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SCOREBOARD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                      scores.length,
                          (index) => Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                scores[index].toString(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (index < scores.length - 1)
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
        } else {
          return const Center(
            child: Text('점수를 불러올 수 없습니다.'),
          );
        }
      },
    );
  }
}
