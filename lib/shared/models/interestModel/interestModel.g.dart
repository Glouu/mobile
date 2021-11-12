// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestModel _$InterestModelFromJson(Map<String, dynamic> json) =>
    InterestModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => AddinterestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InterestModelToJson(InterestModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
