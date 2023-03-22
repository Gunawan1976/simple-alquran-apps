import 'package:flutter/material.dart';
import 'package:flutter_alquran/app/models/surah.dart';
import 'package:flutter_alquran/app/models/juz_model.dart' as juz;

import 'package:get/get.dart';

import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  juz.Juz detailJuz = Get.arguments["juz"];
  List<Surah> detailSurahInJuz = Get.arguments["surah"];
  @override
  Widget build(BuildContext context) {
    var titleJuz = detailJuz?.juz ?? "???";
    return Scaffold(
        appBar: AppBar(
          title: Text("Juz " + titleJuz.toString()),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: detailJuz.verses?.length,
          itemBuilder: (context, index) {
            if (detailJuz.verses == 0 || detailJuz.verses?.length == 0) {
              return Center(
                child: Text("Tidak Data"),
              );
            }
            juz.Verses ayat = detailJuz.verses![index];
            if (index != 0) {
              if (ayat.number!.inSurah == 1) {
                controller.index++;
              }
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //if (ayat.number!.inSurah == 1)
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.stretch,
                  //   children: [
                  //     GestureDetector(
                  //       // onTap: () => Get.defaultDialog(
                  //       //     contentPadding: EdgeInsets.all(15),
                  //       //     //backgroundColor: Colors.deepPurple,
                  //       //     title: "Tafsir",
                  //       //     //titleStyle: TextStyle(color: appWhite),
                  //       //     content: Container(
                  //       //       child: Text(
                  //       //         surah.tafsir.id,
                  //       //         textAlign: TextAlign.justify,
                  //       //         //style: TextStyle(color: appWhite),
                  //       //       ),
                  //       //     )),
                  //       child: Card(
                  //         color: Colors.deepPurple,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20)),
                  //         child: Padding(
                  //           padding: EdgeInsets.all(20),
                  //           child: Column(
                  //             children: [
                  //               Text(
                  //                 detailSurahInJuz[controller.index]
                  //                     .name
                  //                     .transliteration
                  //                     .id
                  //                     .toUpperCase(),
                  //                 style: TextStyle(
                  //                     fontSize: 20,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: appWhite),
                  //               ),
                  //               Text(
                  //                 "( ${detailSurahInJuz[controller.index].name.translation.id} )",
                  //                 style: TextStyle(
                  //                     fontSize: 15,
                  //                     fontWeight: FontWeight.w700,
                  //                     color: appWhite),
                  //               ),
                  //               Text(
                  //                 "${detailSurahInJuz[controller.index].numberOfVerses} Ayat | ${detailSurahInJuz[controller.index].revelation.id}",
                  //                 style:
                  //                     TextStyle(fontSize: 15, color: appWhite),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.deepPurple,
                                      child: Text(
                                        "${ayat.number!.inSurah}",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   detailSurahInJuz[controller.index]
                                  //       .name
                                  //       .transliteration
                                  //       .id,
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 15),
                                  // ),
                                ],
                              ),
                              GetBuilder<DetailJuzController>(
                                builder: (context) => Row(
                                  children: [
                                    (ayat.kondisiAudio == "stop")
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
                                      onPressed: () {},
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
                      Text(
                        ayat.text!.arab.toString(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                  Text(
                    ayat.text!.transliteration!.en.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 15),
                  Text(
                    ayat.translation!.id.toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
