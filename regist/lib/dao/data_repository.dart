import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:regist/models/reservation_info_model.dart';

class DataRepository {
  final FirebaseDatabase _database;
  late ReserInfo _reservation;
  DataRepository({FirebaseDatabase? database}) : _database = database ?? FirebaseDatabase.instance;

  Future<void> saveReserInfos(ReserInfo reserInfo) async {
    final userReference = _database.ref("reservation_infos");
    DateTime time = DateTime.now();
    var reserInfoMap = reserInfo.toMapSave(sdate: DateFormat("yyyy년 MM월 dd일").format(time), stime: DateFormat("hh시 mm분 ss초").format(time), status: 1);
    var random = Random().nextInt(26) + 65;

    try {
      await userReference.child("${reserInfo.user}$random").set(reserInfoMap);
    } catch (e) {}
  }

  Future<List<ReserInfo>> getReserInfos({required user}) async {
    List<ReserInfo>? result = [];

    // get()을 사용하면 한 번 읽기
    // listen() DatabaseEvent를 사용하면 이벤트 발생 시점에 존재하는 지정된 경로에서
    // 데이터를 읽을 수 있습니다. 이 이벤트는 리스너가 연결될 때 한 번 트리거된 후
    // 하위 요소를 포함하여 데이터가 변경될 때마다 다시 트리거됩니다.
    // 이벤트에는 하위 데이터를 포함하여 해당 위치의 모든 데이터를 포함하는
    // snapshot 속성이 있습니다. 데이터가 없으면 스냅샷의 exists 속성은
    // false이고 value 속성은 null입니다.
    try {
      _database.ref().child("reservation_infos").orderByChild(user).get().then(
        (event) {
          final response = event.value;
          // print(event.snapshot.children.length);
          var datas = Map<String, dynamic>.from(response as Map<Object?, Object?>);

          List<String> keys = datas.keys.toList();
          for (String key in keys) {
            ReserInfo reserInfo = ReserInfo.fromJson(Map<String, dynamic>.from(datas));
            result.add(reserInfo);
          }
        },
      );

      return result;
    } catch (e) {
      throw Exception("데이터 호출 오류");
    }
  }

  // Future<List<ReserInfo>> getReserInfos({required user}) async {
  //   List<ReserInfo>? result = [];

  //   // get()을 사용하면 한 번 읽기
  //   // listen() DatabaseEvent를 사용하면 이벤트 발생 시점에 존재하는 지정된 경로에서
  //   // 데이터를 읽을 수 있습니다. 이 이벤트는 리스너가 연결될 때 한 번 트리거된 후
  //   // 하위 요소를 포함하여 데이터가 변경될 때마다 다시 트리거됩니다.
  //   // 이벤트에는 하위 데이터를 포함하여 해당 위치의 모든 데이터를 포함하는
  //   // snapshot 속성이 있습니다. 데이터가 없으면 스냅샷의 exists 속성은
  //   // false이고 value 속성은 null입니다.
  //   try {
  //     _database.ref().child("reservation_infos").orderByChild(user).onValue.listen(
  //       (event) {
  //         final response = event.snapshot.value;
  //         // print(event.snapshot.children.length);
  //         var datas = Map<String, dynamic>.from(response as Map<Object?, Object?>);
  //         List<String> keys = datas.keys.toList();

  //         for (String key in keys) {
  //           ReserInfo reserInfo = ReserInfo.fromJson(Map<String, dynamic>.from(datas[key] as Map<Object?, Object?>));
  //           result.add(reserInfo);
  //         }
  //       },
  //     );

  //     return result;
  //   } catch (e) {
  //     throw Exception("데이터 호출 오류");
  //   }
  // }
}
