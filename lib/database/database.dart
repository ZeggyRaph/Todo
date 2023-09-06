import 'dart:io';

import 'package:my_todo/models/note_model.dart';
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

  //Creating functions that will interact with the database
Future<List<Map<String, dynamic>>> getNoteMapList() async{
  Database?   db = await this.db;
  final List<Map<String, dynamic>> result = await db!.query(noteTable);
  return result;
}

Future<List<Note>> getNoteList() async{
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();
    final List<Note> noteList = [];
    for (var noteMap in noteMapList) {
      noteList.add(Note.fromMap(noteMap));
    }
    noteList.sort((noteA, noteB) => noteA.date!.compareTo(noteB.date!));
    return noteList;
}

// This function will insert data into the database
Future<int> insertNote(Note note) async {
    Database? db = await this.db;
    final int result = await db!.update(
        noteTable, note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
    return result;
}


// This function will update data into the database
  Future<int> updateNote(Note note) async {
    Database? db = await this.db;
    final int result = await db!.update(
      noteTable, note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
    return result;
  }

  // This function will delete data from the database
  Future<int> deleteNote(int id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      noteTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }



}