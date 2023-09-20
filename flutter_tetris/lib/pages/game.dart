import 'package:flutter/material.dart';
import 'package:flutter_tetris/service/checkWinner.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  bool oTurn = true;

  List<String> displayElement = ['', '', '', '', '', '', '', '', ''];
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _tapped(index);
              },
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: Center(
                  child: Text(
                    displayElement[index],
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (displayElement[index] != 'O' && displayElement[index] != 'X') {
        oTurn = !oTurn;
      }
      if (oTurn && displayElement[index] == '') {
        displayElement[index] = 'O';
        filledBoxes++;
      } else if (!oTurn && displayElement[index] == '') {
        displayElement[index] = 'X';
        filledBoxes++;
      }

      checkWinner(displayElement, context);
    });
  }

  void winAlert(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(winner + " player 축하합니다."),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                clearBoard();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayElement[i] = '';
      }
    });

    filledBoxes = 0;
  }

  void checkWinner(List<String> displayElement, BuildContext context) {
    String winner = "";

    if (displayElement[0] == displayElement[1] &&
        displayElement[1] == displayElement[2] &&
        displayElement[0] != '') {
      winner = displayElement[0];
      winAlert(winner);
    }
    if (displayElement[3] == displayElement[4] &&
        displayElement[4] == displayElement[5] &&
        displayElement[3] != '') {
      winner = displayElement[3];
      winAlert(winner);
    }
    if (displayElement[6] == displayElement[7] &&
        displayElement[7] == displayElement[8] &&
        displayElement[6] != '') {
      winner = displayElement[6];
      winAlert(winner);
    }
    if (displayElement[0] == displayElement[3] &&
        displayElement[3] == displayElement[6] &&
        displayElement[0] != '') {
      winner = displayElement[0];
      winAlert(winner);
    }
    if (displayElement[1] == displayElement[4] &&
        displayElement[4] == displayElement[7] &&
        displayElement[1] != '') {
      winner = displayElement[1];
      winAlert(winner);
    }
    if (displayElement[2] == displayElement[5] &&
        displayElement[5] == displayElement[8] &&
        displayElement[2] != '') {
      winner = displayElement[2];
      winAlert(winner);
    }
    if (displayElement[0] == displayElement[4] &&
        displayElement[4] == displayElement[8] &&
        displayElement[0] != '') {
      winner = displayElement[0];
      winAlert(winner);
    }
    if (displayElement[2] == displayElement[4] &&
        displayElement[4] == displayElement[6] &&
        displayElement[2] != '') {
      winner = displayElement[2];
      winAlert(winner);
    }
  }
}

// filling the boxes when tapped with X
// or O respectively and then checking the winner function
