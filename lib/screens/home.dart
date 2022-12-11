import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEng = true;
  bool isDark = false;
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xffDB4437),
                  Color.fromARGB(251, 248, 73, 67)
                ]),
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Logout'),
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setBool('isLoggedIn', false).then((value) =>
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (route) => false));
                  },
                ),
                ListTile(
                  title: const Text('Night Mode'),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (v) {
                      isDark = v;
                      if (v) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          body: Center(
            child: Text('helloWorld'.tr()),
          ),
          floatingActionButton: FloatingActionButton.extended(
              label: Text('changelang'.tr()),
              onPressed: () {
                if (isEng) {
                  EasyLocalization.of(context)!.setLocale(const Locale('kn'));
                  isEng = false;
                } else {
                  EasyLocalization.of(context)!.setLocale(const Locale('en'));
                  isEng = true;
                }
              }),
        );
      },
    );
  }
}
