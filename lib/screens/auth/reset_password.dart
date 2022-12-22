import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../../constants/decorations.dart';
import '../../theme_config/theme_config.dart';
import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final Box hiveObj = Hive.box('data');
  bool _obscureText1 = true;
  bool isLoading = false;
  bool isLoadingSubmit = false;
  bool _obscureText2 = true;
  late StateSetter st;

  final _key = GlobalKey<FormState>();

  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _newretypePasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "resetPassword".tr(),
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
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 5,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 68,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
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
                          cursorColor: Colors.redAccent,
                          controller: _newpasswordController,
                          obscureText: _obscureText1,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'passwordRequired'.tr()),
                            MinLengthValidator(6,
                                errorText: 'minimumLength'.tr()),
                          ]),
                          decoration: inputDecoration.copyWith(
                              hintText: 'newPassword'.tr(),
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
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'passwordRequired'.tr()),
                            MinLengthValidator(6,
                                errorText: 'minimumLength'.tr()),
                          ]),
                          cursorColor: Colors.redAccent,
                          controller: _newretypePasswordController,
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
                StatefulBuilder(
                  builder: (context, StateSetter innerState) {
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleRegister() async {
    st(() {
      isLoadingSubmit = true;
    });
  }
}
