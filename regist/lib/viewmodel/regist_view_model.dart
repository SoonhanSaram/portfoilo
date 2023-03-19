import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistViewModel with ChangeNotifier {
  late String email = "";
  late String password = "";

  void emailRegist() {
    var acs = ActionCodeSettings(url: "");
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "acoount-exists-with-different-credential") {
        message;
      }
    }
  }
}
