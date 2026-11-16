import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

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
          ? context.strings.confirmTurnOn(deviceDisplayName)
          : context.strings.confirmTurnOff(deviceDisplayName));

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: context.surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        deviceName,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: context.textPrimaryColor,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 15.0,
          color: context.textSecondaryColor,
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: context.textSecondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          ),
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            context.strings.cancel,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? context.brandGreenColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            context.strings.confirm,
            style: const TextStyle(
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
