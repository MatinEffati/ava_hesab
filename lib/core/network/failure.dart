class Failure {
  final String? message;
  final Errors? errors;

  Failure({
    this.message,
    this.errors,
  });

  factory Failure.fromJson(Map<String, dynamic> json) => Failure(
        message: json["error"],
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      );
}

class Errors {
  final List<String>? captcha;
  final List<String>? mobile;

  Errors({
    this.captcha,
    this.mobile,
  });

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        captcha: json["captcha"] == null ? [] : List<String>.from(json["captcha"]!.map((x) => x)),
        mobile: json["mobile"] == null ? [] : List<String>.from(json["mobile"]!.map((x) => x)),
      );
}
