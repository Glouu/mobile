import 'package:json_annotation/json_annotation.dart';

part 'addgroupModel.g.dart';

@JsonSerializable()
class AddgroupModel {
  late String description, image, name;

  AddgroupModel({
    required this.description,
    required this.image,
    required this.name,
  });

  factory AddgroupModel.fromJson(Map<String, dynamic> json) =>
      _$AddgroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddgroupModelToJson(this);
}
