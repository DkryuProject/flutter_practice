import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  DatabaseHelper._internal();

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'todo.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        completed INTEGER
      )
    ''');
  }

  Future<int> insertTodo(Map<String, dynamic> todo) async {
    Database? db = await database;
    if (db != null) {
      return await db.insert('todo', todo);
    }
    return -1; // 또는 원하는 에러 처리 방식으로 수정해주세요.
  }

  Future<List<Map<String, dynamic>>> getAllTodos() async {
    Database? db = await database;
    if (db != null) {
      return await db.query('todo');
    }
    return []; // 또는 원하는 에러 처리 방식으로 수정해주세요.
  }
}