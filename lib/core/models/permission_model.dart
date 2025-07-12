// File: lib/core/models/permission_model.dart
// Permission model for role-based access control

import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_model.g.dart';
part 'permission_model.freezed.dart';

// Define permission categories
enum PermissionCategory {
  appointment,
  calendar,
  user,
  role,
  company,
  notification,
  dashboard,
}

// Define permission actions
enum PermissionAction {
  create,
  read,
  update,
  delete,
  approve,
  reject,
  reschedule,
  assign,
  manage,
  view,
}

@freezed
class PermissionModel with _$PermissionModel {
  const factory PermissionModel({
    required String id,
    required String name,
    required String description,
    required PermissionCategory category,
    required PermissionAction action,
    @Default(true) bool isActive,
    @Default(false) bool isSystem, // System permissions cannot be modified
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);
}

// Helper class to generate permission strings
class PermissionHelper {
  static String generatePermissionId(
      PermissionCategory category, PermissionAction action) {
    return '${category.name}_${action.name}';
  }

  static String generatePermissionName(
      PermissionCategory category, PermissionAction action) {
    return '${_capitalizeFirst(action.name)} ${_capitalizeFirst(category.name)}';
  }

  static String generatePermissionDescription(
      PermissionCategory category, PermissionAction action) {
    return 'Can ${action.name} ${category.name}s';
  }

  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Get all system permissions
  static List<PermissionModel> getAllPermissions() {
    final List<PermissionModel> permissions = [];

    for (var category in PermissionCategory.values) {
      for (var action in PermissionAction.values) {
        // Skip irrelevant combinations
        if (!_isValidCombination(category, action)) continue;

        permissions.add(
          PermissionModel(
            id: generatePermissionId(category, action),
            name: generatePermissionName(category, action),
            description: generatePermissionDescription(category, action),
            category: category,
            action: action,
            isSystem: true,
          ),
        );
      }
    }

    return permissions;
  }

  // Check if a permission combination is valid
  static bool _isValidCombination(
      PermissionCategory category, PermissionAction action) {
    switch (category) {
      case PermissionCategory.appointment:
        return true; // All actions are valid for appointments
      case PermissionCategory.calendar:
        return action != PermissionAction.delete; // Can't delete calendar
      case PermissionCategory.user:
        return action != PermissionAction.reschedule; // Can't reschedule users
      case PermissionCategory.role:
        return action != PermissionAction.reschedule &&
            action != PermissionAction.approve &&
            action != PermissionAction.reject;
      case PermissionCategory.company:
        return action != PermissionAction.reschedule &&
            action != PermissionAction.approve &&
            action != PermissionAction.reject;
      case PermissionCategory.notification:
        return action == PermissionAction.read ||
            action == PermissionAction.delete;
      case PermissionCategory.dashboard:
        return action == PermissionAction.view;
      default:
        return false;
    }
  }
}