import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StaticViewModel with ChangeNotifier {
  static const String title = "Pick&Go";
  static const String pageTitle = "로그인 페이지";
  static const String loginButtonTitle = "이메일 로그인";
  static const String joinButtonTitle = "이메일 회원가입";
  static const String imageButtonTitle = "구글 로그인";
  static const String googleScopeEmail = "email";
  static const String googleScopeAddr =
      "https://www.googleapis.com/auth/contacts.readonly";
}

class LoginViewModel with ChangeNotifier {
  // google 로그인을 수행하기 위한 초기화 함수
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      StaticViewModel.googleScopeEmail,
      StaticViewModel.googleScopeAddr,
    ],
  );
}
