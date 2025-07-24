import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:inspecoespoty/data/services/login_service.dart';
import 'package:inspecoespoty/data/services/prefs.dart';
import 'package:inspecoespoty/ui/login/widgets/login_screen.dart';
import 'package:inspecoespoty/ui/splash/widgets/no_internet_screen.dart';
import 'package:inspecoespoty/utils/config.dart';

class ApiService {
  static final Dio _dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await checkTokenApi();
          options.baseUrl = baseUrl;
          options.connectTimeout = const Duration(minutes: 1);
          options.sendTimeout = const Duration(minutes: 1);
          options.receiveTimeout = const Duration(minutes: 1);
          options.headers['Content-Type'] = 'application/json';
          options.headers['Authorization'] =
              'Bearer ${await Prefs.getString('token')}';
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError) {
            Get.offAll(NoInternetScreen());
          }
          print('Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );

  static Dio get dio => _dio;
}

Future<bool> checkTokenApi() async {
  bool? verificacao = await LoginService().checkToken();
  if (verificacao == null) {
    Get.offAll(NoInternetScreen());
    return false;
  }
  if (!verificacao) {
    String? refreshToken = await Prefs.getString('refreshToken');
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        final response = await Dio().post(
          '$baseUrl/Authentication/Refresh',
          data: {'refreshToken': refreshToken},
        );
        if (response.statusCode == 200) {
          await Prefs.saveString('accessToken', response.data['accessToken']);
          await Prefs.saveString('refreshToken', response.data['refreshToken']);
          return true;
        } else {
          Get.offAll(LoginScreen());
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          Get.offAll(NoInternetScreen());
        } else if (e.response != null &&
            (e.response?.statusCode == 401 ||
                e.response?.statusCode == 403 ||
                e.response?.statusCode == 404 ||
                e.response?.data == 'Token inválido')) {
          await Prefs.deleteString('accessToken');
          await Prefs.deleteString('refreshToken');
          await Prefs.deleteString('userName');
          await Prefs.deleteString('user');
          Get.offAll(LoginScreen());
        } else {
          await Prefs.deleteString('accessToken');
          await Prefs.deleteString('refreshToken');
          await Prefs.deleteString('userName');
          await Prefs.deleteString('user');
          Get.offAll(LoginScreen());
        }
      } catch (e) {
        await Prefs.deleteString('accessToken');
        await Prefs.deleteString('refreshToken');
        await Prefs.deleteString('userName');
        await Prefs.deleteString('user');
        Get.offAll(LoginScreen());
      }
    } else {
      await Prefs.deleteString('accessToken');
      await Prefs.deleteString('refreshToken');
      await Prefs.deleteString('userName');
      await Prefs.deleteString('user');
      Get.offAll(LoginScreen());
    }
  } else {
    return true;
  }

  return false;
}
