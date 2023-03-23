import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:regist/models/reservation_info_model.dart';

class DataRepository {
  final FirebaseDatabase _database;
  late ReserInfo _reservation;
  DataRepository({FirebaseDatabase? database}) : _database = database ?? FirebaseDatabase.instance;

  Future<void> saveReserInfos(ReserInfo reserInfo) async {
    final userReference = _database.ref().child("reservation_infos");
    DateTime time = DateTime.now();
    var reserInfoMap = reserInfo.toMapSave(sdate: DateFormat("yyyy년 MM월 dd일").format(time), stime: DateFormat("hh시 mm분 ss초").format(time), status: 1);
    print(reserInfoMap);
    try {
      await userReference.child(reserInfo.user).set(reserInfoMap);
    } catch (e) {
      print("저장 실패 $e");
    }
    print("저장성공");
  }

  Future<List<ReserInfo>> getReserInfos({required user}) async {
    List<ReserInfo> reserInfos = [];
    final userReference = _database.ref().child("reservation_infos").child(user);
    try {
      var snapshot = await userReference.once();
      var data = snapshot.snapshot.value;
      print(data);
    } catch (e) {
      print("불러오기 실패, $e");
    }
    return reserInfos;
  }
}
