import 'package:flutter_alquran/app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alquran/app/models/surah.dart';
import 'package:flutter_alquran/app/models/juz_model.dart' as allJuz;
import 'package:flutter_alquran/app/modules/detail_surah/controllers/detail_surah_controller.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Al-Quran Apps'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Get.toNamed("/search"),
                icon: Icon(Icons.search))
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assalamualaikum, User",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(colors: [
                              Colors.deepPurple,
                              Colors.deepPurpleAccent
                            ])),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed("last-read");
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 150,
                              width: Get.width,
                              child: Stack(children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.menu_book,
                                              color: appWhite,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Terakhir Dibaca",
                                                style:
                                                    TextStyle(color: appWhite)),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Text("Al-Fatihah",
                                            style: TextStyle(
                                                color: appWhite,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold)),
                                        Text("Juz | Ayat",
                                            style: TextStyle(color: appWhite)),
                                      ]),
                                )
                              ]),
                            ),
                          ),
                        )),
                    TabBar(
                      labelColor: Colors.deepPurple,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.deepPurple,
                      tabs: [
                        Tab(
                          text: "Surah",
                        ),
                        Tab(
                          text: "Juz",
                        ),
                        Tab(
                          text: "Bookmark",
                        )
                      ],
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        FutureBuilder<List<Surah>>(
                          future: controller.getAllSurah(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text("Tidak Ada Data"),
                              );
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Surah surah = snapshot.data![index];
                                return ListTile(
                                  onTap: () {
                                    Get.toNamed("/detail-surah",
                                        arguments: surah);
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
                                    child: Text(
                                      surah.number.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    surah.name.transliteration.id,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      "${surah.numberOfVerses} ayat | ${surah.revelation.id}"),
                                  trailing: Text(surah.name.short),
                                );
                              },
                            );
                          },
                        ),
                        FutureBuilder<List<allJuz.Juz>>(
                          future: controller.getAllDetailJuz(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text("Tidak Ada Data"),
                              );
                            }
                            return ListView.builder(
                              itemCount: 30,
                              itemBuilder: (context, index) {
                                allJuz.Juz detailJuz = snapshot.data![index];
                                var detailStartJuz =
                                    detailJuz.juzStartInfo!.split(" - ").first;
                                var detailEndJuz =
                                    detailJuz.juzEndInfo!.split(" - ").first;

                                List<Surah> rawDataSurah = [];
                                List<Surah> dataSurahInJuz = [];

                                for (Surah element in controller.allSurah) {
                                  rawDataSurah.add(element);
                                  if (element.name.transliteration.id ==
                                      detailEndJuz) {
                                    break;
                                  }
                                }
                                for (Surah element
                                    in rawDataSurah.reversed.toList()) {
                                  dataSurahInJuz.add(element);
                                  if (element.name.transliteration.id ==
                                      detailStartJuz) {
                                    break;
                                  }
                                }
                                var startJuz = detailJuz?.juzStartInfo ??
                                    "tidak ada balikan data";
                                var EndJuz = detailJuz?.juzEndInfo ??
                                    "tidak ada balikan data";
                                return ListTile(
                                  onTap: () {
                                    Get.toNamed("/detail-juz", arguments: {
                                      "juz": detailJuz,
                                      "surah": dataSurahInJuz.reversed.toList()
                                    });
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    "Juz ${index + 1}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(startJuz + " | " + EndJuz),
                                );
                              },
                            );
                          },
                        ),
                        Text("dataz")
                      ]),
                    )
                  ])),
        ));
  }
}
