// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getsignupresponseModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetsignupresponseModel _$GetsignupresponseModelFromJson(
    Map<String, dynamic> json) {
  return GetsignupresponseModel(
    email: json['email'] as String,
    id: json['id'] as String,
    isEmail: json['isEmail'] as bool,
    phoneNumber: json['phoneNumber'] as String,
  );
}

Map<String, dynamic> _$GetsignupresponseModelToJson(
        GetsignupresponseModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'isEmail': instance.isEmail,
    };
