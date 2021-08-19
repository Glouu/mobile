// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signupModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupModel _$SignupModelFromJson(Map<String, dynamic> json) {
  return SignupModel(
    emailOrPhone: json['emailOrPhone'] as String,
    password: json['password'] as String,
    name: json['name'] as String,
    userName: json['userName'] as String,
  );
}

Map<String, dynamic> _$SignupModelToJson(SignupModel instance) =>
    <String, dynamic>{
      'emailOrPhone': instance.emailOrPhone,
      'name': instance.name,
      'password': instance.password,
      'userName': instance.userName,
    };
