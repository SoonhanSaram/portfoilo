import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:regist/models/reselvation_info.dart';

/*
 * extends 와 with 의 차이
 * extends 는 클래스를 상속받아 해당 클래스의 기능을 모두 사용하는 것
 * with 는 다른 클래스를 상속 받으면서도 해당 클래스의 기능을 사용 할 수 있는 것
 */

class LoginViewModel with ChangeNotifier {
  ReselInfo? reselInfo;

  LoginViewModel() {
    reselInfo = ReselInfo(user: "");
  }

  User? auth;
  GoogleSignInAccount? currentUser;
  String email = "";
  String password = "";

  // google 로그인을 수행하기 위한 초기화 함수
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  void changeUpdateValue(String fieldName, String value) {
    if (fieldName == "email") {
      email = value;
    } else if (fieldName == "password") {
      password = value;
    }
  }

  Future<void> loginUser(BuildContext context) async {
    try {
      currentUser = await GoogleSignIn().signIn();
      if (currentUser != null && currentUser?.displayName != null) {
        reselInfo?.user = currentUser!.displayName.toString();
      }

      final GoogleSignInAuthentication? googleAuth =
          await currentUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      notifyListeners();
    } catch (e) {
      String message = e.toString();
      print(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    await _googleSignIn.signInSilently();
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      auth = credential.user;
      reselInfo?.user = auth!.email ?? "";

      notifyListeners();
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
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut().then(
              (value) => auth = FirebaseAuth.instance.currentUser,
            );
        notifyListeners();
      }
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut().then(
              (value) => {
                reselInfo?.user = "",
                currentUser = null,
                print("${reselInfo?.user}  ,$currentUser"),
                notifyListeners(),
              },
            );
      }
      reselInfo?.user = "";

      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
