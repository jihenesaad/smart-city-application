import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

import 'auth_interceptor.dart';


class ApiClient {

  static late Dio dio;

  static late CookieJar cookieJar;



  static Future<void> init() async {


    final appDocDir =
        await getApplicationDocumentsDirectory();



    cookieJar = PersistCookieJar(
      storage: FileStorage(
        '${appDocDir.path}/.cookies/',
      ),
      ignoreExpires: true,
    );



    dio = Dio(
      BaseOptions(

        baseUrl:
          'http://10.0.2.2:8080/api',

        connectTimeout:
          const Duration(seconds:120),

        receiveTimeout:
          const Duration(seconds:120),

      ),
    );



    dio.interceptors.add(
      CookieManager(cookieJar),
    );



    dio.interceptors.add(
      AuthInterceptor(),
    );


  }

}