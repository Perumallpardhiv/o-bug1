import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../models/login_model.dart';

class AuthServices {
  static register(String username, String password, String aadharNumber) async {
    try {
      var resp = await http.post(
        Uri.parse(
            "https://health-conscious.in/api/user/register/userRegistration"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_name": 'username'.trim(),
          "user_aadhar_number": '1231313'.trim(),
          "user_password": '121313'.trim()
        }),
      );
      return jsonDecode(resp.body);
    } catch (err) {
      return null;
    }
  }

  static Future<LoginResponse> login(
      String password, String aadharNumber) async {
    try {
      var resp = await http.post(
        Uri.parse('https://health-conscious.in/api/user//login/userLogin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {"user_aadhar_number": aadharNumber, "user_password": password}),
      );
      return resp.statusCode == 200
          ? LoginResponse.fromJson(
              {'hasError': false, 'data': resp.body, 'errorMsg': ''})
          : LoginResponse.fromJson({
              'hasError': true,
              'data': Response('{}', resp.statusCode).body,
              'errorMsg': 'invalidAadharPswd'.tr()
            });
    } catch (error) {
      return LoginResponse.fromJson({
        'hasError': true,
        'data': Response('{}', 500).body,
        'errorMsg': error.toString()
      });
    }
  }

  static sendAadharImage(File image) async {
    var uri = Uri.parse(
        'https://health-conscious.in/api/user/register/extractInformation');
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');

    // Initialize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', uri);
    imageUploadRequest.fields['fileName'] =
        image.path.split(Platform.pathSeparator).last;

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('aadhar-file', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);

    // add headers if needed
    //imageUploadRequest.headers.addAll(<some-headers>);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (err) {
      return null;
    }
  }
}
