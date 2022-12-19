import 'dart:convert';

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
