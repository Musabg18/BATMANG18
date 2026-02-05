class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.accountId,
    required this.name,
    required this.age,
    required this.position,
    this.height,
    this.weight,
    this.photoPath,
    this.videoPath,
  });

  final int id;
  final int accountId;
  final String name;
  final int age;
  final String position;
  final String? height;
  final String? weight;
  final String? photoPath;
  final String? videoPath;

  factory PlayerProfile.fromMap(Map<String, Object?> map) {
    return PlayerProfile(
      id: map['id'] as int,
      accountId: map['account_id'] as int,
      name: map['name'] as String,
      age: map['age'] as int,
      position: map['position'] as String,
      height: map['height'] as String?,
      weight: map['weight'] as String?,
      photoPath: map['photo_path'] as String?,
      videoPath: map['video_path'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'name': name,
      'age': age,
      'position': position,
      'height': height,
      'weight': weight,
      'photo_path': photoPath,
      'video_path': videoPath,
    };
  }

  PlayerProfile copyWith({
    String? name,
    int? age,
    String? position,
    String? height,
    String? weight,
    String? photoPath,
    String? videoPath,
  }) {
    return PlayerProfile(
      id: id,
      accountId: accountId,
      name: name ?? this.name,
      age: age ?? this.age,
      position: position ?? this.position,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      photoPath: photoPath ?? this.photoPath,
      videoPath: videoPath ?? this.videoPath,
    );
  }
}
