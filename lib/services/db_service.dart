import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  DbService._();

  static final DbService instance = DbService._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'scout_mobile.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''
            'CREATE TABLE accounts('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name TEXT NOT NULL,'
            'email TEXT NOT NULL UNIQUE,'
            'password_hash TEXT NOT NULL,'
            'role TEXT NOT NULL'
            ')');
        await db.execute(''
            'CREATE TABLE player_profiles('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'account_id INTEGER NOT NULL,'
            'name TEXT NOT NULL,'
            'age INTEGER NOT NULL,'
            'position TEXT NOT NULL,'
            'height TEXT,'
            'weight TEXT,'
            'photo_path TEXT,'
            'video_path TEXT'
            ')');
        await db.execute(''
            'CREATE TABLE ratings('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'player_profile_id INTEGER NOT NULL,'
            'scout_account_id INTEGER NOT NULL,'
            'skill INTEGER NOT NULL,'
            'speed INTEGER NOT NULL,'
            'physical INTEGER NOT NULL,'
            'comment TEXT,'
            'created_at TEXT NOT NULL'
            ')');
      },
    );
  }
}
