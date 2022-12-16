import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEng = true;
  final Box hiveObj = Hive.box('data');
  List<String> languages = ['en', 'kn'];

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
                        "J",
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
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.red,
              label: Icon(Icons.mic),
              onPressed: () {}),
        );
      },
    );
  }
}
