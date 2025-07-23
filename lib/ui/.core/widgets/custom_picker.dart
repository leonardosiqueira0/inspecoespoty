import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:image/image.dart' as img;

Future<File?> CustomPicker(BuildContext context, {String? id}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Selecione uma opção', textScaler: TextScaler.linear(0.8),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Câmera'),
              leading: Icon(Icons.camera_alt),
              onTap: () async {
                File? file = await pickImage(type: 'camera');
                Navigator.pop(context, file);
              },
            ),
            ListTile(
              title: Text('Galeria'),
              leading: Icon(Icons.image),
              onTap: () async {
                File? file = await pickImage(type: 'galeria');
                Navigator.pop(context, file);
              },
            ),
            ListTile(
              title: Text('Cancelar'),
              leading: Icon(Icons.cancel),
              onTap: () {
                Navigator.pop(context, null);
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<File?> pickImage({required String type, String id = ''}) async {
  XFile? image;
  final imagePicker = ImagePicker();

  // Seleção de origem da imagem
  if (type == 'camera') {
    image = await imagePicker.pickImage(
      source: ImageSource.camera,
    );
  } else if (type == 'galeria') {
    image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
  } else {
    return null;
  }

  // Verifica se a imagem foi capturada ou selecionada
  if (image?.path != null) {
    File newImageFile = File(image!.path);

    // Verifica se o formato da imagem é HEIC
    if (newImageFile.path.toLowerCase().endsWith('.heic') ||
        newImageFile.path.toLowerCase().endsWith('.heif')) {
      // Converte a imagem HEIC para JPEG
      String? jpegPath = await HeifConverter.convert(
        newImageFile.path,
        format: 'jpeg',
      );
      if (jpegPath != null) {
        newImageFile = File(jpegPath);
      } else {
        print("Falha ao converter HEIC para JPEG.");
        return null;
      }
    }

    // Ajusta espaço de cores (sRGB) usando a biblioteca 'image'
    final bytes = newImageFile.readAsBytesSync();
    final originalImage = img.decodeImage(bytes);
    if (originalImage != null) {
      final rgbImage = img.copyResize(originalImage, width: 512, height: 512);
      final convertedBytes = img.encodeJpg(rgbImage);
      File rgbFile = File(
        "${newImageFile.parent.path}/${DateTime.now().millisecondsSinceEpoch}.jpg",
      );
      rgbFile.writeAsBytesSync(convertedBytes);
      return rgbFile;
    } else {
      print("Falha ao ajustar espaço de cores.");
      return null;
    }
  }

  return null;
}
