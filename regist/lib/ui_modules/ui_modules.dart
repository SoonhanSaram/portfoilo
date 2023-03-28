import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:regist/maps.dart';
import 'package:regist/menu_page.dart';
import 'package:regist/reservation_confirmation_page.dart';

class UiModules {
  Future<void> removeToCompos({required context, required Widget page}) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
      (route) => false,
    );
  }

  final List<String> drawerTitle = [
    "메인메뉴",
    dotenv.env['MAIN_ALARM']!,
    dotenv.env['MAIN_MESSAGE']!,
    dotenv.env['LOGOUT_BUTTON']!,
  ];
  final List<Widget> drawerCompos = [
    const MenuPage(),
    const ReservationConfirmationPage(),
    const MenuPage(),
    const MenuPage(),
  ];

  Future<void> toCompos(
      {required BuildContext context, required Widget page}) async {
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
