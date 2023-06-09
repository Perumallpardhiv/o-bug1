import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:o_health/methods/methods.dart';
import 'package:o_health/screens/video_player/video_player.dart';
import 'package:o_health/services/audio_services.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'auth/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vibration/vibration.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  bool isEng = true;
  final Box hiveObj = Hive.box('data');

  //todo add lang id as string

  List<String> languages = ['en', 'kn', 'hi', /* 'ur', */ 'ml'];
  AudioServices audioServices = AudioServices();
  bool isVideoEnabled = false;
  bool isLoading = false;
  bool redirect = false;
  String? docID;
  String? url;
  @override
  Widget build(BuildContext context) {
    var user = hiveObj.get('userData');
    return ValueListenableBuilder(
      valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
      builder: (_, AdaptiveThemeMode mode, __) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
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
              child: const Padding(
                padding: EdgeInsets.only(
                  bottom: 6,
                  right: 12,
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Row(
                  children: const [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    Text(
                      '  UPLOAD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/upload-files');
                },
              ),
            ],
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
                      backgroundColor: Colors.red.shade500,
                      child: Text(
                        user['userName'].toString()[0],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    user['userName'].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis),
                  ),
                  subtitle: Text(
                    user['aadhar'].toString(),
                  ),
                ),
                const Divider(
                  height: 15,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.nightlight_round),
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
                  leading: const Icon(Icons.translate_rounded),
                  title: Text("chooseLang".tr()),
                  trailing: DropdownButton(
                    underline: const SizedBox(),
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
                        case 'hi':
                          lang = 'हिंदी';
                          break;
                        // case 'ur':
                        //   lang = 'اردو';
                        //   break;
                        case 'ml':
                          lang = 'डोगरी';
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
                ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: Text('Responses from Doctors'.tr()),
                  onTap: () {
                    Navigator.pushNamed(context, '/responces');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: Text('logout'.tr()),
                  onTap: () {
                    hiveObj.delete('userData');
                    hiveObj.put('isLoggedIn', false).then(
                          (value) => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (route) => false),
                        );
                  },
                ),
              ],
            ),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                alignment: Alignment.topCenter,
                child: isVideoEnabled
                    ? VideoScreen(
                        videoURL: url!,
                        docID: docID,
                        redirect: redirect,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            child: Lottie.asset('assets/lottie/doctor.json',
                                height: 240),
                          ),
                          Text('tellUs'.tr())
                        ],
                      ),
              ),
              const SizedBox(
                height: 80,
              ),
              Center(
                child: isLoading
                    ? Lottie.asset('assets/lottie/loader.json', height: 80)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 260,
                            height: 40,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 234, 108, 108),
                                  Colors.red,
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.mic,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'tapToRecord'.tr(),
                                            style: ThemeConfig.textStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ]),
                                  onTap: () async {
                                    if ((await Vibration.hasVibrator()) ==
                                        true) {
                                      Vibration.vibrate();
                                    }
                                    setState(() {
                                      isVideoEnabled = false;
                                    });
                                    await audioServices.start();
                                    await displayModalBottomSheet();
                                    await handleAudioProcessing();
                                    // ignore: use_build_context_synchronously
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isVideoEnabled = false;
                              });
                            },
                            icon: const Icon(
                              Icons.refresh,
                              size: 40,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
              )
            ],
          )),
        );
      },
    );
  }

  Future<void> displayModalBottomSheet() async {
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
                      AnimatedTextKit(repeatForever: true, animatedTexts: [
                        WavyAnimatedText('Recording...',
                            speed: const Duration(milliseconds: 200),
                            textStyle: const TextStyle(
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
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () async {
                          if ((await Vibration.hasVibrator()) == true) {
                            Vibration.vibrate().then((value) {
                              audioServices.stop();
                              Navigator.of(context).pop();
                            });
                          } else {
                            Navigator.of(context).pop();
                          }
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
  }

  handleAudioResp(resp) {
    if (resp != null &&
        resp["error"] == "Not able to recoginse... Try again...!") {
      setState(() {
        isLoading = false;
        showSnackBar(context, true, 'Not able to recoginse... Try again...!');
      });
    } else if (resp != null) {
      url = resp['videoURL'];
      setState(() {
        isVideoEnabled = true;
        isLoading = false;
        if (resp['redirectToVideoCall']) {
          docID = resp['doctorId'].toString();
          redirect = true;
        }
      });
    } else {
      setState(() {
        isLoading = false;
        showSnackBar(context, true, 'Not able to recoginse... Try again...!');
      });
    }
  }

  Future<void> handleAudioProcessing() async {
    setState(() {
      isLoading = true;
    });
    var audioFilePath = await audioServices.stop();
    var resp = await audioServices.sendAudioFile(
      File(audioFilePath),
      // ignore: use_build_context_synchronously
      EasyLocalization.of(context)!.currentLocale!.languageCode,
    );

    ///[based on response decide routing]
    handleAudioResp(resp);
  }
}
