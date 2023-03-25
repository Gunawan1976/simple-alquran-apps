import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_alquran/app/constants/color.dart';
import 'package:flutter_alquran/app/db/bookmark.dart';
import 'package:flutter_alquran/app/models/detail_surah_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';

class DetailSurahController extends GetxController {
  var isPressed = false.obs;
  final player = AudioPlayer(); // Create a player
  Verse? lastVerse;
  DatabaseManager database = DatabaseManager.instance;

  void addBookmark(
      bool last_read, DetailSurah surah, Verse ayat, int indexAyat) async {
    Database db = await database.db;
    bool isFlaging = false;

    if (last_read == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkdata = await db.query("bookmark",
          where:
              "surah = '${surah.name.transliteration.id.replaceAll("'", "|")}' and ayat = ${ayat.number.inSurah} and juz = ${ayat.meta.juz} and via = 'surah' and index_ayat = $indexAyat and last_read = 0");
      if (checkdata.length != 0) {
        isFlaging = true;
      }
    }

    if (isFlaging == false) {
      await db.insert(
        "bookmark",
        {
          "surah":
              surah.name.transliteration.id.toString().replaceAll("'", "|"),
          "ayat": ayat.number.inSurah,
          "juz": ayat.meta.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": last_read == true ? 1 : 0,
        },
      );

      Get.back();
      Get.snackbar("Bookmark", "Berhasil menambah bookmark",
          colorText: appWhite);
    } else {
      Get.back();
      Get.snackbar("Bookmark", "Sudah tersedia", colorText: appWhite);
    }

    var data = await db.query("bookmark");
    print(data);
  }

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

  void playAudio(Verse ayat) async {
    if (ayat.audio.primary != null) {
      try {
        if (lastVerse == null) {
          lastVerse = ayat;
        }
        lastVerse!.kondisiAudio = "stop";
        lastVerse = ayat;
        lastVerse!.kondisiAudio = "stop";
        update();
        await player.stop();
        await player.setUrl(ayat.audio.primary);
        ayat.kondisiAudio = "playing";
        update();
        await player.play();
        ayat.kondisiAudio = "stop";
        update();
        await player.stop();
      } on PlayerException catch (e) {
        // iOS/macOS: maps to NSError.code
        // Android: maps to ExoPlayerException.type
        // Web: maps to MediaError.code
        // Linux/Windows: maps to PlayerErrorCode.index
        print("Error code: ${e.code}");
        // iOS/macOS: maps to NSError.localizedDescription
        // Android: maps to ExoPlaybackException.getMessage()
        // Web/Linux: a generic message
        // Windows: MediaPlayerError.message
        print("Error message: ${e.message}");
      } on PlayerInterruptedException catch (e) {
        // This call was interrupted since another audio source was loaded or the
        // player was stopped or disposed before this audio source could complete
        // loading.
        print("Connection aborted: ${e.message}");
      } catch (e) {
        // Fallback for all other errors
        print('An error occured: $e');
      }

// Catching errors during playback (e.g. lost network connection)
      player.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace st) {
        if (e is PlayerException) {
          print('Error code: ${e.code}');
          print('Error message: ${e.message}');
        } else {
          print('An error occurred: $e');
        }
      });
    }
  }

  void pauseAudio(Verse ayat) async {
    await player.pause();
    ayat.kondisiAudio = "pause";
    update();
  }

  void resumeAudio(Verse ayat) async {
    ayat.kondisiAudio = "playing";
    update();
    await player.play();
    ayat.kondisiAudio = "stop";
    update();
  }

  void stopAudio(Verse ayat) async {
    player.stop();
    ayat.kondisiAudio = "stop";
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    player.stop();
    super.onClose();
  }
}
