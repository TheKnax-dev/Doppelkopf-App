import 'package:doppelkopf/pages/GameOverview.dart';
import 'package:doppelkopf/pages/loadingScreen.dart';
import 'package:doppelkopf/pages/players.dart';
import 'package:flutter/material.dart';
import 'package:doppelkopf/pages/home.dart';
import 'package:doppelkopf/pages/startGame.dart';
void main() => runApp(MaterialApp(
  initialRoute: "/loadingScreen",
  routes: {
    "/loadingScreen": (context) => LoadingScreen(),
    "/home": (context) => Home(),
    "/startGame": (context) => StartGame(),
    "/players": (context) => Players(),

  },
  )
);

