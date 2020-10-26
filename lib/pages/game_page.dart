import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tictactoe/controllers/game_controller.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/dialogs/custom_dialog.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/models/game_tile.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(GAME_TITLE),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => _shareGame(context),
        )
      ],
    );
  }

  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _scoreBoard(),
          _currentPlayerText(),
          _buildBoard(),
          _buildPlayerMode(),
          _buildResetButton(),
        ],
      ),
    );
  }

  _buildResetButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text(RESET_BUTTON_LABEL),
      onPressed: _onResetGame,
    );
  }

  _scoreBoard() {
    return Container(
      // padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Playstation',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_controller.x.toString()),
            ],
          ),
          Column(
            children: [
              Text(
                'Xbox',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_controller.o.toString()),
            ],
          ),
        ],
      ),
    );
  }

  _buildBoard() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: BOARD_SIZE,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final tile = _controller.tiles[index];
          return _buildTile(tile);
        },
      ),
    );
  }

  _buildTile(GameTile tile) {
    return GestureDetector(
      onTap: () => _onMarkTile(tile),
      child: Container(
        color: tile.color,
        child: Center(
          child: Image(
            image: AssetImage(tile.img),
          ),
        ),
      ),
    );
  }

  _onResetGame() {
    setState(() {
      _controller.initialize();
    });
  }

  _onMarkTile(GameTile tile) {
    if (!tile.enable) return;

    setState(() {
      _controller.mark(tile);
    });

    _checkWinner();
  }

  _checkWinner() {
    var winner = _controller.checkWinner();
    if (winner == WinnerType.none) {
      if (!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isBotTurn) {
        _onMarkTileByBot();
      }
    } else {
      String symbol =
          winner == WinnerType.player1 ? PLAYER1_SYMBOL : PLAYER2_SYMBOL;
      _showWinnerDialog(symbol);
      setState(() {
        _controller.scoreCount(symbol);
      });
    }
  }

  _onMarkTileByBot() {
    final id = _controller.automaticMove();
    final tile = _controller.tiles.firstWhere((element) => element.id == id);
    _onMarkTile(tile);
  }

  _showWinnerDialog(String symbol) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: WIN_TITLE.replaceAll('[SYMBOL]', symbol),
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _showTiedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: TIED_TITLE,
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(
          _controller.isSinglePlayer ? SINGLE_PLAYER_MODE : MULTIPLAYER_MODE),
      secondary: Icon(_controller.isSinglePlayer ? Icons.person : Icons.group),
      value: _controller.isSinglePlayer,
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
        });
      },
    );
  }

  _currentPlayerText() {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.25),
      ),
      child: Center(
        child: Text(
          'Player turn: ' + _controller.currentPlayerTurn(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  _shareGame(BuildContext context) async {
    await Share.share(
      'Check out this game ! - https://github.com/lgmbx/tic-tac-toe',
    );
  }
}
