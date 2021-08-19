import 'package:json_annotation/json_annotation.dart';

part 'otpModel.g.dart';

@JsonSerializable()
class OtpModel {
  late String id;
  late String otp;

  OtpModel({
    required this.id,
    required this.otp,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) =>
      _$OtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpModelToJson(this);
}
