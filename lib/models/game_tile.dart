import 'package:flutter/material.dart';

class GameTile {
  final int id;
  String symbol;
  Color color;
  bool enable;
  String img;

  GameTile(
    this.id, {
    this.symbol = '',
    this.color = Colors.black26,
    this.enable = true,
    this.img = 'assets/bg.png',
  });
}
