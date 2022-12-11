import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
          title: Text("choose".tr()),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  imagePicker
                      .pickImage(source: ImageSource.camera)
                      .then((xFile) => Navigator.of(context).pop(xFile));
                },
                child: Text('camera'.tr())),
            ElevatedButton(
                onPressed: () async {
                  imagePicker
                      .pickImage(source: ImageSource.gallery)
                      .then((xFile) => Navigator.of(context).pop(xFile));
                },
                child: Text('gallery'.tr())),
          ],
        );
      });
  return xFile;
}
