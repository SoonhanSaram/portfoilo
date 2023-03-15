import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late Database _database;

class UserRespository {
  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    String dbPath = await getDatabasesPath();
    String dbFile = join(dbPath, "reselvation.db");

    return openDatabase(
      dbFile,
    );
  }

  update() async {}
}
