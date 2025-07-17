import 'package:get/get.dart';
import 'package:inspecoespoty/ui/.core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CustomAlert {
  void error ({required String content, String title = 'Erro'}) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      radius: 10,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(20),
      content: Text(content, textAlign: TextAlign.center),
      barrierDismissible: false,
      confirm: CustomButton(
        content: 'OK',
        onTap: () => Get.back(),
      ),
    );
  }

  void confirm ({required String content, String title = 'Atenção', required VoidCallback onConfirm, String confirmText = 'Sim'}) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      radius: 10,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(20),
      content: Text(content, textAlign: TextAlign.center),
      barrierDismissible: false,
      confirm: Container(
        width: MediaQuery.of(Get.context!).size.width - 40,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                content: confirmText,
                onTap: onConfirm,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                content: 'Cancelar',
                onTap: () => Get.back(),
                color: Colors.red.shade400,
              ),
            ),
          ],
        ),
      )
    );
  }

  errorSnack(String content) {
    return Get.snackbar('Erro', content, snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.red.shade400,  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 24));
  }

  successSnack (String content) {
    Get.snackbar('Sucesso', content, snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.green.shade400,  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 24));

  }
}