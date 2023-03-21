import 'dart:convert';
import 'package:flutter_alquran/app/models/detail_surah_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class DetailSurahController extends GetxController {
  var isPressed = false.obs;
  final player = AudioPlayer(); // Create a player
  Verse? lastVerse;

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
