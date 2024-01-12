import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String? id;
  final Timestamp matchDate; 
  final String player1;
  final String player2;
  final int? p1scorechange;
  final int? p2scorechange;

  const MatchModel({
    this.id,
    required this.matchDate,
    required this.player1,
    required this.player2,
    this.p1scorechange,
    this.p2scorechange,
  });

  toJson() {
    return {
      "id": id,
      "matchdate" : matchDate,
      "player1": player1,
      "player2": player2,
      "p1scorechange" : p1scorechange,
      "p2scorechange" : p2scorechange,
    };
  }

  factory MatchModel.fromJson(Map<dynamic, dynamic> json) {
    return MatchModel(
        id: json['id'] as String?,
        matchDate: json['matchdate'] as Timestamp,
        player1: json['player1'] as String,
        player2: json['player2'] as String,
        p1scorechange: json['p1scorechange'] as int,
        p2scorechange: json['p2scorechange'] as int,
      );
  }
}
