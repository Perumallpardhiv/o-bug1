import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_health/constants/input_decorations.dart';
import 'package:o_health/methods/methods.dart';
import 'package:o_health/services/auth_services.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

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
  final Box hiveObj = Hive.box('data');
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
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
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
                  Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 50,
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
                      height: 60,
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
                  GestureDetector(
                    onTap: () async {
                      var resp = await AuthServices.register(
                        _nameController.text.trim(),
                        _passwordController.text.trim(),
                        _aadharController.text.trim(),
                      );

                      if (resp != null) {
                        hiveObj.put('isLoggedInt', true);
                      } else {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, true, 'Some error');
                      }
                    },
                    child: Card(
                      color: Colors.red,
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: SizedBox(
                        // width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        child: Center(
                          child: Text(
                            "submit".tr(),
                            style: ThemeConfig.textStyle,
                          ),
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
                          style: const TextStyle(color: Colors.red),
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
