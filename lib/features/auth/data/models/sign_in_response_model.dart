class SignInResponse {
  String? statusCode;
  String? message;
  String? token;

  SignInResponse({this.message, this.token, this.statusCode});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status '];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status '] = statusCode;
    data['token'] = token;
    return data;
  }
}
