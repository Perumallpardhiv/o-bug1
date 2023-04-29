import 'dart:convert';

import 'package:flutter/services.dart';

var responces11 = [];
var patien = [];

Future<void> getResponcesFromDoctor() async {
  var res = await rootBundle.loadString('assets/json/doctorResponces.json');
  var resJsons = await json.decode(res);
  responces11 = resJsons["responces"];
  for (var i in responces11) {
    print(i['doctorName']);
  }
  print("1111111");
}

Future<void> patientsDetails() async {
  var res = await rootBundle.loadString('assets/json/patientsDetails.json');
  var resJsons = await json.decode(res);
  patien = resJsons["patients"];
  for (var i in patien) {
    print(i['patientName']);
  }
  print("2222222");
}
