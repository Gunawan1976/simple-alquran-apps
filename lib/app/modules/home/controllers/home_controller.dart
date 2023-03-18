import 'dart:convert';

import 'package:flutter_alquran/app/models/juz_model.dart';
import 'package:flutter_alquran/app/models/surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  List<Surah> allSurah = [];
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
