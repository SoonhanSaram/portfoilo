import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:regist/viewmodel/booked_view_model.dart';

class ReservationConfirmationPage extends StatelessWidget {
  const ReservationConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bookedViewModel = context.watch<BookedViewModel>();

    return Scaffold(
        appBar: AppBar(
          title: const Text("예약정보 확인 화면"),
        ),
        body: const Text("예약정보 확인화면"));
  }
}
