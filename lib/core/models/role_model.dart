// File: lib/core/models/role_model.dart
// Role model for role-based access control

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.g.dart';
part 'role_model.freezed.dart';

@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    required String id,
    required String name,
    required String companyId,
    String? description,
    @Default([]) List<String> permissions,
    @Default(0) int level, // Hierarchy level (0 is highest, e.g., CEO)
    @Default(true) bool isActive,
    @Default(false) bool isDefault,
    @Default(false) bool isSystem, // System roles cannot be modified
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  factory RoleModel.empty() => RoleModel(
        id: '',
        name: '',
        companyId: '',
        isActive: true,
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