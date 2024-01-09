class MatchModel {
  final String? id;
  final String player1id;
  final String player2id;

  const MatchModel({
    this.id,
    required this.player1id,
    required this.player2id,
  });

  toJson() {
    return {
      "id": id,
      "player1id": player1id,
      "player2id": player2id,
    };
  }

  factory MatchModel.fromJson(Map<dynamic, dynamic> json) {
    return MatchModel(
        id: json['id'] as String?,
        player1id: json['player1id'] as String,
        player2id: json['player2id'] as String,
      );
  }
}
