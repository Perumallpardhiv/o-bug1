import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Uploadfiles extends StatefulWidget {
  const Uploadfiles({super.key});

  @override
  State<Uploadfiles> createState() => _UploadfilesState();
}

class _UploadfilesState extends State<Uploadfiles> {
  void oFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  List<PlatformFile> allFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'o-health'.tr(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          alignment: Alignment.bottomRight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(223, 227, 58, 58),
                Color.fromARGB(224, 238, 90, 102)
              ],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 6, right: 12),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/upload.json'),
              const SizedBox(height: 40),
              RawMaterialButton(
                onPressed: () async {
                  final result =
                      await FilePicker.platform.pickFiles(allowMultiple: true);

                  if (result == null) return;

                  // Selected Single File
                  // final file = result.files.first;
                  // oFile(file);
                  // print(file.name);
                  // print(file.path);
                  // print(file.size);
                  // print(file.extension);
                  // final newFile = await saveFilePermanently(file);
                  // print(file.path);
                  // print(newFile.path);

                  // Multilple Files
                  final files = result.files;
                  for (var file in files) {
                    !allFiles.contains(file) ? allFiles.add(file) : null;
                  }
                  setState(() {});
                },
                fillColor: const Color.fromARGB(224, 238, 90, 102),
                focusColor: const Color.fromARGB(224, 238, 90, 102),
                splashColor: const Color.fromARGB(224, 238, 90, 102),
                hoverColor: const Color.fromARGB(224, 238, 90, 102),
                shape: const StadiumBorder(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Upload Files",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    itemCount: allFiles.length,
                    itemBuilder: (context, index) {
                      var file1 = allFiles[index];
                      final kb = file1.size / 1024;
                      final mb = kb / 1024;
                      final fileSize = mb >= 1
                          ? '${mb.toStringAsFixed(2)} MB'
                          : '${kb.toStringAsFixed(2)} KB';
                      final extension = file1.extension ?? "none";
                      final color = getColor(extension);
                      return ListTile(
                        isThreeLine: false,
                        leading: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: getColor(extension),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            extension,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(file1.name),
                        subtitle: Text(fileSize),
                        // trailing: IconButton(
                        //   icon: Icon(Icons.arrow_outward_outlined),
                        //   onPressed: () {
                        //     oFile(file1);
                        //   },
                        // ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getColor(String extension) {
    return extension == 'pdf'
        ? Colors.red
        : extension == 'mp3'
            ? Colors.amber
            : extension == 'mp4'
                ? Colors.lightBlue
                : extension == 'jpeg'
                    ? Colors.pinkAccent
                    : extension == 'jpg'
                        ? Colors.pinkAccent
                        : Colors.purpleAccent;
  }

  // Future<File> saveFilePermanently(PlatformFile file) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final newFile = File('${appStorage.path}/${file.name}');
  //   return File(file.path!).copy(newFile.path);
  // }
}
