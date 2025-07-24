import 'dart:convert';

import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/user_model.dart';
import 'package:inspecoespoty/data/services/api_service.dart';
import 'package:inspecoespoty/data/services/prefs.dart';
import 'package:inspecoespoty/utils/config.dart';
import 'package:inspecoespoty/ui/home/widgets/home_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    bool? validacao = await checkTokenApi();
    if (validacao) {
      configUserModel = UserModel.fromJson(jsonDecode(await Prefs.getString('userJson') ?? '{}'));
      Get.offAll(() => HomeScreen());
    }
    super.onInit();
  }
}
