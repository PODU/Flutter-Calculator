import 'package:calculator/modals/Solution.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

class DBOperations {
  static Database db;
  static final String db_name = 'calculator.db';
  static int getVersion() => 1;

  static Future<void> init() async {
    if (DBOperations.db != null) {
      return;
    }
    try {
      String path = join(await getDatabasesPath(), db_name);
      db = await openDatabase(path, version: getVersion(), onCreate: onCreate);
    } catch (exp) {
      print(exp);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Calculations (timestamp STRING, expression STRING, solution STRING)');
  }

  static void insert(Solution solution) async {
    db.insert('Calculations', solution.toMap());
  }

  static Future<void> delete() async {
    await db.delete('Calculations');
  }

  static Future<List<Solution>> read() async {
    List<Map<String, dynamic>> list = await db.query('Calculations');
    List<Solution> res = new List();
    for (var entry in list) {
      res.add(Solution.fromMap(entry));
    }
    return res;
  }
}
