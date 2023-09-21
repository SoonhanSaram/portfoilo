import 'package:flutter/material.dart';
import 'package:flutter_tictictoe_ai/controller/game_controller.dart';
import 'package:flutter_tictictoe_ai/game_ai/game_util.dart';
import 'package:flutter_tictictoe_ai/pages/widget/custom_container.dart';
import 'package:flutter_tictictoe_ai/widget/circle_widget.dart';
import 'package:flutter_tictictoe_ai/widget/cross_widget.dart';
import 'package:provider/provider.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    GameController _gameController =
        Provider.of<GameController>(context, listen: true);
    return Column(
      children: [
        CustomContainer(
          height: 0.48,
          child: Padding(
            padding:
                EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0, right: 8.0),
            child: InkWell(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: _gameController.isEnable(index)
                        ? () => _gameController.move(index)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.yellow)),
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child:
                            _getPlayerWidget(_gameController.getDataAt(index)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        _listenGameResult(),
      ],
    );
  }

  Widget? _getPlayerWidget(int playerId) {
    switch (playerId) {
      case GameUtil.Player1:
        return const CrossWidget();
      case GameUtil.Player2:
        return const CircleWidget();
      default:
        return null;
    }
  }

  Widget _listenGameResult() {
    GameController _gameController =
        Provider.of<GameController>(context, listen: true);
    return IgnorePointer(
      ignoring: _gameController.gameResult == 0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        color: _gameController.gameResult != 0
            ? Colors.grey.withOpacity(0.2)
            : Colors.transparent,
        child: _buildForGameResult(_gameController),
      ),
    );
  }

  Widget? _buildForGameResult(_gameController) {
    final _gameResultStatus = _gameController.gameResultStatus;
    if (_gameResultStatus != null) {
      return GestureDetector(
        onTap: _gameController.reinitialize(),
        child: Text(
          _gameResultStatus,
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return null;
  }
}
