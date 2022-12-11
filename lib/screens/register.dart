import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:image_picker/image_picker.dart';

import 'package:o_health/constants/input_decorations.dart';
import 'package:o_health/screens/login.dart';
import 'package:o_health/theme_config/theme_config.dart';

// enum ImageSourceType { gallery, camera }

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // var type;

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
                      height: 50,
                      child: Center(
                        child: Text(
                          "uploadAadhar".tr(),
                          style: ThemeConfig.textStyle,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("choose".tr()),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      var path = await ImagePicker.platform
                                          .pickImage(
                                              source: ImageSource.camera);
                                    },
                                    child: Text('camera'.tr())),
                                ElevatedButton(
                                    onPressed: () async {
                                      var path = await ImagePicker.platform
                                          .pickImage(
                                              source: ImageSource.gallery);
                                    },
                                    child: Text('gallery'.tr())),
                              ],
                            );
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
                        decoration: inputDecoration.copyWith(
                            hintText: 'aadharNumber'.tr())),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Card(
                    child: TextFormField(
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
                    color: Color(0xffDB4437),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => Login())));
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
