import 'package:flutter/material.dart';
import 'package:regist/models/reselvation_info.dart';
import 'package:regist/viewmodel/login_view_model.dart';

class BookedViewModel with ChangeNotifier {
  ReselInfo? _reselInfo;
  LoginViewModel? _loginViewModel;

  BookedViewModel() {
    _loginViewModel = LoginViewModel();
    _reselInfo = ReselInfo(user: _loginViewModel!.reselInfo!.user);
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
