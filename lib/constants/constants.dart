import 'dart:convert';

import 'package:flutter/services.dart';

var responces11 = [];

Future<void> getResponcesFromDoctor() async {
  var res = await rootBundle.loadString('assets/json/json.json');
  var resJsons = await json.decode(res);
  responces11 = resJsons["responces"];
  for (var i in responces11) {
    print(i['doctorName']);
  }
  print("1111111");
}
