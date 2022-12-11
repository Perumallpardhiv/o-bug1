import 'package:flutter/material.dart';

showSnackBar(BuildContext context, bool isError, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: isError ? Colors.red : Colors.greenAccent,
  ));
}
