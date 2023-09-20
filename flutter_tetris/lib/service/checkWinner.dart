import 'package:flutter/material.dart';

void checkWinner11(List<String> displayElement, BuildContext context) {
  String winner = "";

  if (displayElement[0] == displayElement[1] &&
      displayElement[1] == displayElement[2] &&
      displayElement[0] != '') {
    winner = displayElement[0];
  }
  if (displayElement[3] == displayElement[4] &&
      displayElement[4] == displayElement[5] &&
      displayElement[3] != '') {
    winner = displayElement[3];
  }
  if (displayElement[6] == displayElement[7] &&
      displayElement[7] == displayElement[8] &&
      displayElement[6] != '') {
    winner = displayElement[6];
  }
  if (displayElement[0] == displayElement[3] &&
      displayElement[3] == displayElement[6] &&
      displayElement[0] != '') {
    winner = displayElement[0];
  }
  if (displayElement[1] == displayElement[4] &&
      displayElement[4] == displayElement[7] &&
      displayElement[1] != '') {
    winner = displayElement[1];
  }
  if (displayElement[2] == displayElement[5] &&
      displayElement[5] == displayElement[8] &&
      displayElement[2] != '') {
    winner = displayElement[2];
  }
  if (displayElement[0] == displayElement[4] &&
      displayElement[4] == displayElement[8] &&
      displayElement[0] != '') {
    winner = displayElement[0];
  }
  if (displayElement[2] == displayElement[4] &&
      displayElement[4] == displayElement[6] &&
      displayElement[2] != '') {
    winner = displayElement[2];
  }
}
