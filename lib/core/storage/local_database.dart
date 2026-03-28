import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static const String _dbName = 'soulpet.db';
  static const int _dbVersion = 1;

  Database? _database;

  Database get db {
    if (_database == null) throw Exception('Database not initialized');
    return _database!;
  }

  Future<void> init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createUsersTable);
    await db.execute(_createPetsTable);
    await db.execute(_createPetActionsTable);
    await db.execute(_createInventoryTable);
    await db.execute(_createChatHistoryTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations here
  }

  static const String _createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      email TEXT UNIQUE NOT NULL,
      username TEXT NOT NULL,
      avatar_url TEXT,
      coins INTEGER DEFAULT 0,
      onboarding_done INTEGER DEFAULT 0,
      pet_test_done INTEGER DEFAULT 0,
      house_id TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  static const String _createPetsTable = '''
    CREATE TABLE IF NOT EXISTS pets (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      archetype TEXT NOT NULL,
      gender TEXT NOT NULL,
      stage TEXT DEFAULT 'baby',
      level INTEGER DEFAULT 1,
      experience INTEGER DEFAULT 0,
      hunger INTEGER DEFAULT 100,
      energy INTEGER DEFAULT 100,
      happiness INTEGER DEFAULT 100,
      mood INTEGER DEFAULT 100,
      current_action TEXT DEFAULT 'idle',
      house_id TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const String _createPetActionsTable = '''
    CREATE TABLE IF NOT EXISTS pet_actions (
      id TEXT PRIMARY KEY,
      pet_id TEXT NOT NULL,
      action TEXT NOT NULL,
      triggered_by TEXT DEFAULT 'auto',
      performed_at TEXT NOT NULL,
      FOREIGN KEY (pet_id) REFERENCES pets(id)
    )
  ''';

  static const String _createInventoryTable = '''
    CREATE TABLE IF NOT EXISTS inventory (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      item_id TEXT NOT NULL,
      item_type TEXT NOT NULL,
      quantity INTEGER DEFAULT 1,
      acquired_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const String _createChatHistoryTable = '''
    CREATE TABLE IF NOT EXISTS chat_history (
      id TEXT PRIMARY KEY,
      pet_id TEXT NOT NULL,
      role TEXT NOT NULL,
      content TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (pet_id) REFERENCES pets(id)
    )
  ''';

  Future<void> close() async {
    await _database?.close();
  }
}
