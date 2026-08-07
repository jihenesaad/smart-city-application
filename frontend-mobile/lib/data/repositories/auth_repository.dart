import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/data/models/auth_response.dart';
import 'package:frontend/data/models/error_response.dart';
import 'package:frontend/data/models/login_request.dart';
import 'package:frontend/data/models/register_request.dart';


class AuthRepository {
  final Dio _dio = ApiClient.dio;

  // ====================== REGISTER ======================
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

 // ====================== LOGIN ======================
Future<AuthResponse> login(LoginRequest request) async {
  try {
    print('LOGIN REQUEST BODY: ${request.toJson()}');

    final response = await _dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    print("LOGIN SUCCESS : ${response.data}");

    return AuthResponse.fromJson(response.data);

  } on DioException catch (e) {

    print("========== LOGIN ERROR ==========");
    print("URL    : ${e.requestOptions.uri}");
    print("METHOD : ${e.requestOptions.method}");
    print("STATUS : ${e.response?.statusCode}");
    print("BODY   : ${e.response?.data}");
    print("HEADERS: ${e.response?.headers}");
    print("=================================");

    throw _handleError(e);
  } catch (e) {
    print("Unexpected error: $e");
    throw Exception("An error occured. Please retry.");
  }
}
  // ====================== REFRESH TOKEN ======================
  Future<AuthResponse> refreshToken() async {

    try {

      final response =
          await _dio.post(
              "/auth/refresh"
          );


      return AuthResponse.fromJson(
          response.data
      );


    } catch(e){

      throw _handleError(e);

    }

    }

  // ====================== LOGOUT ======================
  Future<void> logout() async {
  try {

    print("========== LOGOUT ==========");

    print(
      "COOKIE BEFORE LOGOUT : "
      "${await ApiClient.cookieJar.loadForRequest(
        Uri.parse(
          'http://10.0.2.2:8080/api/auth/logout'
        )
      )}"
    );


    final response =
        await _dio.post('/auth/logout');


    print("LOGOUT STATUS : ${response.statusCode}");

    print(
      "COOKIE AFTER RESPONSE : "
      "${await ApiClient.cookieJar.loadForRequest(
        Uri.parse(
          'http://10.0.2.2:8080/api/auth/logout'
        )
      )}"
    );


    print("============================");


  } on DioException catch(e){

    print("LOGOUT ERROR");
    print("STATUS : ${e.response?.statusCode}");
    print("BODY : ${e.response?.data}");

    throw _handleError(e);

  }
}

  // ====================== GESTION DES ERREURS ======================
  Exception _handleError(dynamic error) {
  if (error is DioException) {
    if (error.response?.data != null) {
      try {
        final errorResponse = ErrorResponse.fromJson(error.response!.data);
        return Exception(errorResponse.message);
      } catch (_) {}
    }
    // Ajoute ceci : log la vraie cause pendant que tu débogues
    debugPrint('DioException type: ${error.type}, message: ${error.message}');
    return Exception("Erreur réseau: ${error.message ?? error.type}");
  }

  debugPrint('Erreur inattendue: $error');
  return Exception("An error occured. Please retry.");
}
}