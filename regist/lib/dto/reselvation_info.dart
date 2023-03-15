class ReselInfo {
  ReselInfo({
    required this.user,
    this.sdate = "",
    this.time = "",
    this.from = "",
    this.destination = "",
    this.transport = "",
    this.people = "",
    this.fee = "",
    this.edate = "",
  });

  String? user;
  final String sdate;
  final String time;
  final String from;
  final String destination;
  final String transport;
  final String people;
  final String fee;
  final String edate;

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'sdate': sdate,
      'time': time,
      'from': from,
      'destination': destination,
      'transport': transport,
      'people': people,
      'fee': fee,
      'edate': edate,
    };
  }

  factory ReselInfo.fromMap(Map<String, dynamic> json) => ReselInfo(
        user: json['user'],
        sdate: json['sdate'],
        edate: json['edate'],
        time: json['sdate'],
        from: json['sdate'],
        destination: json['sdate'],
        transport: json['sdate'],
        people: json['people'],
        fee: json['fee'],
      );
}
