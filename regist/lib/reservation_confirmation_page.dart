import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:regist/models/reservation_info_model.dart';

class ReservationConfirmationPage extends StatefulWidget {
  const ReservationConfirmationPage({super.key});

  @override
  State<ReservationConfirmationPage> createState() =>
      _ReservationConfirmationPageState();
}

class _ReservationConfirmationPageState
    extends State<ReservationConfirmationPage> {
  final _database = FirebaseDatabase.instance.ref('reservation_info');
  List<ReserInfo>? result = [];
  void getDocs() {
    _database.orderByChild("").onValue.listen(
      (event) {
        final response = event.snapshot.value;

        var datas =
            Map<String, dynamic>.from(response as Map<Object?, Object?>);

        List<String> keys = datas.keys.toList();
        for (String key in keys) {
          ReserInfo reserInfo =
              ReserInfo.fromJson(Map<String, dynamic>.from(datas));
          result!.add(reserInfo);
          print(result);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("예약정보 확인 화면"),
      ),
      body: const Text("예약정보 확인화면"),
    );
  }
}
