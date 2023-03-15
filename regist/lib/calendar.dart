import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:regist/dto/reselvation_info.dart';
import 'package:regist/maps.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, this.reselInfo});
  final reselInfo;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late ReselInfo reselInfo;

  @override
  void initState() {
    super.initState();
    reselInfo = widget.reselInfo;
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("날짜선택")),
      body: Column(children: [
        TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              this.selectedDay = selectedDay;
              this.focusedDay = focusedDay;
            });
          },
          selectedDayPredicate: (DateTime day) {
            // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
            return isSameDay(selectedDay, day);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                // reselInfo.sdate = DateFormat("yyyy-MM-dd").format(selectedDay);
                print(reselInfo);
                return Maps(reselInfo: reselInfo);
              },
            ));
          },
          child: const Text("선택"),
        )
      ]),
    );
  }
}
