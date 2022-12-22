import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:o_health/screens/home.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationScreen extends StatefulWidget {
  final String docID;
  const CallInvitationScreen({Key? key, required this.docID}) : super(key: key);

  @override
  State<CallInvitationScreen> createState() => _CallInvitationScreenState();
}

class _CallInvitationScreenState extends State<CallInvitationScreen> {
  final TextEditingController inviteeUsersIDTextCtrl = TextEditingController();
  Box hive = Hive.box('data');

  @override
  Widget build(BuildContext context) {
    String localUserID = hive.get('userData')['aadhar'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor consultation',
          style: ThemeConfig.textStyle,
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return const Home();
            }), (route) => false);
          },
        ),
        flexibleSpace: Container(
          alignment: Alignment.bottomRight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(223, 227, 58, 58),
              Color.fromARGB(224, 238, 90, 102)
            ]),
          ),
          child: const Padding(
            padding: EdgeInsets.only(bottom: 6, right: 12),
          ),
        ),
      ),
      body: ZegoUIKitPrebuiltCallWithInvitation(
        appID: 241031027,
        appSign:
            "8b288c15fbe24462410ca8ac2c313c96a2bee1360648fd8a161acdbd838101e9",
        userID: localUserID,
        userName: "user_$localUserID",
        plugins: [ZegoUIKitSignalingPlugin()],
        child: patientVideoCallView(context, localUserID),
      ),
    );
  }

  Widget patientVideoCallView(BuildContext context, localUserID) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/dr-consultation.json', height: 250),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  // inviteeUserIDInput(),
                  const SizedBox(width: 5),
                  callButton(false),
                  const SizedBox(width: 20),
                  callButton(true),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget callButton(bool isVideoCall) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        var invitees = getInvitesFromTextCtrl(widget.docID);

        return Column(
          children: [
            ZegoStartCallInvitationButton(
              isVideoCall: isVideoCall,
              invitees: invitees,
              iconSize: const Size(60, 60),
              buttonSize: const Size(80, 80),
              onPressed:
                  (String code, String message, List<String> errorInvitees) {
                if (errorInvitees.isNotEmpty) {
                  String userIDs = "";
                  for (int index = 0; index < errorInvitees.length; index++) {
                    if (index >= 5) {
                      userIDs += '... ';
                      break;
                    }

                    var userID = errorInvitees.elementAt(index);
                    userIDs += userID + ' ';
                  }
                  if (userIDs.isNotEmpty) {
                    userIDs = userIDs.substring(0, userIDs.length - 1);
                  }

                  var message = "${'userDoesntExist'.tr()} $userIDs";
                  if (code.isNotEmpty) {
                    message += ', code: $code, message:$message';
                  }
                  showToast(
                    message,
                    position: StyledToastPosition.top,
                    context: context,
                  );
                } else if (code.isNotEmpty) {
                  showToast(
                    'code: $code, message:$message',
                    position: StyledToastPosition.top,
                    context: context,
                  );
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            isVideoCall ? Text('videoCall'.tr()) : Text('voiceCall'.tr())
          ],
        );
      },
    );
  }

  List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
    List<ZegoUIKitUser> invitees = [];

    var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
    inviteeIDs.split(",").forEach((inviteeUserID) {
      if (inviteeUserID.isEmpty) {
        return;
      }

      invitees.add(ZegoUIKitUser(
        id: inviteeUserID,
        name: 'user_$inviteeUserID',
      ));
    });

    return invitees;
  }
}
