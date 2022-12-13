import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive/hive.dart';
import 'package:o_health/screens/register.dart';
import '../constants/input_decorations.dart';
import '../methods/methods.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "logIn".tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 5,
                ),
                Image.asset('assets/images/logo.png'),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 50,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: TextFormField(
                        validator: RequiredValidator(
                            errorText: 'Aadhar number is required'),
                        cursorColor: Colors.redAccent,
                        controller: _aadharController,
                        decoration: inputDecoration.copyWith(
                            hintText: 'aadharNumber'.tr())),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 60,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: TextFormField(
                        validator: RequiredValidator(
                            errorText: 'Password is required'),
                        cursorColor: Colors.redAccent,
                        controller: _passwordController,
                        decoration: inputDecoration.copyWith(
                            hintText: 'password'.tr())),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 10,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      AuthServices.login(
                              _passwordController.text, _aadharController.text)
                          .then(
                        (val) async {
                          if (val.hasError) {
                            showSnackBar(
                                context, false, 'invalidAadharPswd'.tr());
                          } else {
                            hiveObj
                                .put('isLoggedIn', true)
                                .then((value) => Navigator.of(context)
                                    .pushNamedAndRemoveUntil('/home',
                                        (Route<dynamic> route) => false))
                                .then((value) => showSnackBar(
                                    context, false, 'loggedIn'.tr()));
                          }
                        },
                      );
                    }
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
                          style: ThemeConfig.textStyle,
                        ),
                      ),
                    ),
                  ),
                ),
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
                      child: Text(
                        "signUp".tr(),
                        style: const TextStyle(color: Colors.red),
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
}
