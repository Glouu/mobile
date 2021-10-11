// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resetpasswordotpModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetpasswordotpModel _$ResetpasswordotpModelFromJson(
        Map<String, dynamic> json) =>
    ResetpasswordotpModel(
      emailOrPhone: json['emailOrPhone'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$ResetpasswordotpModelToJson(
        ResetpasswordotpModel instance) =>
    <String, dynamic>{
      'emailOrPhone': instance.emailOrPhone,
      'otp': instance.otp,
    };
