import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/winner_rules.dart';
import 'package:tictactoe/enums/player_type.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/models/game_tile.dart';

import '../core/constants.dart';
import '../enums/player_type.dart';

class GameController {
  List<GameTile> tiles = [];
  List<int> movesPlayer1 = [];
  List<int> movesPlayer2 = [];
  PlayerType currentPlayer;
  bool isSinglePlayer;
  int x = 0, o = 0;
/*
  bool hasMoves() { 
    return (movesPlayer1.length + movesPLayer2.length) != BOARD_SIZE;
    }
*/
  bool get hasMoves =>
      (movesPlayer1.length + movesPlayer2.length) != BOARD_SIZE;

  bool get isBotTurn => isSinglePlayer && currentPlayer == PlayerType.player2;
  GameController() {
    initialize();
  }

  String currentPlayerTurn() {
    if (currentPlayer == PlayerType.player1) {
      return PLAYER1_SYMBOL;
    }
    return PLAYER2_SYMBOL;
  }

  void initialize() {
    movesPlayer1.clear();
    movesPlayer2.clear();
    currentPlayer = PlayerType.player1;
    isSinglePlayer = false;
    tiles = List<GameTile>.generate(BOARD_SIZE, (index) => GameTile(index + 1));

    // for (var i = 1; i <= 9; i++) {
    //   tiles.add(GameTile(i));
    // }
  }

  void mark(GameTile tile) {
    if (currentPlayer == PlayerType.player1) {
      tile.symbol = PLAYER1_SYMBOL;
      tile.color = PLAYER1_COLOR;
      movesPlayer1.add(tile.id);
      tile.img = PLAYER1_IMG;
      currentPlayer = PlayerType.player2;
    } else {
      tile.symbol = PLAYER2_SYMBOL;
      tile.color = PLAYER2_COLOR;
      movesPlayer2.add(tile.id);
      tile.img = PLAYER2_IMG;
      currentPlayer = PlayerType.player1;
    }
    tile.enable = false;
  }

  bool checkPlayerWinner(List<int> moves) {
    return winnerRules.any((rule) =>
        moves.contains(rule[0]) &&
        moves.contains(rule[1]) &&
        moves.contains(rule[2]));
  }

  WinnerType checkWinner() {
    if (checkPlayerWinner(movesPlayer1)) return WinnerType.player1;
    if (checkPlayerWinner(movesPlayer2)) return WinnerType.player2;
    return WinnerType.none;
  }

  int automaticMove() {
    var moves = new List<int>.generate(BOARD_SIZE, (index) => index + 1);
    moves.removeWhere((element) => movesPlayer1.contains(element));
    moves.removeWhere((element) => movesPlayer2.contains(element));

    moves.shuffle();
    return moves[0];
  }

  scoreCount(String symbol) {
    if (symbol == 'Playstation') {
      return x++;
    } else if (symbol == 'Xbox') {
      return o++;
    }
  }
}
