import 'dart:async';
import 'dart:math';

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

  double distance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
