import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:o_health/screens/register.dart';

import '../constants/input_decorations.dart';
import '../theme_config/theme_config.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              child: Column(
            children: [
              Card(
                child: TextFormField(
                    decoration: inputDecoration.copyWith(
                        hintText: 'aadharNumber'.tr())),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 60,
              ),
              Card(
                child: TextFormField(
                    decoration:
                        inputDecoration.copyWith(hintText: 'password'.tr())),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 60,
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
                height: MediaQuery.of(context).size.width / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("don'tHave".tr())),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: const Text(
                      "signUp",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => Register())));
                    },
                  )
                ],
              )
            ],
          )),
        ));
  }
}
