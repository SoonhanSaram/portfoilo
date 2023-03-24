import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:regist/dao/data_repository.dart';
import 'package:regist/dao/directions_respository.dart';
import 'package:regist/models/directions_model.dart';
import 'package:regist/models/reservation_info_model.dart';

import 'package:regist/viewmodel/login_view_model.dart';
import 'dart:math';

class BookedViewModel with ChangeNotifier {
  ReserInfo? _reserInfo;
  LoginViewModel? _loginViewModel;
  final DirectionsRepository _repository = DirectionsRepository();
  final DataRepository _dataRepository = DataRepository();
  Directions? _directions;
  Directions? get directions => _directions;
  double? calDistance;
  String? sedanRentFee;
  String? suvRentFee;
  String? limousineRentFee;

  BookedViewModel() {
    _loginViewModel = LoginViewModel();
    _reserInfo = ReserInfo(user: _loginViewModel!.reselInfo!.user);
  }

  // 출발지와 목적지 거리 계산 함수
  double distance({lat1, lon1, lat2, lon2}) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // 경로 검색 repository 로 보내는 함수
  Future<void> fetchDirections(
      {required LatLng origin, required LatLng destination}) async {
    try {
      _directions = await _repository.getDirections(
        origin: origin,
        destination: destination,
      );
      double dist = distance(
        lat1: origin.latitude,
        lon1: origin.longitude,
        lat2: destination.latitude,
        lon2: destination.longitude,
      );
      calDistance = dist;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 예약비용 계산 함수
  void fare() {
    // 할증 계산
    double? calcFare(double fee) {
      double surchargefee = 0;
      var surchageRate = 0.2;
      if (calDistance! > 5) {
        int quotient = calDistance! ~/ 5;
        surchargefee = fee * surchageRate * quotient;
        double remainder = calDistance! % 5;
        if (remainder > 0) {
          surchargefee += fee * surchageRate;
        }
      }
      return fee + surchargefee;
    }

    sedanRentFee =
        ((calcFare(double.parse(dotenv.env['SEDAN_RENT_FEE']!))! / 100.0)
                    .roundToDouble() *
                100)
            .toStringAsFixed(0);
    suvRentFee = ((calcFare(double.parse(dotenv.env['SUV_RENT_FEE']!))! / 100.0)
                .roundToDouble() *
            100)
        .toStringAsFixed(0);
    limousineRentFee =
        ((calcFare(double.parse(dotenv.env['LIMOUSINE_RENT_FEE']!))! / 100.0)
                    .roundToDouble() *
                100)
            .toStringAsFixed(0);
    notifyListeners();
  }

  Future<void> infoSaveFunc(ReserInfo reserInfo) async {
    try {
      await _dataRepository.saveReserInfos(reserInfo);
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<ReserInfo>> getInfoFunc({required user}) async {
    List<ReserInfo> result = [];

    try {
      var response = await _dataRepository.getReserInfos(user: user);
      result.add(response);
      return result;
    } catch (e) {
      throw Exception("중계 함수 에러");
    }
  }

  ReserInfo? get reserInfomation => _reserInfo;

  set reserInfo(ReserInfo reserInfo) {
    _reserInfo = reserInfo;
    notifyListeners();
  }

  String get user => _reserInfo!.user;

  set user(String user) {
    _reserInfo!.user = user;
    notifyListeners();
  }

  String get sdate => _reserInfo!.sdate;

  set sdate(String sdate) {
    _reserInfo!.sdate = sdate;
    notifyListeners();
  }

  String get stime => _reserInfo!.stime;

  set stime(String stime) {
    _reserInfo!.stime = stime;
    notifyListeners();
  }

  String get resDate => _reserInfo!.resDate;

  set resDate(String resDate) {
    _reserInfo!.resDate = resDate;
    notifyListeners();
  }

  String get resTime => _reserInfo!.resTime;

  set resTime(String resTime) {
    _reserInfo!.resTime = resTime;
    notifyListeners();
  }

  String get from => _reserInfo!.from;

  set from(String from) {
    _reserInfo!.from = from;
    notifyListeners();
  }

  String get destination => _reserInfo!.destination;

  set destination(String destination) {
    _reserInfo!.destination = destination;
    notifyListeners();
  }

  String get transport => _reserInfo!.transport;

  set transport(String transport) {
    _reserInfo!.transport = transport;
    notifyListeners();
  }

  String get people => _reserInfo!.people;

  set people(String people) {
    _reserInfo!.people = people;
    notifyListeners();
  }

  String get fee => _reserInfo!.fee;

  set fee(String fee) {
    _reserInfo!.fee = fee;
    notifyListeners();
  }

  String get edate => _reserInfo!.edate;

  set edate(String edate) {
    _reserInfo!.edate = edate;
    notifyListeners();
  }

  String get etime => _reserInfo!.etime;

  set etime(String etime) {
    _reserInfo!.etime = etime;
    notifyListeners();
  }
}
