import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:o_health/methods/methods.dart';
import 'package:o_health/screens/register.dart';
import 'package:http/http.dart' as http;
import '../constants/input_decorations.dart';
import '../services/auth_services.dart';
import '../theme_config/theme_config.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _aadharController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

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
        child: Form(
          key: _key,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Card(
                child: TextFormField(
                    controller: _aadharController,
                    decoration: inputDecoration.copyWith(
                        hintText: 'aadharNumber'.tr())),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 60,
              ),
              Card(
                child: TextFormField(
                    controller: _passwordController,
                    decoration:
                        inputDecoration.copyWith(hintText: 'password'.tr())),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 60,
              ),
              MaterialButton(
                onPressed: () async {
                  AuthServices.login(
                          _passwordController.text, _aadharController.text)
                      .then((val) {});
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
                height: MediaQuery.of(context).size.width / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("don'tHave".tr())),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: const Text(
                      "signUp",
                      style: TextStyle(color: Colors.red),
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
          )),
        ),
      ),
    );
  }
}
