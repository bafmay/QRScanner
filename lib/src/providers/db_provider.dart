
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  static Database _database; 
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (db,version) async{
        await db.execute(
          'CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')'
        );
      }
    );
  }

  nuevoScanRaw(ScanModel model) async{
    final db = await database;
    final res = await db.rawInsert(
      "INSERT INTO Scans(id,tipo,valor) "      
      "VALUES (${model.id},${model.tipo},${model.valor})"
    );
    return res;
  }

  nuevoScan(ScanModel model) async{
    final db = await database;
    final res = await db.insert('Scans', model.toJson());
    return res;
  }

  Future<ScanModel> getScanId(int id) async{
    final db = await database;
    final res = await db.query('Scans',where: 'id = ?',whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async{
    final db = await database;
    final res = await db.query('Scans');
    List<ScanModel> list = res.isNotEmpty ? res.map((item) => ScanModel.fromJson(item)).toList() : []; 
    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$tipo'");
    List<ScanModel> list = res.isNotEmpty ? res.map((item) => ScanModel.fromJson(item)).toList() : []; 
    return list;
  }

  Future<int> updateScan(ScanModel model) async {
    final db = await database;
    final res = await db.update('Scans', model.toJson(),where: 'id = ?',whereArgs: [model.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans',where: 'id = ?',whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll(int id) async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM Scans");
    return res;
  }

}