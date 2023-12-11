import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasev2 {
  Database? mydatabase;

  Future<Database?> checkdata(db_name) async {
    if (mydatabase == null) {
      mydatabase = await creating(db_name);
      return mydatabase;
    } else {
      return mydatabase;
    }
  }

  int Version = 2;
  creating(db_name) async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, '${db_name}.db');
    if(db_name == "profile"){
      Database mydb =
      await openDatabase(mypath, version: Version, onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS 'profile'(
        'uid' TEXT NOT NULL PRIMARY KEY,
        'firstName' TEXT NOT NULL,
        'lastName' TEXT NOT NULL,
        'phone' TEXT NOT NULL,
        'age' TEXT NOT NULL,
        'grade' TEXT NOT NULL,
        )''');
      });
      return mydb;
    }else if(db_name == "history"){
      Database mydb =
      await openDatabase(mypath, version: Version, onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS 'history'(
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'id' INTEGER NOT NULL,
      'driver' TEXT NOT NULL,
      'date' TEXT NOT NULL,
      'time' TEXT NOT NULL,
      'from' TEXT NOT NULL,
      'to' TEXT NOT NULL,
      'price' INTEGER NOT NULL,
      'car' TEXT NOT NULL,
      'seats' INTEGER NOT NULL,
      'status' TEXT NOT NULL,
      'host' TEXT NOT NULL,
      )''');
      });
      return mydb;
    }
  }

  isexist() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'mynewdatafile2.db');
    await databaseExists(mypath) ? print("it exists") : print("not exist");
  }

  reseting() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'mynewdatafile2.db');
    await deleteDatabase(mypath);
  }

  reading(sql,db_name) async {
    Database? somevar = await checkdata(db_name);
    var myesponse = somevar!.rawQuery(sql);
    return myesponse;
  }

  write(sql,db_name) async {
    Database? somevar = await checkdata(db_name);
    var myesponse = somevar!.rawInsert(sql);
    return myesponse;
  }

  update(sql,db_name) async {
    print("updating");
    Database? somevar = await checkdata(db_name);
    var myesponse = somevar!.rawUpdate(sql);
    print("done update");
    return myesponse;
  }

  delete(sql,db_name) async {
    Database? somevar = await checkdata(db_name);
    var myesponse = somevar!.rawDelete(sql);
    return myesponse;
  }
}