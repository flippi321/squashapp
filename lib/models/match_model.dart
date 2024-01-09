import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String? id;
  final Timestamp matchDate; 
  final String player1;
  final String player2;

  const MatchModel({
    this.id,
    required this.matchDate,
    required this.player1,
    required this.player2,
  });

  toJson() {
    return {
      "id": id,
      "matchdate" : matchDate,
      "player1": player1,
      "player2": player2,
    };
  }

  factory MatchModel.fromJson(Map<dynamic, dynamic> json) {
    return MatchModel(
        id: json['id'] as String?,
        matchDate: json['matchdate'] as Timestamp,
        player1: json['player1'] as String,
        player2: json['player2'] as String,
      );
  }
}
