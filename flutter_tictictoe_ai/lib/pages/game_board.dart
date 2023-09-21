import 'package:flutter/material.dart';
import 'package:flutter_tictictoe_ai/pages/widget/board_widget.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoardWidget(),
          ],
        ),
      ),
    );
  }
}
