import 'package:json_annotation/json_annotation.dart';

part 'addgroupmemberModel.g.dart';

@JsonSerializable()
class AddgroupmemberModel {
  late String groupId, userId;

  AddgroupmemberModel({
    required this.groupId,
    required this.userId,
  });

  factory AddgroupmemberModel.fromJson(Map<String, dynamic> json) =>
      _$AddgroupmemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddgroupmemberModelToJson(this);
}
