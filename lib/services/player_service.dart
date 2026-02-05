import 'package:sqflite/sqflite.dart';

import '../models/player_profile.dart';
import '../models/rating.dart';
import 'db_service.dart';

class PlayerService {
  PlayerService._();

  static final PlayerService instance = PlayerService._();

  Future<List<PlayerProfile>> fetchPlayers() async {
    final db = await DbService.instance.database;
    final results = await db.query('player_profiles', orderBy: 'name ASC');
    return results.map(PlayerProfile.fromMap).toList();
  }

  Future<double> fetchOverallRating(int playerProfileId) async {
    final db = await DbService.instance.database;
    final results = await db.query(
      'ratings',
      where: 'player_profile_id = ?',
      whereArgs: [playerProfileId],
    );
    if (results.isEmpty) {
      return 0;
    }
    final ratings = results.map(Rating.fromMap).toList();
    final total = ratings.fold<double>(
      0,
      (sum, rating) => sum + (rating.skill + rating.speed + rating.physical) / 3,
    );
    return total / ratings.length;
  }

  Future<void> saveRating(Rating rating) async {
    final db = await DbService.instance.database;
    await db.insert(
      'ratings',
      rating.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Rating>> fetchRatingsForPlayer(int playerProfileId) async {
    final db = await DbService.instance.database;
    final results = await db.query(
      'ratings',
      where: 'player_profile_id = ?',
      whereArgs: [playerProfileId],
      orderBy: 'created_at DESC',
    );
    return results.map(Rating.fromMap).toList();
  }
}
