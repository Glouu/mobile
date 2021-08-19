import 'package:json_annotation/json_annotation.dart';

part 'signupModel.g.dart';

@JsonSerializable()
class SignupModel {
  late String emailOrPhone, name, password, userName;

  SignupModel({
    required this.emailOrPhone,
    required this.password,
    required this.name,
    required this.userName,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) =>
      _$SignupModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignupModelToJson(this);
}
