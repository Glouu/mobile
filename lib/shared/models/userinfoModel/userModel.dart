import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@JsonSerializable()
class UserModel {
  late String bio, image, emailOrPhone, name, userName;

  UserModel({
    required this.bio,
    required this.emailOrPhone,
    required this.name,
    required this.userName,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
