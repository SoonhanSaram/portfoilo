import 'package:flutter/material.dart';
import 'package:flutter_tictictoe_ai/controller/game_controller.dart';
import 'package:flutter_tictictoe_ai/pages/game_board.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    GameController _gameController =
        Provider.of<GameController>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MenuButton(
                  function: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameBoard(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MenuButton(
                  text: "싱글플레이",
                  function: () {
                    _gameController.isMultiPlayer = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameBoard(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  MenuButton({
    Key? key,
    this.text = "친구와 플레이",
    required this.function,
  }) : super(key: key);

  final String text;
  VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.0), // 원하는 radius 설정
        color: Colors.white, // 박스의 배경색 설정
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 그림자 색상 설정
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 1), // 그림자 위치 설정
          ),
        ],
      ),
      child: TextButton(
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
