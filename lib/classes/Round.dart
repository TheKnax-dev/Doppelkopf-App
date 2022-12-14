import 'package:doppelkopf/pages/players.dart';
import 'package:flutter/material.dart';
import 'package:doppelkopf/pages/home.dart';
import 'package:doppelkopf/pages/startGame.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Player.dart';

part 'Round.g.dart';

@JsonSerializable(explicitToJson: true)
class Round {
  Round(this.players);

  List<Player> players;
  List<Player> spectators;
  List<Player> winners = [];

  Player dealer;
  Team winningTeam;
  Solo soloPlayed = Solo.none;
  bool bockrunde = false;

  int winningTeamPoints = 120;
  int announcementsRe = 120;
  int announcementsContra = 120;
  int gesprochenRe = 0;
  int gesprochenContra = 0;

  List<ExtraPoint> extraPointsRe = [];
  List<ExtraPoint> extraPointsContra = [];

  int roundValue;

  void calculateRoundValue() {
    int announcementsWinningTeam;
    int announcementsLoosingTeam;
    List<ExtraPoint> extraPointsWinningTeam;
    List<ExtraPoint> extraPointsLoosingTeam;

    if (winningTeam == Team.re) {
      announcementsWinningTeam = announcementsRe;
      announcementsLoosingTeam = announcementsContra;

      extraPointsWinningTeam = extraPointsRe;
      extraPointsLoosingTeam = extraPointsContra;
    } else {
      announcementsWinningTeam = announcementsContra;
      announcementsLoosingTeam = announcementsRe;

      extraPointsWinningTeam = extraPointsContra;
      extraPointsLoosingTeam = extraPointsRe;
    }
    //Startpunkt für die extraPunkte Berechnung durch Punkte bestimmen
    if (soloPlayed == Solo.none) {
      if (winningTeam == Team.draw) {
        roundValue = 0;
        return;
      }
      roundValue = 1; //ein Punkt fürs gewinnen gibts immer

      roundValue += (winningTeamPoints - 120) ~/ 30;

      roundValue += ((announcementsWinningTeam - 120).abs().toInt()) ~/
          30; //Ansagen werden immer dem Gewinner zugerechnet, egal von wem Sie kommen
      roundValue += ((announcementsLoosingTeam - 120).abs().toInt()) ~/ 30;

      roundValue += gesprochenRe;
      roundValue += gesprochenContra;

      roundValue -= extraPointsLoosingTeam.length;
      roundValue += extraPointsWinningTeam.length;

      if (bockrunde) {
        roundValue *= 2;
      }
    }
  }

  Map<Player, double> getPlayerIncomes() {
    Map<Player, double> incomes = Map<Player, double>();

    double winnersShareRatio;
    double loosersShareRatio;

    if ((players.length / 2) > winners.length) {
      //weniger Gewinner
      winnersShareRatio = (players.length - winners.length) / winners.length;
      loosersShareRatio = 1;
    } else if ((players.length / 2) < winners.length) {
      //mehr Gewinner
      winnersShareRatio = 1;
      loosersShareRatio = winners.length / (players.length - winners.length);
    } else {
      winnersShareRatio = 1;
      loosersShareRatio = 1;
    }
    players.forEach((player) => winners.contains(player)
        ? incomes.putIfAbsent(player, () => (roundValue * winnersShareRatio))
        : incomes.putIfAbsent(
            player, () => (-(roundValue * loosersShareRatio))));

    return incomes;
  }

  factory Round.fromJson(Map<String, dynamic> data) => _$RoundFromJson(data);

  Map<String, dynamic> toJson() => _$RoundToJson(this);
}

enum ExtraPoint { fuchs, fuchsAmEnd, charlie, doppelkopf }

enum Team { re, contra, draw }

enum Solo { none, jack, queen, king, trump }

enum Announcement {
  re,
  reVorweg,
  contra,
  contraVorweg,
  keine90,
  keine60,
  keine30,
  schwarz,
}
