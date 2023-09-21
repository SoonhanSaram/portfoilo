import 'package:flutter/material.dart';
import 'package:flutter_tictictoe_ai/controller/game_controller.dart';
import 'package:flutter_tictictoe_ai/pages/start.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const TicTacToe(),
  );
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameController(false),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartPage(),
      ),
    );
  }
}
