import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_health/theme_config/theme_config.dart';

showSnackBar(BuildContext context, bool isError, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: TextStyle(fontFamily: GoogleFonts.aBeeZee().fontFamily),
    ),
    backgroundColor: isError ? Colors.red : Colors.greenAccent,
  ));
}

showImagePickerDialog(context, ImagePicker imagePicker) async {
  XFile? xFile = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                "uploadHere".tr(),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 50,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                  ))
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/aadhar_sample.jpg',
                height: 400,
              ),
              Text(
                "uploadFullAadhar".tr(),
                textAlign: TextAlign.center,
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                imagePicker
                    .pickImage(source: ImageSource.camera)
                    .then((xFile) => Navigator.of(context).pop(xFile));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return const Color.fromARGB(255, 255, 42, 0);
                }),
              ),
              child: Text(
                'camera'.tr(),
                style: ThemeConfig.textStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                imagePicker
                    .pickImage(source: ImageSource.gallery)
                    .then((xFile) => Navigator.of(context).pop(xFile));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return const Color.fromARGB(255, 255, 42, 0);
                }),
              ),
              child: Text('gallery'.tr(), style: ThemeConfig.textStyle),
            )
          ],
        );
      });
  return xFile;
}
