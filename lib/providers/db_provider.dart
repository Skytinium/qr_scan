import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  //Creamos un objeto de tipo database
  static Database? _database;
  //creamos una estructura tipo singleton donde crearemos una instancia de la clase
  //siempre accedemos a esta instancia de este objeto, para no ir crando una nueva BD
  static final DBProvider db = DBProvider._();

  //Constructor tipo privado
  DBProvider._();

  //Getter que retorna un objeto tipo Database
  Future<Database> get database async {
    _database ??= await initDB();

    return _database!;
  }

  //Metodo que realiza todas las tareas de inicialización del BD y las tablas
  Future<Database> initDB() async {
    //Obtener el path/ruta de nuestra BD
    Directory documentsDirectory = await getApplicationSupportDirectory();
    //definimos la variable que tiene que contener el path y el nombre de BD
    final path = join(documentsDirectory.path, 'Scans.db');
    print(path);

    //Creación de la DDBB
    return await openDatabase(
      path,
      version: 1, //si no cambia, retorna el mismo objeto BD creado
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        //se ejecuta cuando se crea la BD, ojo a las 6 comilla
        await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipus TEXT,
          valor TEXT
        )
      ''');
      },
    );
  }

  //Creación Inserts "todas las operaciones en BD serán async y devuelven un Future"
  //Este int es el id, instrucción sintaxis SQL (modelo largo)
  Future<int> inserRawScan(ScanModel nouScan) async {
    //variable id a partir del modelo creado
    final id = nouScan.id;
    //variable tipus a partir del modelo creado
    final tipus = nouScan.tipus;
    //variable valor a partir del modelo creado
    final valor = nouScan.valor;
    //Utilizamos el objeto database
    final db = await database;
    //creamos la variable para guardar el resultado
    //y utilizamos el objeto para realizar el insert
    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor)
        VALUES ($id, $tipus, $valor)
    ''');
    return res;
  }

  //Instrucción sintaxis predefinidas (modelo corto) con el mapeado
  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.insert(
        'Scans', nouScan.toMap()); //nombre de la tabla y los valores
    print(res);
    return res;
  }

  //Recuperar todos los Scans
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    //Si res no está vacio, mapea cada fila utilizamos la clase ScanModel y el
    //metodo el fromMap para tratar cada una de las filas, y pasamos todos los
    //elementos(e)  a una lista, si res está vacio devuelve una lista vacia.
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  //Retorna un ScanModel por Id
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {
      return ScanModel.fromMap(res.first);
    }
    return null;
  }

  //Select por tipus getScanPerTipus(String tipus) => lista de ScanModel
  Future<List<ScanModel>?> getScanByTipus(String tipus) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipus = '$tipus'
    ''');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  //Update
  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    final res = db.update('Scans', nouScan.toMap(),
        where: 'id = ?', whereArgs: [nouScan.id]);
    return res;
  }

  //Delete all, el de la papelera
  Future<int> deleteAllScan() async {
    final db = await database;
    final res = db.rawDelete('''
      DELETE FROM Scans
    ''');
    return res;
  }

  //Delete Scan
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }
}
