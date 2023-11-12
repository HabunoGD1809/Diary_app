import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'vivencia.dart'; // Asegúrate de importar tu modelo de datos aquí

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('vivencias.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE vivencias ( 
  id $idType, 
  titulo $textType,
  fecha $dateType,
  descripcion $textType,
  fotoPath $textTypeNullable,
  audioPath $textTypeNullable
  )
''');
  }

  // Insertar una vivencia en la base de datos
  Future<Vivencia> createVivencia(Vivencia vivencia) async {
    final db = await instance.database;
    final id = await db.insert('vivencias', vivencia.toMap());
    return vivencia.copy(id: id); // Devuelve la vivencia con el id asignado por la base de datos
  }

  // Leer todas las vivencias
  Future<List<Vivencia>> readAllVivencias() async {
    final db = await instance.database;
    final orderBy = 'fecha DESC';
    final result = await db.query('vivencias', orderBy: orderBy);

    return result.map((json) => Vivencia.fromMap(json)).toList();
  }

  // Leer una vivencia específica
  Future<Vivencia?> readVivencia(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'vivencias',
      columns: VivenciaFields.values,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Vivencia.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Actualizar una vivencia
  Future<int> updateVivencia(Vivencia vivencia) async {
    final db = await instance.database;

    return db.update(
      'vivencias',
      vivencia.toMap(),
      where: 'id = ?',
      whereArgs: [vivencia.id],
    );
  }

  // Eliminar una vivencia
  Future<int> deleteVivencia(int id) async {
    final db = await instance.database;

    return await db.delete(
      'vivencias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar todas las vivencias
  Future<int> deleteAllVivencias() async {
    final db = await instance.database;

    return await db.delete('vivencias');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

Vivencia copy({
  int? id,
  String? titulo,
  DateTime? fecha,
  String? descripcion,
  String? fotoPath,
  String? audioPath,
}) =>
    Vivencia(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      fotoPath: fotoPath ?? this.fotoPath,
      audioPath: audioPath ?? this.audioPath,
    );
