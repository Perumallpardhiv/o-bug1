// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AuthServices {
  static register(username, password, aadharNumber) async {
    http.post(Uri.parse("uri"), body: {
      "username": username,
      "password": password,
      "aadharNumber": aadharNumber
    }).then((resp) {
      return resp;
    }).catchError((err) {
      return Response("Error", 500);
    });
  }

  static login(password, aadharNumber) async {
    http.post(Uri.parse("uri"), body: {
      "password": password,
      "aadharNumber": aadharNumber
    }).then((resp) {
      return resp;
    }).catchError((err) {
      return Response("Error", 500);
    });
  }

  static sendAadharImage(File image, String url) async {
    var uri = Uri.parse(url);
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
    } catch (e) {
      return Response("Error ", 500);
    }
  }
}
