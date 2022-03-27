class ApiExam{
  final String status;
  final String? message;
  final dynamic data;

  ApiExam({
    required this.status,
    required this.message,
    required this.data,
});

  factory ApiExam.fromJson(Map<String, dynamic> json) {
    return ApiExam(
        status: json['status'],
        message: json['message'],
        data:  json['data']
    );
  }
}