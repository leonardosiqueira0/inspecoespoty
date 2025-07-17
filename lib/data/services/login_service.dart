import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/models/user_model.dart';
import 'package:inspecoespoty/data/services/prefs.dart';
import 'package:inspecoespoty/ui/login/widgets/login_screen.dart';
import 'package:inspecoespoty/ui/splash/widgets/no_internet_screen.dart';
import 'package:inspecoespoty/utils/config.dart';

class LoginService {
  static login({required String username, required String password}) async {
    try {
      final response = await Dio().post(
        '$baseUrl/Login',
        data: {
          'user': username,
          'password': password,
        },
      );
      // Salvando os tokens
      await Prefs.saveString(
        'accessToken',
        response.data['accessToken'],
      );
      await Prefs.saveString(
        'refreshToken',
        response.data['refreshToken'],
      );
      await Prefs.saveString('userJson', jsonEncode(response.data['user']));
      
      configUserModel = UserModel.fromJson(jsonDecode(await Prefs.getString('userJson') ?? '{}'));


      return {'status': true, 'message': 'Login realizado com sucesso'};
    } on DioException catch (e) {
      debugPrint('Falha ao realizar o login ${e.message}');
      return {
        'status': false,
        'message': 'Falha ao realizar o login, verifique seu usuário e senha',
      };
    } catch (e) {
      debugPrint('Falha ao realizar o login $e');
      return {
        'status': false,
        'message': 'Falha ao realizar o login, verifique sua internet',
      };
    }
  }

  static refresh() async {
    try {
      final refreshToken = await Prefs.getString('refreshToken');
      if (refreshToken == null) {
        throw 'Refresh token não encontrado';
      }

      final response = await Dio().post(
        '$baseUrl/Authentication/Refresh',
        data: {'refreshToken': await Prefs.getString('refreshToken')},
      );
      // Salvando os tokens
      await Prefs.saveString('accessToken', response.data['accessToken']);
      await Prefs.saveString('refreshToken', response.data['refreshToken']);

      return {'status': true, 'message': 'Token atualizado com sucesso'};
    } on DioException catch (e) {
      debugPrint('Falha ao realizar a atualizacao ${e.message}');
      await Prefs.deleteAll();

      Get.offAll(LoginScreen());
      return {
        'status': false,
        'message': 'Falha ao realizar a atualizacao, realize o token novamente',
      };
    } catch (e) {
      debugPrint('Falha ao realizar a atualizacao $e');
      await Prefs.deleteAll();

      Get.offAll(LoginScreen());
      return {
        'status': false,
        'message': 'Falha ao realizar a atualizacao, verifique sua internet',
      };
    }
  }

  Future<void> logout() async {
    try {
      await Prefs.deleteAll();

      Get.offAll(LoginScreen());
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
    }
  }

  Future<bool?> checkToken() async {
    final refreshToken = await Prefs.getString('refreshToken');
    final accessToken = await Prefs.getString('accessToken');

    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    try {
      final response = await Dio().post(
        '$baseUrl/Authentication/Validate',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        // Erro de conexão
        Get.offAll(NoInternetScreen());
      } else if (e.response != null &&
          (e.response?.statusCode == 401 ||
              e.response?.statusCode == 403 ||
              e.response?.statusCode == 404 ||
              e.response?.data == 'Token inválido')) {
        // Token inválido
        return false;
      } else {
        debugPrint('Erro ao verificar token: ${e.message}');
        return false;
      }
    } catch (e) {
      debugPrint('Erro ao verificar token: $e');
      return false;
    }
  }
}
