import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_alquran/app/models/detail_surah_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailSurahController extends GetxController {
  final player = AudioPlayer();

  Future<DetailSurah> getDetailSurah(String id) async {
    var response =
        await http.get(Uri.parse("https://api.quran.gading.dev/surah/$id"));
    Map<String, dynamic> data =
        (json.decode(response.body) as Map<String, dynamic>)["data"];
    // data.forEach(
    //   (element) {
    //     allUser.add(UserModel.fromJson(element));
    //   },
    // );
    return DetailSurah.fromJson(data);
  }

  void audio(String url) async {
    await player.setSourceUrl(url);
  }
}
