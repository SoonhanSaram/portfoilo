class ReserInfo {
  ReserInfo({
    required this.user,
    this.sdate = "",
    this.stime = "",
    this.resDate = "",
    this.resTime = "",
    this.edate = "",
    this.etime = "",
    this.from = "",
    this.destination = "",
    this.transport = "",
    this.people = "",
    this.fee = "",
    this.status = 0,
  });

  String user;
  String sdate;
  String stime;
  String resDate;
  String resTime;
  String from;
  String destination;
  String transport;
  String? people;
  String fee;
  String? edate;
  String? etime;
  int status;

  // Firebase 에 입력하기 위한 직렬화(serialization)
  Map<String, dynamic> toMapSave({required sdate, required stime, required status}) {
    return {
      'user': user,
      'sdate': sdate,
      'stime': stime,
      'from': from,
      'destination': destination,
      'transport': transport,
      'people': people,
      'fee': fee,
      'edate': edate,
      'etime': etime,
      'resTime': resTime,
      'resDate': resDate,
      'status': status,
    };
  }

  factory ReserInfo.fromJson(Map<String, dynamic> json) {
    return ReserInfo(
      user: json['user'] ?? "정보 없음",
      resDate: json['resDate'] ?? "정보 없음",
      resTime: json['resTime'] ?? "정보 없음",
      sdate: json['sdate'] ?? "정보 없음",
      edate: json['edate'] ?? "정보 없음",
      etime: json['etime'] ?? "정보 없음",
      stime: json['stime'] ?? "정보 없음",
      from: json['from'] ?? "정보 없음",
      destination: json['destination'] ?? "정보 없음",
      transport: json['transport'] ?? "정보 없음",
      people: json['people'] ?? "정보 없음",
      fee: json['fee'] ?? "0",
      status: json['status'] ?? 0,
    );
  }

  @override
  String toString() {
    return '''
      sdate: $sdate
      fee: $fee
      destination: $destination
      stime: $stime
      transport: $transport
      edate: $edate
      people: $people
      resTime: $resTime
      etime: $etime
      from: $from
      resDate: $resDate
      user: $user
      status: $status
    ''';
  }
}
