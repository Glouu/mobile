import 'package:json_annotation/json_annotation.dart';

part 'resendotpModel.g.dart';

@JsonSerializable()
class ResendOtpModel {
  late String id;

  ResendOtpModel({
    required this.id,
  });

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResendOtpModelToJson(this);
}
