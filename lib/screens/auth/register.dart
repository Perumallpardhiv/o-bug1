import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:o_health/constants/decorations.dart';
import 'package:o_health/methods/methods.dart';
import 'package:o_health/models/user_model.dart';
import 'package:o_health/services/auth_services.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../home.dart';
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
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool isAadharUploaded = false;
  late StateSetter st;
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
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  AdaptiveTheme.of(context).mode.isDark
                      ? 'assets/images/logo_dark.png'
                      : 'assets/images/logo.png',
                  height: 60,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 50,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/loader.json',
                              height: 50,
                              width: 50,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('pleaseWait'.tr()),
                            )
                          ],
                        )
                      : MaterialButton(
                          color: Colors.red.shade400,
                          minWidth: MediaQuery.of(context).size.width,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera, color: Colors.white),
                                const SizedBox(
                                  width: 20,
                                ),
                                Center(
                                  child: Text(
                                    isAadharUploaded
                                        ? "uploadAgain".tr()
                                        : "uploadAadhar".tr(),
                                    style: ThemeConfig.textStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            await handleAutoFill();
                          },
                        ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                Container(
                  decoration: boxDecoration.copyWith(
                    color: hiveObj.get('isDarkTheme')
                        ? const Color.fromARGB(255, 67, 67, 67)
                        : Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width - 28,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: TextFormField(
                      enabled: false,
                      validator: RequiredValidator(errorText: 'aadharReq'.tr()),
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
                  decoration: boxDecoration.copyWith(
                    color: hiveObj.get('isDarkTheme')
                        ? const Color.fromARGB(255, 67, 67, 67)
                        : Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width - 28,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: TextFormField(
                      validator:
                          RequiredValidator(errorText: 'fullNameReq'.tr()),
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
                  decoration: boxDecoration.copyWith(
                    color: hiveObj.get('isDarkTheme')
                        ? const Color.fromARGB(255, 67, 67, 67)
                        : Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width - 28,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter innerState) {
                        return TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'passwordRequired'.tr()),
                            MinLengthValidator(6,
                                errorText: 'minimumLength'.tr()),
                          ]),
                          cursorColor: Colors.redAccent,
                          controller: _passwordController,
                          obscureText: _obscureText1,
                          decoration: inputDecoration.copyWith(
                              hintText: 'password'.tr(),
                              prefixIcon: const Icon(Icons.password_rounded),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  innerState(
                                    () {
                                      _obscureText1 = !_obscureText1;
                                    },
                                  );
                                },
                                child: Icon(_obscureText1
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Container(
                  decoration: boxDecoration.copyWith(
                    color: hiveObj.get('isDarkTheme')
                        ? const Color.fromARGB(255, 67, 67, 67)
                        : Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width - 28,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: StatefulBuilder(
                      builder: (BuildContext context, inState) {
                        return TextFormField(
                          validator: (val) {
                            if (val.toString() != _passwordController.text) {
                              return 'notMatch'.tr();
                            }
                            return null;
                          },
                          cursorColor: Colors.redAccent,
                          controller: _retypePasswordController,
                          obscureText: _obscureText2,
                          decoration: inputDecoration.copyWith(
                              hintText: 'confirmPassword'.tr(),
                              prefixIcon: const Icon(Icons.password_rounded),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  inState(
                                    () {
                                      _obscureText2 = !_obscureText2;
                                    },
                                  );
                                },
                                child: Icon(_obscureText2
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                StatefulBuilder(builder: (context, StateSetter innerState) {
                  st = innerState;
                  return isLoadingSubmit
                      ? Lottie.asset('assets/lottie/loader.json',
                          height: 50, width: 50)
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: GestureDetector(
                            onTap: () async {
                              handleRegister();
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
                                "logIn".tr(),
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
            isAadharUploaded = true;
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

  handleRegister() async {
    st(() {
      isLoadingSubmit = true;
    });

    if (_key.currentState!.validate()) {
      var resp = await AuthServices.register(
        _nameController.text.trim(),
        _passwordController.text.trim(),
        _aadharController.text.trim(),
      );

      if (resp != null) {
        hiveObj.put('isLoggedIn', true).then((_) {
          User user = User.fromJson(resp);
          hiveObj.put('userData', {
            'userName': user.userName,
            'aadhar': user.userAadharNumber,
            'language': user.defaultLang,
            'role': user.userRole
          });
          EasyLocalization.of(context)!.setLocale(
            Locale(user.defaultLang),
          );
        });

        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) => false)
            .then((_) => showSnackBar(context, false, 'loggedIn'.tr()));
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, true, 'error'.tr());
      }
    }
    st(() {
      isLoadingSubmit = false;
    });
  }
}
