import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../objects/measurement.dart';
import 'package:flutter/foundation.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  DatabaseManager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "utility_toolset.db");

      return await openDatabase(
          path,
          version: 1,
          onCreate: _onCreate,
          onOpen: (db) {
          }
      );
    } catch (e) {
      rethrow;
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE measurements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        x REAL,
        y REAL,
        angle REAL,
        timestamp INTEGER,
        description TEXT
      )
    ''');
  }

  // CRUD

  Future<int> insertMeasurement(Measurement measurement) async {
    try {
      Database db = await database;

      int id = await db.insert('measurements', measurement.toMap());

      return id;
    } catch (e) {
      return -1;
    }
  }

  Future<List<Measurement>> getAllMeasurements() async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> maps = await db.query(
          'measurements',
          orderBy: "timestamp DESC"
      );
      return List.generate(maps.length, (i) => Measurement.fromMap(maps[i]));
    } catch (e) {
      return [];
    }
  }

  Future<int> deleteMeasurement(int id) async {
    try {
      Database db = await database;
      int count = await db.delete(
        'measurements',
        where: 'id = ?',
        whereArgs: [id],
      );
      return count;
    } catch (e) {
      return 0;
    }
  }
}