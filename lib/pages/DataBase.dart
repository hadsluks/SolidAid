import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:urcab/pages/favRidesPage.dart';
import 'package:urcab/pages/prvRidePage.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  DBHelper.internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'favride.db');
    var db = openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE FAV(PICKUP_ADD TEXT, PICKUP_LAT TEXT, PICKUP_LNG TEXT, DROP_ADD TEXT, DROP_LAT TEXT, DROP_LNG TEXT);");

    //creating another table for previous rides with date time
    await db.execute(
        "CREATE TABLE HISTORY(PICKUP_ADD TEXT, PICKUP_LAT TEXT, PICKUP_LNG TEXT, DROP_ADD TEXT, DROP_LAT TEXT, DROP_LNG TEXT,BOOKED_DATE TEXT);");

    await db.execute("CREATE TABLE VIDEO_FAV(ID TEXT, TITLE TEXT)");

    await db.execute("CREATE TABLE FIRST_INSTALL(FIRST BOOL)");
    await db.execute("INSERT INTO FIRST_INSTALL(FIRST) VALUES(\'TRUE\')");
  }

  Future<void> addFav(FavRides fR) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        "INSERT INTO FAV(PICKUP_ADD, PICKUP_LAT, PICKUP_LNG, DROP_ADD, DROP_LAT, DROP_LNG) VALUES(\'${fR.pickUpAdd}\',\'${fR.pickUpLat.toString()}\',\'${fR.pickUpLng.toString()}\',\'${fR.dropOffAdd}\',\'${fR.dropOffLat.toString()}\',\'${fR.dropOffLng.toString()}\');");
  }

  Future<void> addHistory(Ride hR) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        "INSERT INTO HISTORY(PICKUP_ADD, PICKUP_LAT, PICKUP_LNG, DROP_ADD, DROP_LAT, DROP_LNG, BOOKED_DATE) VALUES(\'${hR.pickUpAddress}\',\'${hR.pickUpLat.toString()}\',\'${hR.pickUpLng.toString()}\',\'${hR.destinationAddress}\',\'${hR.dropOffLat.toString()}\',\'${hR.dropOffLng.toString()}\',\'${hR.bookedOn}\');");
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    var dbClient = await db;
    var list = (await dbClient.rawQuery("SELECT * FROM HISTORY")).toList();
    return list;
  }

  Future<List<Map<String, dynamic>>> getAllFav() async {
    var dbClient = await db;
    var list = (await dbClient.rawQuery("SELECT * FROM FAV")).toList();
    return list;
  }

  Future<void> removeFav(FavRides f) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        "DELETE FROM FAV WHERE PICKUP_LAT=\'${f.pickUpLat.toString()}\' AND PICKUP_LNG=\'${f.pickUpLng.toString()}\' AND DROP_LAT=\'${f.dropOffLat.toString()}\' AND DROP_LNG=\'${f.dropOffLng.toString()}\'");
  }

  Future<void> addVideoFav(String iD, String title) async {
    var dbClient = await db;
    await dbClient.rawInsert(
        "INSERT INTO VIDEO_FAV(ID, TITLE) VALUES(\'$iD\', \'$title\');");
  }

  Future<void> deleteVideoFav(String iD, String title) async {
    var dbClient = await db;
    await dbClient.rawDelete(
        "DELETE FROM VIDEO_FAV WHERE ID=\'$iD\' AND TITLE=\'$title\'");
  }

  Future<List<Map<String, dynamic>>> getVideoFav() async {
    var dbClient = await db;
    var list = (await dbClient.rawQuery("SELECT * FROM VIDEO_FAV")).toList();

    return list;
  }

  Future<bool> firstInstall() async {
    var dbClient = await db;
    var list =
        (await dbClient.rawQuery("SELECT * FROM FIRST_INSTALL")).toList();
    if (list[0]['FIRST'] == 'TRUE') {
      await dbClient.rawQuery("UPDATE FIRST_INSTALL SET FIRST=\'FALSE\'");
    }
    return list[0]['FIRST'] == 'TRUE';
  }
}
