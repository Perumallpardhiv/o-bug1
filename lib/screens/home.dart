import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
            title: Text('o-health'.tr()),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
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
