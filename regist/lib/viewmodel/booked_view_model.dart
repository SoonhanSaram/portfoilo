import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:regist/dao/directions_respository.dart';
import 'package:regist/models/directions_model.dart';
import 'package:regist/models/reselvation_info_model.dart';

import 'package:regist/viewmodel/login_view_model.dart';
import 'dart:math';

class BookedViewModel with ChangeNotifier {
  ReselInfo? _reselInfo;
  LoginViewModel? _loginViewModel;
  final DirectionsRepository _repository = DirectionsRepository();
  Directions? _directions;
  Directions? get directions => _directions;
  double? calDistance;
  String? sedanRentFee;
  String? suvRentFee;
  String? limousineRentFee;
  BookedViewModel() {
    _loginViewModel = LoginViewModel();
    _reselInfo = ReselInfo(user: _loginViewModel!.reselInfo!.user);
  }

  double distance({lat1, lon1, lat2, lon2}) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

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

  void fare() {
    print("계산시작");
    sedanRentFee =
        ((calcFare(double.parse(dotenv.env['SEDAN_RENT_FEE']!))! / 100.0)
                    .roundToDouble() *
                100)
            .toStringAsFixed(0);
    print("계산중 $sedanRentFee");
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

  ReselInfo? get reselInfomation => _reselInfo;

  set reselInfo(ReselInfo reselInfo) {
    _reselInfo = reselInfo;
    notifyListeners();
  }

  String get user => _reselInfo!.user;

  set user(String user) {
    _reselInfo!.user = user;
    notifyListeners();
  }

  String get sdate => _reselInfo!.sdate;

  set sdate(String sdate) {
    _reselInfo!.sdate = sdate;
    notifyListeners();
  }

  String get stime => _reselInfo!.stime;

  set stime(String stime) {
    _reselInfo!.stime = stime;
    notifyListeners();
  }

  String get resDate => _reselInfo!.resDate;

  set resDate(String resDate) {
    _reselInfo!.resDate = resDate;
    notifyListeners();
  }

  String get resTime => _reselInfo!.resTime;

  set resTime(String resTime) {
    _reselInfo!.resTime = resTime;
    notifyListeners();
  }

  String get from => _reselInfo!.from;

  set from(String from) {
    _reselInfo!.from = from;
    notifyListeners();
  }

  String get destination => _reselInfo!.destination;

  set destination(String destination) {
    _reselInfo!.destination = destination;
    notifyListeners();
  }

  String get transport => _reselInfo!.transport;

  set transport(String transport) {
    _reselInfo!.transport = transport;
    notifyListeners();
  }

  String get people => _reselInfo!.people;

  set people(String people) {
    _reselInfo!.people = people;
    notifyListeners();
  }

  String get fee => _reselInfo!.fee;

  set fee(String fee) {
    _reselInfo!.fee = fee;
    notifyListeners();
  }

  String get edate => _reselInfo!.edate;

  set edate(String edate) {
    _reselInfo!.edate = edate;
    notifyListeners();
  }

  String get etime => _reselInfo!.etime;

  set etime(String etime) {
    _reselInfo!.etime = etime;
    notifyListeners();
  }
}
