import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:regist/dto/reselvation_info.dart';

/*
 * extends 와 with 의 차이
 * extends 는 클래스를 상속받아 해당 클래스의 기능을 모두 사용하는 것
 * with 는 다른 클래스를 상속 받으면서도 해당 클래스의 기능을 사용 할 수 있는 것
 */

class StaticViewModel with ChangeNotifier {
  static const String title = "Pick&Go";
  static const String pageTitle = "로그인 페이지";
  static const String loginButtonTitle = "이메일 로그인";
  static const String joinButtonTitle = "이메일 회원가입";
  static const String imageButtonTitle = "구글 로그인";
  static const String googleScopeEmail = "email";
  static const String googleScopeAddr = "https://www.googleapis.com/auth/contacts.readonly";
}

class LoginViewModel with ChangeNotifier {
  final String _email = "";
  final String _password = "";

  GoogleSignInAccount? _currentUser;
  late ReselInfo reselInfo = ReselInfo(user: "");

  late final GoogleSignInAccount? user = _currentUser;

  // google 로그인을 수행하기 위한 초기화 함수
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      StaticViewModel.googleScopeEmail,
      StaticViewModel.googleScopeAddr,
    ],
  );

  loginUser() {
    /**
     * google login 이 되면 google 로부터 event가 전달되고
     * event를 기다리다가 user 정보가 오면 _currentUser 에
     * GoogleSignInAccount 타입의 google login 정보를 저장
     */
    googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount? account) {
        _currentUser = account;
        reselInfo.user = account!.displayName ?? "";
        notifyListeners();
      },
    );
    googleSignIn.signInSilently();
  }

  Future<void> _login(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "user-not-found") {
        message = "가입되지 않은 이메일 입니다";
      } else if (e.code == "wrong-password") {
        message = "잘못된 비밀번호 입니다";
      } else {
        message = "알 수 없는 에러";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
