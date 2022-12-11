import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:o_health/constants/input_decorations.dart';
import 'package:o_health/screens/login.dart';
import 'package:o_health/services/auth_services.dart';
import 'package:o_health/theme_config/theme_config.dart';

// enum ImageSourceType { gallery, camera }

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // var type;
  ImagePicker imagePicker = ImagePicker();
  TextEditingController _aadharController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "register".tr(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MaterialButton(
                    color: const Color(0xffDB4437),
                    minWidth: MediaQuery.of(context).size.width,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SizedBox(
                      height: 80,
                      child: Center(
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 6,
                                )
                              : Text(
                                  "uploadAadhar".tr(),
                                  style: ThemeConfig.textStyle,
                                )),
                    ),
                    onPressed: () async {
                      var path = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("choose".tr()),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      imagePicker
                                          .pickImage(source: ImageSource.camera)
                                          .then((xFile) => Navigator.of(context)
                                              .pop(xFile!.path));
                                    },
                                    child: Text('camera'.tr())),
                                ElevatedButton(
                                    onPressed: () async {
                                      imagePicker
                                          .pickImage(
                                              source: ImageSource.gallery)
                                          .then((xFile) => Navigator.of(context)
                                              .pop(xFile!.path));
                                    },
                                    child: Text('gallery'.tr())),
                              ],
                            );
                          });
                      setState(() {
                        isLoading = true;
                      });
                      var resp = await AuthServices.sendAadharImage(File(path));

                      setState(() {
                        _aadharController.text =
                            jsonDecode(resp.body)['aadhaarNumber'].toString();
                        _nameController.text =
                            jsonDecode(resp.body)['userName'];
                        isLoading = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Card(
                    // color: Colors.white,
                    // elevation: 6,
                    // shadowColor: Colors.black,
                    child: TextFormField(
                        enabled: false,
                        controller: _aadharController,
                        decoration: inputDecoration.copyWith(
                            hintText: 'aadharNumber'.tr())),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Card(
                    child: TextFormField(
                      enabled: false,
                      controller: _nameController,
                      decoration:
                          inputDecoration.copyWith(hintText: 'fullName'.tr()),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Card(
                    child: TextFormField(
                      decoration:
                          inputDecoration.copyWith(hintText: 'password'.tr()),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Card(
                    child: TextFormField(
                      decoration: inputDecoration.copyWith(
                          hintText: 'confirmPassword'.tr()),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: const Color(0xffDB4437),
                    minWidth: MediaQuery.of(context).size.width,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "submit".tr(),
                          style: ThemeConfig.textStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text("already".tr())),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        child: const Text(
                          "Log-In",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
