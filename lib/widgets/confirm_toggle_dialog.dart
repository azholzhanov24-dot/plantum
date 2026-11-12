import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable confirmation dialog for device/actuator switches across all screens.
/// Returns `true` if the user confirms the action, `false` otherwise.
Future<bool> showToggleConfirmDialog({
  required BuildContext context,
  required String deviceName,
  required bool turnOn,
  Color? confirmColor,
  String? customMessage,
}) async {
  // Clear any existing focus before opening dialog to prevent web sticky focus
  FocusScope.of(context).unfocus();

  final deviceDisplayName = deviceName.toLowerCase() == 'grow light'
      ? 'the grow light'
      : deviceName;

  final message = customMessage ??
      (turnOn
          ? 'Are you sure you want to turn ON $deviceDisplayName?'
          : 'Are you sure you want to turn OFF $deviceDisplayName?');

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        deviceName,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 15.0,
          color: Color(0xFF555555),
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6B7770),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          ),
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? AppColors.navActiveGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    ),
  );

  // Clear focus again after dialog closes to eliminate web focus persistence
  if (context.mounted) {
    FocusScope.of(context).unfocus();
  }

  return result ?? false;
}
