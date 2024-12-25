import 'package:belajar_4_sqflite/models/mahasiswa_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Fungsi untuk mengambil Data
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Fungsi untuk membuat Database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'db_mahasiswa.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Fungsi untuk membuat Tabel
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mahasiswa (
        nim INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        jurusan TEXT NOT NULL
      )
    ''');
  }

  // Fungsi untuk menyimpan Data
  Future<int> insertMahasiswa(MahasiswaModel mahasiswa) async {
    final db = await database;
    return await db.insert('mahasiswa', mahasiswa.toMap());
  }

  // Fungsi untuk mengambil Data
  Future<List<MahasiswaModel>> getMahasiswa() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mahasiswa');

    return List.generate(maps.length, (i) {
      return MahasiswaModel.fromMap(maps[i]);
    });
  }

  // Fungsi untuk mengupdate Data
  Future<int> updateMahasiswa(MahasiswaModel mahasiswa) async {
    final db = await database;
    return await db.update(
      'mahasiswa',
      mahasiswa.toMap(),
      where: 'nim = ?',
      whereArgs: [mahasiswa.nim],
    );
  }

  // Fungsi untuk menghapus Data
  Future<int> deleteMahasiswa(int nim) async {
    final db = await database;
    return await db.delete('mahasiswa', where: 'nim = ?', whereArgs: [nim]);
  }
}
