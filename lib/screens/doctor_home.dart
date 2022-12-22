import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'auth/login.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  Box hive = Hive.box('data');
  List<String> languages = ['en', 'kn'];

  @override
  Widget build(BuildContext context) {
    var user = hive.get('userData');
    String localUserID = user['aadhar'];
    return ValueListenableBuilder(
      valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
      builder: ((context, mode, _) => Scaffold(
            appBar: AppBar(
              leading: Builder(builder: (BuildContext context) {
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
              }),
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
                  padding: EdgeInsets.only(bottom: 6, right: 12),
                ),
              ),
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
                      value: hive.get('isDarkTheme') ? true : false,
                      onChanged: (isDark) {
                        hive.put('isDarkTheme', isDark);
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
                      items: languages
                          .map<DropdownMenuItem<String>>((String value) {
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
                    leading: const Icon(Icons.logout_rounded),
                    title: Text('logout'.tr()),
                    onTap: () {
                      hive.delete('userData');
                      hive.put('isLoggedIn', false).then((value) =>
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (route) => false));
                    },
                  ),
                ],
              ),
            ),
            body: ZegoUIKitPrebuiltCallWithInvitation(
              appID: 241031027,
              appSign:
                  "8b288c15fbe24462410ca8ac2c313c96a2bee1360648fd8a161acdbd838101e9",
              userID: localUserID,
              userName: "user_$localUserID",
              plugins: [ZegoUIKitSignalingPlugin()],
              child: Center(
                child: Column(
                  children: [
                    Card(
                      child: Lottie.asset('assets/lottie/doctor.json',
                          height: 240),
                    ),
                    Text('Your ID is $localUserID'),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
