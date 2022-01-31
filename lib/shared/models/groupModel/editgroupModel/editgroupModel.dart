import 'package:json_annotation/json_annotation.dart';

part 'editgroupModel.g.dart';

@JsonSerializable()
class EditgroupModel {
  late String id, description, image, name;

  EditgroupModel({
    required this.id,
    required this.description,
    required this.image,
    required this.name,
  });

  factory EditgroupModel.fromJson(Map<String, dynamic> json) =>
      _$EditgroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$EditgroupModelToJson(this);
}
