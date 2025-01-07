import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight, // ✅ 팝업 내 오른쪽 상단 정렬
      child: Padding(
        padding: const EdgeInsets.all(15.0), // ✅ 상단 및 우측 여백 추가
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.customYellow, // ✅ 노란색 원형 배경
            shape: BoxShape.circle, // ✅ 원형 버튼
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 3),
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(); // ✅ 팝업 닫기
            },
            icon: const Icon(Icons.close, color: Colors.white, size: 30), // ✅ X 아이콘
            padding: const EdgeInsets.all(15.0), // 아이콘 크기 조정
          ),
        ),
      ),
    );
  }
}
