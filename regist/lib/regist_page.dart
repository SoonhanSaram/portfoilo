import 'package:flutter/material.dart';
import 'package:regist/calendar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, this.reselInfo});
  final reselInfo;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2186D1),
          borderRadius: BorderRadius.circular(16.0), // Container의 모서리를 둥글게 설정
        ),
        height: 200,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '예약하러 가기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            registButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton registButton(context) {
    return ElevatedButton(
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Calendar(reselInfo: reselInfo);
          },
        ));
      },
      child: const Text(
        '예약',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }
}
