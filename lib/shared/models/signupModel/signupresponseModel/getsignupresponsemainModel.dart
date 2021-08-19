
import 'package:gloou/shared/models/signupModel/signupresponseModel/getsignupresponseModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'getsignupresponsemainModel.g.dart';

@JsonSerializable()
class GetsignupresponsemainModel {
  GetsignupresponseModel data;

  GetsignupresponsemainModel({
    required this.data,
  });

  factory GetsignupresponsemainModel.fromJson(Map<String, dynamic> json) => _$GetsignupresponsemainModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetsignupresponsemainModelToJson(this);
}
