class ErrorResponse {
  final int status;
  final String error;
  final String message;
  final String timestamp;

  ErrorResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.timestamp,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        status: json['status'],
        error: json['error'],
        message: json['message'],
        timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      );
}