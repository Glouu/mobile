import 'package:json_annotation/json_annotation.dart';

part 'dateofbirthModel.g.dart';

@JsonSerializable()
class DateofbirthModel {
  late String dateOfBirth;

  DateofbirthModel({
    required this.dateOfBirth,
  });

  factory DateofbirthModel.fromJson(Map<String, dynamic> json) =>
      _$DateofbirthModelFromJson(json);

  Map<String, dynamic> toJson() => _$DateofbirthModelToJson(this);
}
