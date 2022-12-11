// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AuthServices {
  static register(username, password, aadharNumber) async {
    http.post(
        Uri.parse(
            "https://health-conscious.in/api/user/register/userRegistration"),
        body: {
          "user_name": username,
          "user_aadhar_number": aadharNumber,
          "user_password": password
        }).then((resp) {
      return resp;
    }).catchError((err) {
      return http.Response("$err", 500);
    });
  }

  static login(String password, String aadharNumber) async {
    try {
      var resp = await http.post(
        Uri.parse('https://health-conscious.in/api/user//login/userLogin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {"user_aadhar_number": aadharNumber, "user_password": password}),
      );

      return LoginResponse.fromJson(
          {'hasError': false, 'data': resp.body, 'errorMsg': ''});
    } catch (error) {
      return LoginResponse.fromJson({
        'hasError': false,
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
      return err;
    }
  }
}

class LoginResponse {
  final bool hasError;
  final String errorMsg;
  Map data;

  LoginResponse(
      {required this.hasError, required this.data, required this.errorMsg});

  factory LoginResponse.fromJson(json) {
    return LoginResponse(
        hasError: json['hasError'],
        data: jsonDecode(json['data']),
        errorMsg: json['errorMsg']);
  }
}
