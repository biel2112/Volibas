import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE times(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE jogadores(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      posicao INTEGER,
      timeId INTEGER,
      disponivel INTEGER DEFAULT 1, -- Adicionar a coluna 'disponivel' com valor padrão 1
      FOREIGN KEY (timeId) REFERENCES times (id) ON DELETE SET NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE jogadores_times(
      jogador_id INTEGER,
      time_id INTEGER,
      FOREIGN KEY (jogador_id) REFERENCES jogadores (id),
      FOREIGN KEY (time_id) REFERENCES times (id)
    )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE jogadores ADD COLUMN disponivel INTEGER DEFAULT 1
    ''');
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'volei_app.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
