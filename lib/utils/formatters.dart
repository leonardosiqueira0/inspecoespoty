import 'package:flutter/services.dart';

class Formatters {
  static toLower() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue.copyWith(
        text: newValue.text.toLowerCase(),
        selection: newValue.selection,
      );
    });
  }
}