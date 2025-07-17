import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/services/login_service.dart';
import 'package:inspecoespoty/ui/home/widgets/home_screen.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_alert.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isObscured = true.obs;
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    isLoading.value = true;
    final response = await LoginService.login(username: userController.text, password: passwordController.text);
    if (response['status']) {
      Get.offAll(HomeScreen());
    } else {
      CustomAlert().error(content: response['message'], title: 'Falha no login');
    }
    isLoading.value = false;
  }

  void togglePasswordVisibility() {
    isObscured.value = !isObscured.value;
  }
}
