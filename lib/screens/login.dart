import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:o_health/screens/home.dart';
import 'package:o_health/screens/intros/login_intro.dart';
import 'package:o_health/screens/register.dart';
import '../constants/decorations.dart';
import '../methods/methods.dart';
import '../models/user_model.dart';
import '../services/auth_services.dart';
import '../theme_config/theme_config.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final Box hiveObj = Hive.box('data');
  bool isLoading = false;
  bool _obscureText = true;
  late StateSetter innerState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "logIn".tr(),
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(223, 227, 58, 58),
            Color.fromARGB(224, 238, 90, 102)
          ])),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: RequiredValidator(errorText: 'aadharReq'.tr()),
                      cursorColor: Colors.redAccent,
                      controller: _aadharController,
                      decoration: inputDecoration.copyWith(
                          hintText: 'aadharNumber'.tr(),
                          prefixIcon: const Icon(Icons.numbers_rounded)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 26,
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
                          validator: RequiredValidator(
                              errorText: 'passwordRequired'.tr()),
                          cursorColor: Colors.redAccent,
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: inputDecoration.copyWith(
                            hintText: 'password'.tr(),
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                innerState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 20,
                ),
                GestureDetector(
                  child: Text(
                    "forgetPassword?".tr(),
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context)..pushNamed('/forgot-password');
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 20,
                ),
                StatefulBuilder(builder: (builder, StateSetter st) {
                  innerState = st;
                  return isLoading
                      ? Center(
                          child: Lottie.asset('assets/lottie/loader.json',
                              width: 50, height: 50))
                      : Padding(
                          padding: const EdgeInsets.only(left: 14.0, right: 14),
                          child: GestureDetector(
                            onTap: () async {
                              handleLogin();
                            },
                            child: Card(
                              color: Colors.red,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: SizedBox(
                                height: 50,
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
                  height: MediaQuery.of(context).size.width / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("don'tHave".tr())),
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
                              "signUp".tr(),
                              style: ThemeConfig.textStyle
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const Register()),
                        ));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleLogin() async {
    innerState(() {
      isLoading = true;
    });
    if (_key.currentState!.validate()) {
      var resp = await AuthServices.login(
        _passwordController.text.trim(),
        _aadharController.text.trim(),
      );
      if (resp.hasError) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, false, resp.errorMsg);
      } else {
        hiveObj.put('isLoggedIn', true);
        User user = User.fromJson(resp.data);
        hiveObj.put('userData', {
          'userName': user.userName,
          'aadhar': user.userAadharNumber,
          'language': user.defaultLang,
          'role': user.userRole
        });

        // ignore: use_build_context_synchronously
        if (hiveObj.get('isLoginIntroSeen')) {
          // ignore: use_build_context_synchronously
          Navigator.of(context)
              .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Home()),
                  (Route<dynamic> route) => false)
              .then((_) => showSnackBar(context, false, 'loggedIn'.tr()));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginIntroVideo(),
              ),
              (Route<dynamic> route) => false);
        }
      }
    }
    innerState(() {
      isLoading = false;
    });
  }
}
