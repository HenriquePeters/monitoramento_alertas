import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/event.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  Database? _db;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

  
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;

    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'monitoring.db');

    _db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, v) async {
          await db.execute('''
            CREATE TABLE events (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              type TEXT NOT NULL,
              source TEXT NOT NULL,
              timestamp TEXT NOT NULL,
              processedAt TEXT
            )
          ''');
        },
      ),
    );
  }


  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  
  Future<void> insertEvent(Event e) async {
    await _db?.insert('events', e.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Event>> getAllEvents() async {
    final rows = await _db?.query('events', orderBy: 'timestamp DESC') ?? [];
    return rows.map((r) => Event.fromMap(r)).toList();
  }
}
