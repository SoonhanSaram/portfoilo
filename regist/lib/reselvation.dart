import 'package:flutter/material.dart';
import 'package:regist/models/reselvation_info.dart';

class reselvation extends StatefulWidget {
  const reselvation({super.key});

  @override
  State<reselvation> createState() => _reselvationState();
}

class _reselvationState extends State<reselvation> {
  late ReselInfo reselInfo;
  @override
  void initState() {
    super.initState();

    _dateController.text = reselInfo.sdate;
    _departureController.text = reselInfo.from;
    _destinationController.text = reselInfo.destination;

    print(reselInfo);
  }

  String? _dropValue;
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _numPeopleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _numPeopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("예약 정보확인"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 3.0,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: <Widget>[
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: '출발 날짜',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: "출발 시간",
                    suffixText: "시",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _numPeopleController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '인원수',
                    suffixText: "명",
                    hintText: '1~10 또는 10인초과',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _departureController,
                  decoration: const InputDecoration(
                    labelText: 'From',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'To',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "운송수단 선택 : ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton<String>(
                  value: _dropValue,
                  icon: const Icon(Icons.car_rental),
                  onChanged: (String? value) {
                    setState(() {
                      // reselInfo.transfer = value.toString();
                      _dropValue = value;
                    });
                  },
                  items: <String>['승용차', '승합차', '리무진']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // reselInfo.time = _timeController.text;
                // reselInfo.number = _numPeopleController.text;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Resel Info"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User: ${reselInfo.user}"),
                          Text("Date: ${reselInfo.sdate}"),
                          Text("Time: ${reselInfo.etime}"),
                          Text("From: ${reselInfo.from}"),
                          Text("Destination: ${reselInfo.destination}"),
                          Text("Transfer: ${reselInfo.transport}"),
                          Text("Number of People: ${reselInfo.people}"),
                          Text("Payment: ${reselInfo.fee}"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                "예약하기",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  backgroundColor: Color(0xFF2186D1),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(height: 800),
            )
          ],
        ),
      ),
    );
  }
}
