class Rating {
  const Rating({
    required this.id,
    required this.playerProfileId,
    required this.scoutAccountId,
    required this.skill,
    required this.speed,
    required this.physical,
    this.comment,
    required this.createdAt,
  });

  final int id;
  final int playerProfileId;
  final int scoutAccountId;
  final int skill;
  final int speed;
  final int physical;
  final String? comment;
  final DateTime createdAt;

  factory Rating.fromMap(Map<String, Object?> map) {
    return Rating(
      id: map['id'] as int,
      playerProfileId: map['player_profile_id'] as int,
      scoutAccountId: map['scout_account_id'] as int,
      skill: map['skill'] as int,
      speed: map['speed'] as int,
      physical: map['physical'] as int,
      comment: map['comment'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'player_profile_id': playerProfileId,
      'scout_account_id': scoutAccountId,
      'skill': skill,
      'speed': speed,
      'physical': physical,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
