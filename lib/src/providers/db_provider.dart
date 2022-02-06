import 'dart:io';
import 'package:api_to_sqlite/src/models/language_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Languages table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'programming_language_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE ProgrammingLanguages('
          'id INTEGER PRIMARY KEY,'
          'language TEXT,'
          'year_released TEXT,'
          'created_by TEXT,'
          'image TEXT,'
          'is_done INTEGER)');
    });
  }

  // Insert new language to Language table
  createLanguage(Language newLanguage) async {
    // await deleteAllLanguages();
    final db = await database;
    final res = await db?.insert('ProgrammingLanguages', newLanguage.toJson());
    return res;
  }

  // Update language
  Future<void> updateLanguage(Language language) async {
  // Get a reference to the database.
  final db = await database;

  // Update the given language.
  await db?.update(
    'ProgrammingLanguages',
    language.toJson(),
    // Ensure that the language has a matching id.
    where: 'id = ?',
    // Pass the language's id as a whereArg to prevent SQL injection.
    whereArgs: [language.id],
  );
}

  // Delete all languages
  Future<int?> deleteAllLanguages() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM ProgrammingLanguages');

    return res;
  }

  // Delete language
  Future<int?> deleteLanguage(String id) async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM ProgrammingLanguages WHERE id = $id');
    return res;
  }

  // Get language with a given name
  Future<List<Language?>> getLanguage(String name) async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM ProgrammingLanguages WHERE UPPER(language) = '${name.toUpperCase()}'");
    List<Language> list = res!.isNotEmpty ? res.map((c) => Language.fromJson(c)).toList() : [];

    return list.toList();
  }

  // Get all languages
  Future<List<Language?>> getAllLanguages() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM ProgrammingLanguages ORDER BY id DESC");

    List<Language> list = res!.isNotEmpty ? res.map((c) => Language.fromJson(c)).toList() : [];

    return list;
  }
}
