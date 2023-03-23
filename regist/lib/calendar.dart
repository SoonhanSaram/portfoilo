import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:regist/staticValue/static_value.dart';
import 'package:regist/ui_modules/ui_modules.dart';
import 'package:regist/viewmodel/booked_view_model.dart';

import 'package:regist/viewmodel/login_view_model.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
  }

  late int selectedHours;
  late int selectedMinutes;

  late String _stime;

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final medaiQuery = MediaQuery.of(context);
    var loginViewModel = context.watch<LoginViewModel>();
    var bookedViewModel = context.watch<BookedViewModel>();
    var uiMdules = UiModules();
    return Scaffold(
      appBar: AppBar(title: const Text("날짜선택")),
      body: Column(children: [
        TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          onDaySelected: (selectedDay, focusedDay) {
            setState(
              () {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
                bookedViewModel.resDate =
                    selectedDay.toString().substring(0, 10);
              },
            );
          },
          selectedDayPredicate: (DateTime day) {
            // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
            return isSameDay(selectedDay, day);
          },
        ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.35,
                        maxHeight: MediaQuery.of(context).size.height * 0.35),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Text(
                              dotenv.env["TIME_PICKER"]!,
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w900),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TimePickerSpinner(
                                highlightedTextStyle: const TextStyle(
                                    color: Colors.black, fontSize: 36),
                                time: DateTime.utc(0, 0, 0, 0, 0, 0),
                                is24HourMode: true,
                                isForce2Digits: true,
                                onTimeChange: (time) {
                                  setState(
                                    () {
                                      selectedHours = time.hour;
                                      selectedMinutes = time.minute;

                                      bookedViewModel.resTime =
                                          ("$selectedHours시 : $selectedMinutes분");
                                    },
                                  );
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () => uiMdules.toMaps(context),
                              child: Text(
                                dotenv.env["TIME_PICKER_BUTTON"]!,
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Text("선택"),
        )
      ]),
    );
  }
}
