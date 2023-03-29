import 'package:flutter/material.dart';
import 'package:regist/viewmodel/booked_view_model.dart';

void showPopup(
    {required BuildContext context,
    required BookedViewModel bookedViewModel,
    required Map<String, dynamic> temp}) {
  final theme = Theme.of(context);
  const cancelText = '예약 취소';
  const editText = '예약 수정';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('예약 취소 & 수정'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                bookedViewModel.status = 3;
                print(temp.keys.first);
                bookedViewModel.infoUpdateFunc(
                    temp.keys.first, bookedViewModel.reserInfomation!);
                Navigator.pop(context);
              },
              child: Text(
                cancelText,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                editText,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
