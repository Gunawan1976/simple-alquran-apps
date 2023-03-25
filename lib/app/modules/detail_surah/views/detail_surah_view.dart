import 'package:flutter/material.dart';
import 'package:flutter_alquran/app/constants/color.dart';
import 'package:flutter_alquran/app/models/surah.dart';
import 'package:flutter_alquran/app/models/detail_surah_model.dart' as detail;
import 'package:flutter_alquran/app/modules/home/controllers/home_controller.dart';

import 'package:get/get.dart';

import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  Surah surah = Get.arguments;
  final homeC = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       Get.back();
        //       controller.stopAudio();
        //     },
        //     icon: Icon(
        //       Icons.arrow_back_ios_new,
        //     )),
        title: Text(surah.name.transliteration.id),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: () => Get.defaultDialog(
                contentPadding: EdgeInsets.all(15),
                //backgroundColor: Colors.deepPurple,
                title: "Tafsir",
                //titleStyle: TextStyle(color: appWhite),
                content: Container(
                  child: Text(
                    surah.tafsir.id,
                    textAlign: TextAlign.justify,
                    //style: TextStyle(color: appWhite),
                  ),
                )),
            child: Card(
              color: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      surah.name.transliteration.id.toUpperCase(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: appWhite),
                    ),
                    Text(
                      "( ${surah.name.translation.id} )",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: appWhite),
                    ),
                    Text(
                      "${surah.numberOfVerses} Ayat | ${surah.revelation.id}",
                      style: TextStyle(fontSize: 15, color: appWhite),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          FutureBuilder<detail.DetailSurah>(
            future: controller.getDetailSurah(surah.number.toString()),
            builder: (context, snapshot) {
              //print("tesing ${snapshot.data}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text("Tidak Ada Data"),
                );
              }
              SizedBox(height: 10);
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.verses.length,
                itemBuilder: (context, index) {
                  detail.Verse? ayat = snapshot.data?.verses[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GetBuilder<DetailSurahController>(
                                builder: (context) => Row(
                                  children: [
                                    (ayat!.kondisiAudio == "stop")
                                        ? IconButton(
                                            onPressed: () {
                                              context.playAudio(ayat);
                                            },
                                            icon: Icon(
                                                Icons.play_circle_fill_rounded))
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (ayat.kondisiAudio == "playing")
                                                  ? IconButton(
                                                      onPressed: () {
                                                        context
                                                            .pauseAudio(ayat);
                                                      },
                                                      icon: Icon(
                                                        Icons.pause,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        context
                                                            .resumeAudio(ayat);
                                                      },
                                                      icon: Icon(
                                                        Icons.stop,
                                                      ),
                                                    ),
                                              IconButton(
                                                onPressed: () {
                                                  context.stopAudio(ayat);
                                                },
                                                icon: Icon(
                                                  Icons.play_arrow,
                                                ),
                                              ),
                                            ],
                                          ),
                                    IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: "BOOKMARK",
                                            middleText: "Pilih Jenis Bookmark",
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  context.addBookmark(
                                                      true,
                                                      snapshot!.data!,
                                                      ayat,
                                                      index);
                                                  homeC.update();
                                                },
                                                child: Text("LAST READ"),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.deepPurple),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  context.addBookmark(
                                                      false,
                                                      snapshot!.data!,
                                                      ayat,
                                                      index);
                                                },
                                                child: Text("BOOKMARK"),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.deepPurple),
                                              )
                                            ]);
                                      },
                                      icon: Icon(
                                        Icons.bookmark_add_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            ayat!.text.arab,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        ayat.text.transliteration.en,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 15),
                      Text(
                        ayat.translation.id,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
