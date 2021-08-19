import 'package:json_annotation/json_annotation.dart';

part 'resetpasswordModel.g.dart';

@JsonSerializable()
class ResetpasswordModel {
  late String emailOrPhone;

  ResetpasswordModel({
    required this.emailOrPhone,
  });

  factory ResetpasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetpasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetpasswordModelToJson(this);
}
