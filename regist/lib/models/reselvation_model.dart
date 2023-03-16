import 'package:regist/dto/reselvation_info.dart';

class ReselvationModel {
  final List<ReselInfo> _reselInfoList = [];

  List<ReselInfo> get reselInfoList => _reselInfoList;

  void saveReselInfo(ReselInfo reselInfo) {
    _reselInfoList.add(reselInfo);
  }
}
