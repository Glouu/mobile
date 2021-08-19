
import 'package:json_annotation/json_annotation.dart';

part 'getsignupresponseModel.g.dart';

@JsonSerializable()
class GetsignupresponseModel {
  String email, id, phoneNumber;
  late bool isEmail;

  GetsignupresponseModel({
    required this.email,
    required this.id,
    required this.isEmail,
    required this.phoneNumber,
  });

  factory GetsignupresponseModel.fromJson(Map<String, dynamic> json) => _$GetsignupresponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetsignupresponseModelToJson(this);
}
