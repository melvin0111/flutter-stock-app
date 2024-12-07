import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const String _dbName = 'stocks_journal.db';
  static const int _dbVersion = 1;
  static const String _tableName = 'journal';

  // Singleton instance
  static final DBHelper instance = DBHelper._internal();

  factory DBHelper() {
    return instance;
  }

  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
// All the print statements are for debugging purposes, you can also see my database working through the debug console
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    print('Database path: $path'); 
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stockName TEXT NOT NULL,
        notes TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Insert notes for each stock
  Future<int> insert(Map<String, dynamic> row) async {
      final db = await database;
      final id = await db.insert(_tableName, row);
      print('Inserted: $row with id: $id');
      return id;
  }

  // Fetch all notes
  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
      final db = await database;
      final result = await db.query(_tableName, orderBy: 'timestamp DESC');
      print('Fetched Notes: $result');
      return result;
  }

  // Delete a note
  Future<int> delete(int id) async {
      final db = await database;
      final deletedCount = await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
      print('Deleted note with id: $id');
      return deletedCount;
  }

  // Update a note
  Future<int> update(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update(_tableName, row, where: 'id = ?', whereArgs: [id]);
  }
}