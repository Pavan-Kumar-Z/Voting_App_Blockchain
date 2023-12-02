import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'user_credentials.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE credentials(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)",
        );
        db.execute(
          "CREATE TABLE elections(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, candidateName TEXT, otherDetails TEXT)",
        );
        // Insert preset credentials for Voter and Admin here
        _insertPresetCredentials(db, "1@.com", "1234");
        _insertPresetCredentials(db, "2@.com", "234");
      },
      version: 1,
    );
  }

  void _insertPresetCredentials(Database db, String email, String password) {
    db.insert(
      'credentials',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> checkCredentials(String email, String password) async {
    final Database db = await database;

    final List<Map<String, dynamic>> rows = await db.query(
      'credentials',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return rows.isNotEmpty;
  }

  // Save election details to the database
  Future<void> saveElectionDetails(
      String title, String candidateName, String otherDetails) async {
    final db = await database;
    await db.insert(
      'elections',
      {
        'title': title,
        'candidateName': candidateName,
        'otherDetails': otherDetails,
      },
    );
  }

  // Retrieve election details from the database
  Future<List<Map<String, dynamic>>> getElectionDetails() async {
    final db = await database;
    return db.query('elections');
  }

  // Update election details in the database
  Future<void> updateElectionDetails(
      int id, String title, String candidateName, String otherDetails) async {
    final db = await database;
    await db.update(
      'elections',
      {
        'title': title,
        'candidateName': candidateName,
        'otherDetails': otherDetails,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
