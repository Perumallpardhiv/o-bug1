import 'dart:convert';
import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:o_health/screens/video_call/invitation.dart';
import 'package:o_health/screens/video_player/video_player.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEng = true;
  final Box hiveObj = Hive.box('data');
  List<String> languages = ['en', 'kn'];
  var rec = Record();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
      builder: (_, AdaptiveThemeMode mode, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'o-health'.tr(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            flexibleSpace: Container(
                alignment: Alignment.bottomRight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(223, 227, 58, 58),
                    Color.fromARGB(224, 238, 90, 102)
                  ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6, right: 12),
                  child: DropdownButton(
                    underline: SizedBox(),
                    icon: const Icon(
                      Icons.translate,
                      color: Colors.white,
                    ),
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      String lang = '';
                      switch (value.toString()) {
                        case 'kn':
                          lang = 'ಕನ್ನಡ';
                          break;

                        case 'en':
                          lang = 'English';
                          break;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (v) {
                      EasyLocalization.of(context)!.setLocale(
                        Locale(
                          v!.toString(),
                        ),
                      );
                    },
                  ),
                )),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 10),
                    child: CircleAvatar(
                      radius: 45,
                      child: Text(
                        "A",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.red.shade500,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Abhilash shreedhar Hegde ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                ListTile(
                  leading: Icon(Icons.nightlight_round),
                  title: Text('nightMode'.tr()),
                  trailing: Switch(
                    value: hiveObj.get('isDarkTheme') ? true : false,
                    onChanged: (isDark) {
                      hiveObj.put('isDarkTheme', isDark);
                      if (isDark) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.translate_rounded),
                  title: Text("chooseLang".tr()),
                  trailing: DropdownButton(
                    underline: SizedBox(),
                    // hint: Text(
                    //   "Choose Language",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: hiveObj.get('isDarkTheme')
                    //         ? Colors.white
                    //         : Colors.black,
                    //   ),
                    // ),
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      String lang = '';
                      switch (value.toString()) {
                        case 'kn':
                          lang = 'ಕನ್ನಡ';
                          break;

                        case 'en':
                          lang = 'English';
                          break;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (v) {
                      EasyLocalization.of(context)!.setLocale(
                        Locale(
                          v!.toString(),
                        ),
                      );
                    },
                  ),
                ),
                // ListTile(),
                // ListTile(),
                ListTile(
                  leading: Icon(Icons.logout_rounded),
                  title: Text('logout'.tr()),
                  onTap: () {
                    hiveObj.put('isLoggedIn', false).then((value) =>
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (route) => false));
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: Text('tellUs'.tr()),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton.extended(
                backgroundColor: Colors.red,
                label: const Icon(Icons.mic),
                onPressed: () async {
                  await askPermission();
                  await start(await getPath());

                  await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return Center(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/lottie/recorder.json',
                                        height: 80, width: 80),
                                    // Icon(Icons.audio_file_rounded),
                                    AnimatedTextKit(
                                        repeatForever: true,
                                        animatedTexts: [
                                          WavyAnimatedText('Recording...',
                                              speed: const Duration(
                                                  milliseconds: 200),
                                              textStyle: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20,
                                              )),
                                        ]),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    MaterialButton(
                                      color: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () async {
                                        stop().then((_) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: const Text('Stop'),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                  //stop if back button was clicked

                  stop();

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const VideoScreen(
                          videoURL:
                              'https://ik.imagekit.io/uf0e6z5hc/Eng_-_Fever_uSDIAUoT4.mp4?ik-sdk-version=javascript-1.4.3&updatedAt=1667771216097',
                        );
                      },
                    ),
                  );
                },
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.red,
                onPressed: () {
                  var random = Random();
                  String id = '${random.nextInt(10000)}';
                },
                label: const Text('Call Doc'),
              )
            ],
          ),
        );
      },
    );
  }

  getPath() async {
    return (await getApplicationDocumentsDirectory()).path + '/temp.wav';
  }

  start(path) async {
    await rec.start(path: path, encoder: AudioEncoder.wav);
  }

  stop() async {
    String? savePath = await rec.stop();
    print('Stopped $savePath');
  }
}

askPermission() async {
  if (!await Permission.storage.isGranted) {
    await Permission.storage.request();
  }
  if (!await Permission.microphone.isGranted) {
    await Permission.microphone.request();
  }
  if (!await Permission.location.isGranted) {
    await Permission.location.request();
  }
}
