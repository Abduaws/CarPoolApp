import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseController{
  Database? db;

  Future<Database?> getDatabase() async{
    if( db == null ){
      db = await initDatabase();
      return db;
    }
    else{
      return db;
    }
  }

  initDatabase() async {
    String databaseDestination = await getDatabasesPath();
    String databasePath = join(databaseDestination, 'carpool.db');
    Database db = await openDatabase (
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS 'USERS'(
          'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          'EMAIL' TEXT NOT NULL,
          'FullName' TEXT NOT NULL,
          'Phone' TEXT NOT NULL)
          ''');
        print("Database Created");
      },
      );
      return db;
  }

  execute(sql) async{
    Database? database = await getDatabase();
    var result = database!.execute(sql);
    return result;
  }

  query(sql) async {
    Database? database = await getDatabase();
    var result = database!.rawQuery(sql);
    return result;
  }

  insert(sql) async {
    Database? database = await getDatabase();
    var result = database!.rawInsert(sql);
    return result;
  }

  delete(sql) async {
    Database? database = await getDatabase();
    var result = database!.rawDelete(sql);
    return result;
  }

  update(sql) async {
    Database? database = await getDatabase();
    var result = database!.rawUpdate(sql);
    return result;
  }

  deleteDB() async{
    await deleteDatabase((await getDatabase())!.path);
  }
}
