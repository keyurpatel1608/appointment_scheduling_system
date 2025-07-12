// File: lib/core/models/appointment_model.dart
// Appointment model for the application

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_model.g.dart';
part 'appointment_model.freezed.dart';

// Appointment status enum
enum AppointmentStatus {
  pending,   // Waiting for approval
  approved,  // Approved by CEO/Admin
  rejected,  // Rejected by CEO/Admin
  cancelled, // Cancelled by requester
  completed, // Appointment has occurred
  rescheduled, // Appointment was rescheduled
}

@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required String id,
    required String title,
    required String description,
    required String companyId,
    required String requesterId, // User who requested the appointment
    required String requesteeId, // User with whom the appointment is requested (usually CEO)
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime startTime,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime endTime,
    @Default(AppointmentStatus.pending) AppointmentStatus status,
    String? location,
    String? rejectionReason,
    String? notes,
    @Default(false) bool isRecurring,
    String? recurrenceRule,
    @Default(false) bool isAllDay,
    @Default(false) bool isPrivate,
    @Default([]) List<String> attendeeIds,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    @Default({}) Map<String, dynamic> metadata,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  factory AppointmentModel.empty() => AppointmentModel(
        id: '',
        title: '',
        description: '',
        companyId: '',
        requesterId: '',
        requesteeId: '',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        status: AppointmentStatus.pending,
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