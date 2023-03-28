import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EmailRegist extends StatefulWidget {
  const EmailRegist({super.key});

  @override
  State<EmailRegist> createState() => _EmailRegistState();
}

class _EmailRegistState extends State<EmailRegist> {
  final String _email = "";
  final String _password = "";

  void _join() async {
    Firebase.initializeApp();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "weak-password") {
        message = "비밀번호가 보안에 취약합니다";
      } else if (e.code == "email-already-in-use") {
        message = "이미 사용중인 이메일입니다";
      } else {
        message = "예상치 못한 오류";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: Center(
        child: Column(
          children: [
            registInput(state: _email),
            registInput(labelText: "비밀번호를 입력해주세요", obscureText: true, state: _password),
            TextButton(
                onPressed: () {
                  _join();
                  Navigator.pop(context);
                },
                child: const Text("회원가입"))
          ],
        ),
      ),
    );
  }

  Card registInput({String labelText = "사용 할 Email을 입력해주세요", bool obscureText = false, String state = ""}) {
    return Card(
      child: TextFormField(
          onChanged: (value) {
            state = value;
            setState(() {});
          },
          decoration: InputDecoration(
            label: Text(
              labelText,
              style: const TextStyle(fontSize: 18),
            ),
          )),
    );
  }
}
