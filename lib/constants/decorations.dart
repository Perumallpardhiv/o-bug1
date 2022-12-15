import 'package:flutter/material.dart';

const InputDecoration inputDecoration = InputDecoration(
  hintText: "",
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  ),
  focusedErrorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  ),
  prefixIcon: Icon(
    Icons.text_fields_rounded,
  ),
);

BoxDecoration boxDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withAlpha(28),
      blurRadius: 10,
      spreadRadius: 1.2,
    ),
  ],
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
);
