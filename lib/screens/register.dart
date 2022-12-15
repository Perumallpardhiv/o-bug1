import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:o_health/constants/decorations.dart';
import 'package:o_health/methods/methods.dart';
import 'package:o_health/services/auth_services.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
  final _key = GlobalKey<FormState>();
  final Box hiveObj = Hive.box('data');
  bool isLoading = false;
  bool isLoadingSubmit = false;
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
              Color.fromARGB(223, 227, 58, 58),
              Color.fromARGB(224, 238, 90, 102)
            ])),
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
            key: _key,
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
                    color: Colors.red.shade400,
                    minWidth: MediaQuery.of(context).size.width,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24))),
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
                  Container(
                    decoration: boxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        enabled: false,
                        validator: RequiredValidator(
                            errorText: 'Aadhar number is required'),
                        cursorColor: Colors.redAccent,
                        controller: _aadharController,
                        decoration: inputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.numbers),
                          hintText: 'aadharNumber'.tr(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Container(
                    decoration: boxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        validator: RequiredValidator(
                            errorText: 'Full name is required'),
                        enabled: false,
                        cursorColor: Colors.redAccent,
                        controller: _nameController,
                        decoration: inputDecoration.copyWith(
                            hintText: 'fullName'.tr(),
                            prefixIcon: const Icon(Icons.text_fields_rounded)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Container(
                    decoration: boxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Password is required'),
                          MinLengthValidator(6,
                              errorText: 'Minimum length is 8'),
                        ]),
                        cursorColor: Colors.redAccent,
                        controller: _passwordController,
                        decoration: inputDecoration.copyWith(
                          hintText: 'password'.tr(),
                          prefixIcon: const Icon(Icons.password_rounded),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 60,
                  ),
                  Container(
                    decoration: boxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        validator: (val) {
                          if (val.toString() != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                        },
                        cursorColor: Colors.redAccent,
                        controller: _retypePasswordController,
                        decoration: inputDecoration.copyWith(
                            hintText: 'confirmPassword'.tr(),
                            prefixIcon: const Icon(Icons.password_rounded)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  StatefulBuilder(builder: (context, StateSetter innerState) {
                    return isLoadingSubmit
                        ? Lottie.asset('assets/lottie/loader.json')
                        : GestureDetector(
                            onTap: () async {
                              innerState(() {
                                isLoadingSubmit = true;
                              });

                              if (_key.currentState!.validate()) {
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
                              }
                              innerState(() {
                                isLoadingSubmit = false;
                              });
                            },
                            child: Card(
                              color: Colors.red,
                              elevation: 4,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: SizedBox(
                                // width: MediaQuery.of(context).size.width / 2,
                                height: 56,
                                child: Center(
                                  child: Text(
                                    "submit".tr(),
                                    style: ThemeConfig.textStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  }),
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
                        child: Card(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: SizedBox(
                              width: 70,
                              height: 36,
                              child: Center(
                                child: Text(
                                  "Log-In".tr(),
                                  style: ThemeConfig.textStyle
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              )),
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
