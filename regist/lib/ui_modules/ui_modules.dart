import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:regist/calendar.dart';
import 'package:regist/maps.dart';
import 'package:regist/menu_page.dart';
import 'package:regist/reservation_confirmation_page.dart';

class UiModules {
  static UiModules instance() {
    return UiModules();
  }

  List<String> drawerTitle = [
    dotenv.env['MAIN_ALARM']!,
    dotenv.env['MAIN_MENU']!,
    dotenv.env['MAIN_MESSAGE']!,
    dotenv.env['LOGOUT_BUTTON']!,
  ];
  List<Function> drawerFunctions = [
    (BuildContext context) => {Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MenuPage()), (route) => false)},
    (BuildContext context) => {Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ReservationConfirmationPage()), (route) => false)},
    () {},
    () {},
  ];

  Future<void> toCalendar({required BuildContext context, page = Calendar}) async {
    if (!Navigator.canPop(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return page;
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

  void toConfirmPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ReservationConfirmationPage();
        },
      ),
    );
  }
}
