// File: lib/core/models/user_model.dart
// User model for the application

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';
part 'user_model.freezed.dart';

enum UserRole {
  ceo,
  admin,
  employee,
  visitor,
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    String? photoUrl,
    required UserRole role,
    required String companyId,
    String? phoneNumber,
    String? position,
    String? department,
    @Default(false) bool isActive,
    @Default([]) List<String> permissions,
    @Default([]) List<String> roleIds,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? updatedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.empty() => UserModel(
        id: '',
        email: '',
        fullName: '',
        role: UserRole.visitor,
        companyId: '',
        isActive: false,
      );
}

// Helper methods for Timestamp conversion
DateTime? _dateTimeFromTimestamp(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return null;
}

Timestamp? _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}