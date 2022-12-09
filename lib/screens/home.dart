import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEng = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('o-health'.tr()),
      ),
      drawer: const Drawer(
        child: DrawerHeader(
          child: Text('Menu Items'),
        ),
      ),
      body: Center(
        child: Text('helloWorld'.tr()),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (isEng) {
          EasyLocalization.of(context)!.setLocale(Locale('kn'));
          isEng = false;
        } else {
          EasyLocalization.of(context)!.setLocale(Locale('en'));
          isEng = true;
        }
      }),
    );
  }
}
