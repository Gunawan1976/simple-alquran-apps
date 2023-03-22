import 'package:flutter_alquran/app/models/juz_model.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class DetailJuzController extends GetxController {
  int index = 0;
  final player = AudioPlayer(); // Create a player
  Verses? lastVerse;

  void playAudio(Verses? ayat) async {
    if (ayat?.audio?.primary != null) {
      try {
        if (lastVerse == null) {
          lastVerse = ayat;
        }
        lastVerse!.kondisiAudio = "stop";
        lastVerse = ayat;
        lastVerse!.kondisiAudio = "stop";
        update();
        await player.stop();
        await player.setUrl(ayat!.audio!.primary!);
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

  void pauseAudio(Verses ayat) async {
    await player.pause();
    ayat.kondisiAudio = "pause";
    update();
  }

  void resumeAudio(Verses ayat) async {
    ayat.kondisiAudio = "playing";
    update();
    await player.play();
    ayat.kondisiAudio = "stop";
    update();
  }

  void stopAudio(Verses ayat) async {
    player.stop();
    ayat.kondisiAudio = "stop";
    update();
  }

  @override
  void onClose() {
    player.stop();
    super.onClose();
  }
}
