import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Uploadfiles extends StatefulWidget {
  const Uploadfiles({super.key});

  @override
  State<Uploadfiles> createState() => _UploadfilesState();
}

class _UploadfilesState extends State<Uploadfiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'o-health'.tr(),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      body: Center(
        child: RawMaterialButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text("Upload Files"),
          ),
          fillColor: Color.fromARGB(224, 238, 90, 102),
          focusColor: Color.fromARGB(224, 238, 90, 102),
          splashColor: Color.fromARGB(224, 238, 90, 102),
          hoverColor: Color.fromARGB(224, 238, 90, 102),
          shape: StadiumBorder(),
        ),
      ),
    );
  }
}
