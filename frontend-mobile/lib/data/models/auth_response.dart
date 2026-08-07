class AuthResponse {
  final String email;
  final String firstName;
  final String lastName;
  final String role;

  AuthResponse({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        role: json['role'],
      );
}