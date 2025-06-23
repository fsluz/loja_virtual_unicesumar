import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            username TEXT,
            password TEXT,
            firstname TEXT,
            lastname TEXT,
            city TEXT,
            street TEXT,
            number INTEGER,
            zipcode TEXT,
            lat TEXT,
            long TEXT,
            phone TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS cart(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            date TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS cart_products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cartId INTEGER,
            productId INTEGER,
            quantity INTEGER,
            title TEXT,
            price REAL,
            imageUrl TEXT       
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS favoritos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            productId INTEGER,
            dataFavorito TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS rating(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            productId INTEGER,
            rate REAL,
            count INTEGER,
            UNIQUE(userId, productId)
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS auth(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            token TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            date TEXT,
            status TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS order_products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderId INTEGER,
            productId INTEGER,
            quantity INTEGER,
            price REAL
          )
        ''');
      },
    );
  }
}
