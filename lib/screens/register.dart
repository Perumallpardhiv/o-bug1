import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_health/constants/input_decorations.dart';
import 'package:o_health/methods/methods.dart';
import 'package:o_health/services/auth_services.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum ImageSourceType { gallery, camera }

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // var type;
  ImagePicker imagePicker = ImagePicker();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "register".tr(),
            style: const TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffDB4437),
                Color.fromARGB(255, 228, 92, 71)
              ]),
            ),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 5,
                  ),
                  Image.asset('assets/images/logo.png'),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 50,
                  ),
                  Text(
                    "welcomeBack".tr(),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 35, color: Colors.red),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 30,
                  ),
                  MaterialButton(
                    color: const Color(0xffDB4437),
                    minWidth: MediaQuery.of(context).size.width,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SizedBox(
                      height: 80,
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 6,
                              )
                            : Text(
                                "uploadAadhar".tr(),
                                style: ThemeConfig.textStyle,
                              ),
                      ),
                    ),
                    onPressed: () async {
                      await handleAutoFill();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  Card(
                    child: TextFormField(
                      enabled: false,
                      cursorColor: Colors.redAccent,
                      controller: _aadharController,
                      decoration: inputDecoration.copyWith(
                        hintText: 'aadharNumber'.tr(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Card(
                    child: TextFormField(
                      enabled: false,
                      cursorColor: Colors.redAccent,
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
                      cursorColor: Colors.redAccent,
                      controller: _passwordController,
                      decoration:
                          inputDecoration.copyWith(hintText: 'password'.tr()),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Card(
                    child: TextFormField(
                      cursorColor: Colors.redAccent,
                      controller: _retypePasswordController,
                      decoration: inputDecoration.copyWith(
                          hintText: 'confirmPassword'.tr()),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var resp = await AuthServices.register(
                        _nameController.text.trim(),
                        _passwordController.text.trim(),
                        _aadharController.text.trim(),
                      );

                      if (resp != null) {
                        (SharedPreferences.getInstance())
                            .then((pref) => pref.setBool('isLoggedIn', true));
                      } else {
                        showSnackBar(context, true, 'Some error');
                      }
                    },
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
                        child: Text(
                          "Log-In".tr(),
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

  handleAutoFill() async {
    XFile? xFile = await showImagePickerDialog(context, imagePicker);
    setState(() {
      isLoading = true;
    });
    if (xFile != null) {
      try {
        var resp = await AuthServices.sendAadharImage(File(xFile.path));

        if (resp != null) {
          setState(() {
            _aadharController.text =
                jsonDecode(resp.body)['aadhaarNumber'].toString();
            _nameController.text = jsonDecode(resp.body)['userName'];
            isLoading = false;
          });
        } else {
          setState(() {});
        }
      } catch (_) {}
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(context, true, 'noImageChosen'.tr());
    }
  }
}
