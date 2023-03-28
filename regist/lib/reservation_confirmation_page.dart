import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regist/models/reservation_info_model.dart';
import 'package:regist/result_page.dart';
import 'package:regist/ui_modules/ui_modules.dart';
import 'package:regist/viewmodel/booked_view_model.dart';
import 'package:regist/viewmodel/login_view_model.dart';

class ReservationConfirmationPage extends StatefulWidget {
  const ReservationConfirmationPage({super.key});

  @override
  State<ReservationConfirmationPage> createState() =>
      _ReservationConfirmationPageState();
}

class _ReservationConfirmationPageState
    extends State<ReservationConfirmationPage> {
  // Set<type> 중복된 값을 버리고 추가
  final List<ReserInfo> _list = [];
  final _database = FirebaseDatabase.instance.ref();
  late String _user;
  late BookedViewModel _bookedViewModel;
  Future<void> getDocs(String user) async {
    _database.child('reservation_infos').orderByChild(user).onValue.listen(
      (event) {
        _list.clear();
        final response = event.snapshot.value;
        // print(response);
        var datas =
            Map<String, dynamic>.from(response as Map<Object?, Object?>);
        // print("cast : $datas");
        var keys = datas.keys.toList();
        final result = <String, dynamic>{};
        for (var key in keys) {
          var value = ReserInfo.fromJson(Map<String, dynamic>.from(datas[key]));
          setState(() {
            _list.add(value);
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = context.watch<LoginViewModel>().reselInfo!.user;
    _bookedViewModel = context.watch<BookedViewModel>();
    getDocs(_user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("예약정보 확인 화면"),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: ((context, i) {
              if (_list[i].status == 1) {
                return infoCard(i, Colors.tealAccent, Colors.black);
              } else if (_list[i].status == 2) {
                return infoCard(i, Colors.blueAccent, Colors.white);
              }
              return infoCard(i, Colors.deepPurpleAccent, Colors.grey);
            }),
          ),
        ),
      ),
    );
  }

  Row colorMessage() {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.amberAccent),
        ),
        const Text("승인 대기중")
      ],
    );
  }

  GestureDetector infoCard(int i, MaterialAccentColor color, Color textColor) {
    return GestureDetector(
      onTap: () {
        print("클릭");

        UiModules().toCompos(
          context: context,
          page: const ResultPage(),
        );
      },
      child: Card(
        color: color,
        child: ListTile(
          key: ValueKey(_list[i]),
          leading: Column(
            children: [
              Text(
                "예약 시간",
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              Text(
                "${_list[i].resDate} ${_list[i].resTime}",
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ],
          ),
          title: Text(
            "출발지 : ${_list[i].from} \n도착지 :  ${_list[i].destination}",
            style: TextStyle(fontWeight: FontWeight.w300, color: textColor),
          ),
        ),
      ),
    );
  }
}
