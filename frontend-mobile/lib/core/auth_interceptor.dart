import 'package:dio/dio.dart';

import 'api_client.dart';


class AuthInterceptor extends Interceptor {


  bool _isRefreshing = false;



  @override
Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler
) async {


  if(
      err.response?.statusCode == 401 &&
      err.requestOptions.path != "/auth/refresh" &&
      !_isRefreshing
  ){

    _isRefreshing = true;


    try {

      await ApiClient.dio.post(
        "/auth/refresh",
      );


      final response =
          await ApiClient.dio.fetch(
            err.requestOptions,
          );


      _isRefreshing = false;


      return handler.resolve(response);


    } catch(e) {


      _isRefreshing = false;


      return handler.reject(err);

    }

  }


  return handler.next(err);

}

}