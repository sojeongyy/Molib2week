import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/colors.dart';
import 'cancel_button.dart';
import 'kakao_button.dart';
import 'logout_button.dart';

class ProfilePopupPage extends StatefulWidget {
  final String nickname;
  final bool isKakaoLinked;
  final VoidCallback onKakaoLink;
  final VoidCallback onKakaoUnlink;

  const ProfilePopupPage({
    Key? key,
    required this.nickname,
    required this.isKakaoLinked,
    required this.onKakaoLink,
    required this.onKakaoUnlink,
  }) : super(key: key);

  @override
  _ProfilePopupPageState createState() => _ProfilePopupPageState();
}

class _ProfilePopupPageState extends State<ProfilePopupPage> {
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfileImageUrl();
  }

  Future<void> _loadProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImageUrl = prefs.getString('profileImageUrl') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.customBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.all(60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 240, // 팝업 최대 너비 조정
          maxHeight: 400, // 팝업 최대 높이 조정
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.nickname,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    KakaoButton(
                      isKakaoLinked: widget.isKakaoLinked,
                      onKakaoLink: widget.onKakaoLink,
                      onKakaoUnlink: widget.onKakaoUnlink,
                    ),
                    const SizedBox(height: 10),
                    LogoutButton(),
                  ],
                ),
              ),
            ),
            const CancelButton(),
          ],
        ),
      ),
    );
  }
}
