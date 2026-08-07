import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/auth_response.dart';
import 'package:frontend/data/models/login_request.dart';
import 'package:frontend/data/models/register_request.dart';
import 'package:frontend/data/repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(AuthRepository());
});

class AuthState {
  final bool isLoading;
  final AuthResponse? user;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    AuthResponse? user,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(AuthState());

  Future<void> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(request);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll("Exception: ", ""),
      );
    }
  }

  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.register(request);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll("Exception: ", ""),
      );
    }
  }

  Future<void> logout() async {

  print("AUTH CONTROLLER LOGOUT START");


  try {

    await _repository.logout();


    state = AuthState();


    print("AUTH STATE CLEARED");


  } catch(e){

    print("LOGOUT FAILED : $e");

  }

}

  void clearError() => state = state.copyWith(errorMessage: null);
}