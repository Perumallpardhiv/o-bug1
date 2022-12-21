import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:o_health/methods/methods.dart';

import '../theme_config/theme_config.dart';
import 'login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _phoneNum = 9900303090;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "forgotPassword".tr(),
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
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Text("otpSent".tr() + " $_phoneNum"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                OtpTextField(
                  numberOfFields: 4,
                  borderColor: Colors.red,
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("verificationCode".tr()),
                            content: Text('Code entered is $verificationCode'),
                          );
                        });
                  }, // end onSubmit
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                GestureDetector(
                  onTap: () {
                    showSnackBar(context, false, "contactAdmin".tr());
                    // Navigator.of(context).pushNamed('/reset-password');
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
