import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:o_health/screens/doctor_home.dart';
import 'package:o_health/screens/patient_home.dart';
import 'package:o_health/screens/video_player/video_player.dart';
import 'package:o_health/services/audio_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool isEng = true;
  final Box hiveObj = Hive.box('data');
  List<String> languages = ['en', 'kn'];
  AudioServices audioServices = AudioServices();

  AppLifecycleState? _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        sendAppStatus('online');
        break;
      case AppLifecycleState.paused:
        sendAppStatus('background');
        break;
      case AppLifecycleState.inactive:
        sendAppStatus('inactive');
        break;
      case AppLifecycleState.detached:
        sendAppStatus('offline');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sendAppStatus('online');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = hiveObj.get('userData');
    return user['role'] == 'patient' ? const PatientHome() : const DoctorHome();
  }

  Future<void> sendAppStatus(String status) async {
    http.post(Uri.parse('http://localhost:3000/userState'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'state': status}));
  }
}
