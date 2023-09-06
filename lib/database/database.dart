import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;
  DatabaseHelper._instance();

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database?> get db async {
    //If there is no, database, create database else initialize db
    _db ??= await _initDb();
    return _db;
  }

  //Initialize database
  Future<Database> _initDb() async{
   Directory dir = await getApplicationDocumentsDirectory();
   String path = '${dir.path}todo_list.db';
   final todoListDb = await openDatabase(
     path, version: 1, onCreate: _createDb
   );
   return todoListDb;

  }

  //Creates database
  void _createDb(Database db, int version) async{
    await db.execute(
      'CREATE TABLE $noteTable('
          '$colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colPriority TEXT, $colDate TEXT, $colStatus INTEGER )'
    );
  }

}