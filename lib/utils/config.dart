import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/user_model.dart';
import 'package:video_player/video_player.dart';

// String get baseUrl => 'https://potyis.bebidaspoty.com.br/api';
String get baseUrl => 'http://10.0.2.2:5064/api';
UserModel? configUserModel;
Color get primaryColor => Color(0xFF5a9f44);

formatDate(DateTime data) {
  return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
}