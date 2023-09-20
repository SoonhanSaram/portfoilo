import 'package:flutter/material.dart';
import 'package:flutter_tetris/pages/game.dart';

void BoardService(context, widget) => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget(),
        ),
      ),
    };
