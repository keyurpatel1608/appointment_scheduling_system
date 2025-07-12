// File: lib/core/models/company_model.dart
// Company model for the application

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_model.g.dart';
part 'company_model.freezed.dart';

@freezed
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String id,
    required String name,
    String? logoUrl,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? phoneNumber,
    String? email,
    String? website,
    String? description,
    required String ownerId, // CEO/Owner user ID
    @Default([]) List<String> adminIds,
    @Default(true) bool isActive,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? updatedAt,
    @Default({}) Map<String, dynamic> settings,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  factory CompanyModel.empty() => CompanyModel(
        id: '',
        name: '',
        ownerId: '',
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