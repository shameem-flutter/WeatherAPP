import 'package:flutter/material.dart';

TextStyle weatherBasedTextStyle(String condition) {
  condition = condition.toLowerCase();
  if (condition.contains('sunny')) {
    return TextStyle(color: Colors.black);
  }
  return TextStyle(color: Colors.black);
}
