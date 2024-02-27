class OtpModel {
  final String? message;
  final int? expiresIn;

  OtpModel({
    this.message,
    this.expiresIn,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        message: json["message"],
        expiresIn: json["expiresIn"],
      );
}
