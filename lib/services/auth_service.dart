import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import '../models/account.dart';
import '../models/player_profile.dart';
import 'db_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  Future<Account?> login({
    required String email,
    required String password,
  }) async {
    final db = await DbService.instance.database;
    final results = await db.query(
      'accounts',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (results.isEmpty) {
      return null;
    }
    final account = Account.fromMap(results.first);
    final hash = _hashPassword(password);
    if (account.passwordHash != hash) {
      return null;
    }
    return account;
  }

  Future<Account> createAccount({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final db = await DbService.instance.database;
    final hash = _hashPassword(password);
    final accountId = await db.insert('accounts', {
      'name': name,
      'email': email,
      'password_hash': hash,
      'role': role,
    });

    if (role == 'player') {
      await db.insert('player_profiles', {
        'account_id': accountId,
        'name': name,
        'age': 18,
        'position': 'Forward',
        'height': null,
        'weight': null,
        'photo_path': null,
        'video_path': null,
      });
    }

    return Account(
      id: accountId,
      name: name,
      email: email,
      passwordHash: hash,
      role: role,
    );
  }

  Future<PlayerProfile?> fetchProfileForAccount(int accountId) async {
    final db = await DbService.instance.database;
    final results = await db.query(
      'player_profiles',
      where: 'account_id = ?',
      whereArgs: [accountId],
      limit: 1,
    );
    if (results.isEmpty) {
      return null;
    }
    return PlayerProfile.fromMap(results.first);
  }

  Future<void> updateProfile(PlayerProfile profile) async {
    final db = await DbService.instance.database;
    await db.update(
      'player_profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
