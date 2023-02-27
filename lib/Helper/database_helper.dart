import 'package:path/path.dart';
import 'package:quote_app/model/quotes_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = "Database.db";

  static const table = "quotes";

  static const databaseVersion = 1;

  static const columnId = "_id";
  static const columnCategory = "category";
  static const columnQuote = "quote";
  static const columnImage = "image";
  static const columnSlider = "slider";
  var result;

  static Database? _database;

  static Future<Database?> get database async {
    final databasePath = await getDatabasesPath();
    final status = await databaseExists(databasePath);
    if(!status || status != null) {
      _database = await openDatabase(
        join(databasePath, databaseName),
        version: databaseVersion,
        onCreate: (database, version) {
          return database.execute(
            "CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnCategory TEXT, $columnQuote TEXT, $columnImage BLOB)"
          );
        }
      );
    }
    return _database;
  }

  insertData(Quotes quotes) async {
    final db = await database;
    await db!.insert(table, quotes.toMap());
  }

  readData() async {
    final db = await database;
    result = await db!.query(table);
    print(result);
  }

  getQuotes() async {
    final db = await database;
    List<Map> list = await db!.rawQuery("SELECT * FROM $table");
    List<Quotes> quotes = [];
    for(int i = 0 ; i < list.length ; i++) {
      quotes.add(Quotes(category: list[i]['category'], quote: list[i]['quote'], image: list[i]['image']));
    }
    return quotes;
  }

  updateData({Map<String, dynamic>? row, String? table, String? id}) async {
    final db = await database;
    await db!.update(table!, row!, where: "$columnId = ?", whereArgs: [id]);
  }

  deleteData(int id) async{
    final db = await database;
    await db!.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

}