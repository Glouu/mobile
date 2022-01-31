// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editgroupModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditgroupModel _$EditgroupModelFromJson(Map<String, dynamic> json) =>
    EditgroupModel(
      id: json['id'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$EditgroupModelToJson(EditgroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'image': instance.image,
      'name': instance.name,
    };
