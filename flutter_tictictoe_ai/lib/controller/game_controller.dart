import 'package:flutter/material.dart';
import 'package:flutter_tictictoe_ai/game_ai/game_ai.dart';
import 'package:flutter_tictictoe_ai/game_ai/game_util.dart';

class GameController extends ChangeNotifier {
  int _player1Win = 0;
  int _player2Win = 0;
  int _draw = 0;
  bool _isBoardFull = false;

  int get player1Win => player1Win;
  int get player2Win => player2Win;
  int get draw => _draw;
  bool get isBoardFull => _isBoardFull;

  bool isMultiPlayer;

  List<int> _board = List.generate(9, (index) => 0);
  int _currentPlayer = GameUtil.Player1;
  int _gameResult = GameUtil.NO_WINNER_YET;
  bool _isAiPlaying = false;
  GameAI ai = GameAI();

  List<int> get board => _board;
  int get currentPlayer => _currentPlayer;
  int get gameResult => _gameResult;
  bool get isAiPlaying => _isAiPlaying;

  GameController(this.isMultiPlayer);

  void reinitialize() {
    _board = List.generate(9, (index) => 0);
    _gameResult = GameUtil.NO_WINNER_YET;
    _currentPlayer = GameUtil.Player1;
  }

  Future<void> move(int idx) async {
    _board[idx] = currentPlayer;
    checkGameWinner();
    togglePlayer();
    if (!isMultiPlayer && _gameResult == GameUtil.NO_WINNER_YET) {
      _isAiPlaying = true;
      await Future.delayed(const Duration(microseconds: 1800));
      final _aiMove = await Future(
        () => ai.play(_board, _currentPlayer),
      );
      board[_aiMove] = _currentPlayer;
      _isAiPlaying = false;
      checkGameWinner();
      togglePlayer();
    }

    _isBoardFull = GameUtil.isBoardFull(board);
    notifyListeners();
  }

  bool isEnable(int idx) => board[idx] == GameUtil.EMPTY;

  int getDataAt(int idx) => board[idx];

  void togglePlayer() {
    _currentPlayer = GameUtil.togglePlayer(_currentPlayer);
  }

  void checkGameWinner() {
    _gameResult = GameUtil.checkIfWinnerFound(board);
    switch (_gameResult) {
      case GameUtil.Player1:
        _player1Win++;
        break;
      case GameUtil.Player2:
        _player2Win++;
        break;
      case GameUtil.DRAW:
        _draw++;
        break;
    }
  }

  String? get currentPlayerMove {
    if (_currentPlayer == GameUtil.Player1) {
      return "Player 1's move";
    } else if (_currentPlayer == GameUtil.Player2) {
      return isMultiPlayer ? "Player 2's move" : "AI's move";
    }
    return null;
  }

  String? get gameResultStatus {
    final _gameResult = gameResult;
    if (_gameResult != GameUtil.NO_WINNER_YET) {
      if (_gameResult == GameUtil.Player1) {
        return "Player 1 wins";
      } else if (_gameResult == GameUtil.Player2) {
        return isMultiPlayer ? "Player 2 wins" : "AI wins";
      } else if (_gameResult == GameUtil.DRAW) {
        return "Draw";
      }
    }
    return null;
  }
}
