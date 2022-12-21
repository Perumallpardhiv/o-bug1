import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:o_health/screens/doctor_home.dart';
import 'package:o_health/screens/patient_home.dart';

import 'package:o_health/services/audio_services.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final Box hiveObj = Hive.box('data');
  AudioServices audioServices = AudioServices();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        sendAppStatus('online');
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        sendAppStatus('background');
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
    var user = hiveObj.get('userData');
    http.post(
      Uri.parse('https://health-conscious.in/api/user/status/userStatusUpdate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'user_active_status': status,
          'user_aadhar_number': user['aadhar'],
        },
      ),
    );
  }
}
