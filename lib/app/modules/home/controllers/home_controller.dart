import 'dart:convert';

import 'package:flutter_alquran/app/constants/color.dart';
import 'package:flutter_alquran/app/db/bookmark.dart';
import 'package:flutter_alquran/app/models/juz_model.dart';
import 'package:flutter_alquran/app/models/surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  DatabaseManager database = DatabaseManager.instance;

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead =
        await db.query("bookmark", where: "last_read = 1");

    print("cek data" + dataLastRead.toString());
    if (dataLastRead.length == 0) {
      return null;
    } else {
      return dataLastRead.first;
    }
  }

  deleteBookmark(int id) async {
    Database db = await database.db;
    update();
    await db.delete("bookmark", where: "id = $id");
    Get.snackbar("Bookmark", "Berhasil dihapus", colorText: appWhite);
    ;
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataBookmark =
        await db.query("bookmark", where: "last_read = 0");
    return dataBookmark;
  }

  Future<List<Surah>> getAllSurah() async {
    var response =
        await http.get(Uri.parse("https://api.quran.gading.dev/surah"));
    List data = (json.decode(response.body) as Map<String, dynamic>)["data"];
    // data.forEach(
    //   (element) {
    //     allUser.add(UserModel.fromJson(element));
    //   },
    // );
    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Juz>> getAllDetailJuz() async {
    List<Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      var response =
          await http.get(Uri.parse("https://api.quran.gading.dev/juz/$i"));
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>)["data"];
      allJuz.add(Juz.fromJson(data));
    }
    return allJuz;
  }
}
