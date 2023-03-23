import 'dart:async';

import 'package:flutter/material.dart';
import 'package:regist/calendar.dart';
import 'package:regist/maps.dart';

class UiModules {
  Future<void> toCalendar(BuildContext context) async {
    if (!Navigator.canPop(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Calendar();
          },
        ),
      );
    }
  }

  void toMaps(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Maps();
        },
      ),
    );
  }
}
