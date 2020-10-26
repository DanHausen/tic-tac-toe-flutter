import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/theme_app.dart';
import 'package:tictactoe/pages/game_page.dart';

void main() {
  final app = {
    'app': MyApp(),
  };

  runApp(MaterialApp(
    home: CustomSplash(
      imagePath: 'assets/unnamed.png',
      animationEffect: 'zoom-in',
      logoSize: 1024,
      home: MyApp(),
      // customFunction: duringSplash,
      duration: 2500,
      type: CustomSplashType.StaticDuration,
      outputAndHome: app,
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: GAME_TITLE,
      theme: themeApp,
      home: GamePage(),
    );
  }
}
