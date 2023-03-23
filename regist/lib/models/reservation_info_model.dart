class ReserInfo {
  ReserInfo({
    required this.user,
    this.sdate = "",
    this.stime = "",
    this.resDate = "",
    this.resTime = "",
    this.from = "",
    this.destination = "",
    this.transport = "",
    this.people = "",
    this.fee = "",
    this.edate = "",
    this.etime = "",
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
  String people;
  String fee;
  String edate;
  String etime;
  int status;

  // Firebase 에 입력하기 위한 직렬화(serialization)
  Map<String, dynamic> toMapSave({required sdate, required stime, required status}) {
    return {
      'user': user,
      'sdate': sdate,
      'time': stime,
      'from': from,
      'destination': destination,
      'transport': transport,
      'people': people,
      'fee': fee,
      'edate': edate,
      'etime': etime,
      'status': status,
    };
  }

  factory ReserInfo.fromMap(Map<String, dynamic> json) => ReserInfo(
        user: json['user'],
        sdate: json['sdate'],
        edate: json['edate'],
        stime: json['sdate'],
        from: json['sdate'],
        destination: json['sdate'],
        transport: json['sdate'],
        people: json['people'],
        fee: json['fee'],
        status: json['status'],
      );
}
