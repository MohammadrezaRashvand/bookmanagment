import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookProvider {
  late Database db;
  late String path;

  Future open({String dbName: 'book.db'}) async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, dbName);

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Book (id INTEGER PRIMARY KEY, name TEXT, description TEXT)');
    });
  }

  Future insertRecord(int id, String name, String description) async {
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Book(id, name, description) VALUES($id, "$name", "$description")');
      print('inserted1: $id1');
    });
  }

  Future getRecords() async {
    List<Map> list = await db.rawQuery('SELECT * FROM Book');
    print('list: $list');
    return list;
  }

  Future updateRecord(int id, String name, String description) async {
    int count = await db.rawUpdate(
        'UPDATE Book SET name = ?, description = ? WHERE id = $id',
        [name, description]);
    print('updated: $count');
  }

  Future delete(int id) async {
    return await db.rawDelete('DELETE FROM Book WHERE id = ?', ["$id"]);
  }

  Future close() async => db.close();
}
