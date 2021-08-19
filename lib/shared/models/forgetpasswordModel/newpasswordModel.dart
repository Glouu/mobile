import 'package:json_annotation/json_annotation.dart';

part 'newpasswordModel.g.dart';

@JsonSerializable()
class NewpasswordModel {
  late String emailOrPhone, password;

  NewpasswordModel({
    required this.emailOrPhone,
    required this.password,
  });

  factory NewpasswordModel.fromJson(Map<String, dynamic> json) =>
      _$NewpasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewpasswordModelToJson(this);
}
