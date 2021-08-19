import 'package:json_annotation/json_annotation.dart';

part 'resetpasswordotpModel.g.dart';

@JsonSerializable()
class ResetpasswordotpModel {
  late String emailOrPhone, otp;

  ResetpasswordotpModel({
    required this.emailOrPhone,
    required this.otp,
  });

  factory ResetpasswordotpModel.fromJson(Map<String, dynamic> json) =>
      _$ResetpasswordotpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetpasswordotpModelToJson(this);
}
