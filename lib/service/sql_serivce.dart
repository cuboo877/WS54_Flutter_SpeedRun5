// ignore: camel_case_types
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data_model.dart';

class sql {
  static Database? database;
  static String userTable = "users";
  static String passwordTable = "passwords";

  static Future<Database> _initDatabase() async {
    database = await openDatabase(join(await getDatabasesPath(), "ws54.db"),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE $userTable (id TEXT PRIMARY KEY, username TEXT, account TEXT, password TEXT, birthday TEXT)");
      await db.execute(
          "CREATE TABLE $passwordTable (id TEXT PRIMARY KEY, userID TEXT , tag TEXT , url TEXT, login TEXT, password TEXT, isFav INTEGER, FOREIGN KEY (userID) REFERENCES users (id))");
    }, version: 3);
    return database!;
  }

  static Future<Database> getDBConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await _initDatabase();
    }
  }
}

class UserDAO {
  static Future<UserData> getUserDataByUserID(String userID) async {
    final database = await sql.getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query(sql.userTable, where: "id = ?", whereArgs: [userID]);
    Map<String, dynamic> result = maps.first;
    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<UserData> getUserDataByAccount(String account) async {
    final database = await sql.getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query(sql.userTable, where: "account = ?", whereArgs: [account]);
    Map<String, dynamic> result = maps.first;
    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<UserData> getUserDataByAccountAndPassword(
      String account, String password) async {
    final database = await sql.getDBConnect();

    List<Map<String, dynamic>> maps = await database.query(sql.userTable,
        where: "account = ? AND password = ?", whereArgs: [account, password]);

    Map<String, dynamic> result = maps.first;

    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<void> addUserData(UserData userData) async {
    final database = await sql.getDBConnect();
    await database.insert(sql.userTable, userData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateUserData(UserData userData) async {
    final database = await sql.getDBConnect();
    await database.update(sql.userTable, userData.toJson(),
        where: "id = ?",
        whereArgs: [userData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class PasswordDAO {
  static Future<List<PasswordData>> getPasswordListDataByUserID(
      String userID) async {
    final database = await sql.getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query(sql.passwordTable, where: "userID = ?", whereArgs: [userID]);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]["id"],
          maps[index]["userID"],
          maps[index]["tag"],
          maps[index]["url"],
          maps[index]["login"],
          maps[index]["password"],
          maps[index]["isFav"]);
    });
  }

  static Future<List<PasswordData>> getPasswordListDataByCondition(
      String userID,
      String tag,
      String url,
      String login,
      String password,
      String id,
      bool hasFav,
      int isFav) async {
    final database = await sql.getDBConnect();
    String whereCondition = "userID = ?";
    List whereArgs = [userID];

    if (tag.trim().isNotEmpty) {
      whereCondition += "AND tag LIKE ?";
      whereArgs.add("%$tag%");
    }
    if (url.trim().isNotEmpty) {
      whereCondition += "AND url LIKE ?";
      whereArgs.add("%$url%");
    }
    if (login.trim().isNotEmpty) {
      whereCondition += "AND login LIKE ?";
      whereArgs.add("%$login%");
    }
    if (password.trim().isNotEmpty) {
      whereCondition += "AND password LIKE ?";
      whereArgs.add("%$password%");
    }
    if (id.trim().isNotEmpty) {
      whereCondition += "AND id LIKE ?";
      whereArgs.add("%$id%");
    }
    if (hasFav) {
      whereCondition += "AND isFav = ?";
      whereArgs.add(isFav);
    }

    List<Map<String, dynamic>> maps = await database.query(sql.passwordTable,
        where: whereCondition, whereArgs: whereArgs);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]["id"],
          maps[index]["userID"],
          maps[index]["tag"],
          maps[index]["url"],
          maps[index]["login"],
          maps[index]["password"],
          maps[index]["isFav"]);
    });
  }

  static Future<void> addPasswordData(PasswordData passwordData) async {
    final database = await sql.getDBConnect();
    await database.insert(sql.passwordTable, passwordData.toJson());
  }

  static Future<void> upadtePasswordData(PasswordData passwordData) async {
    final database = await sql.getDBConnect();
    await database.update(sql.passwordTable, passwordData.toJson(),
        where: "id = ?", whereArgs: [passwordData.id]);
  }

  static Future<void> deletePasswordDataByPasswordID(String passwordID) async {
    final database = await sql.getDBConnect();
    await database
        .delete(sql.passwordTable, where: "id = ?", whereArgs: [passwordID]);
  }
}
