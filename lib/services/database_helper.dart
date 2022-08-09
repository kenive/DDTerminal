import 'dart:async';
import 'dart:io';
import 'package:dd_terminal/model/host/host.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  static const String ip = 'host';
  static const String name = 'name';
  static const String password = 'pass';
  static const String port = 'port';
  static const String table = 'Host';

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initDB();
      return _database;
    }
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'database');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table (id INTEGER PRIMARY KEY AUTOINCREMENT,$ip TEXT, $name TEXT, $port TEXT, $password TEXT)");
  }

  newHost(Host host) async {
    final db = await database;
    var res = await db!.insert(
      table,
      host.toJson(),
    );
    return res;
  }

  updateHost(Host host) async {
    final db = await database;
    var res = await db!
        .update(table, host.toJson(), where: 'id = ?', whereArgs: [host.id]);
    return res;
  }

  getAllClients() async {
    final db = await database;

    var res = await db!.query(table, orderBy: 'id');

    List<Host> list =
        res.isNotEmpty ? res.map((e) => Host.fromJson(e)).toList() : [];

    return list;
  }

  delete(int id) async {
    var db = await database;
    var res = await db!.delete(table, where: 'id = ?', whereArgs: [id]);

    return res;
  }
}
