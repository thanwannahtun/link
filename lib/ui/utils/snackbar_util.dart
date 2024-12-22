import 'package:flutter/material.dart';
import 'package:link/main.dart';

/// Snackbar Utility Class
class SnackbarUtils {
  /// show snackBar by scaffoldMessengerKey [ ApiErrorHandler ]
  static void showGlobalSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
  }) {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Row(
        children: [
          Icon(
            _getSnackBarIcon(type),
            color: Colors.white,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getSnackBarColor(type),
    ));
  }

  /// Private Constructor to Prevent Instantiation
  SnackbarUtils._();

  /// Show SnackBar with Optional Global Key
  static void showSnackBar(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey, // Optional Key
  }) {
    // Hide the current SnackBar
    (scaffoldMessengerKey != null
            ? scaffoldMessengerKey.currentState
            : ScaffoldMessenger.of(context))
        ?.hideCurrentSnackBar();

    // Show the new SnackBar
    (scaffoldMessengerKey != null
            ? scaffoldMessengerKey.currentState
            : ScaffoldMessenger.of(context))
        ?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        duration: duration,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        content: Row(
          children: [
            Icon(
              _getSnackBarIcon(type),
              color: Colors.white,
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getSnackBarColor(type),
      ),
    );
  }

  /// Map Icons to Snackbar Types
  static IconData _getSnackBarIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.warning:
        return Icons.warning;
      case SnackBarType.info:
      default:
        return Icons.info;
    }
  }

  /// Map Colors to Snackbar Types
  static Color _getSnackBarColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.warning:
        return Colors.orange;
      case SnackBarType.info:
      default:
        return Colors.blue;
    }
  }
}

/// Snackbar Types
enum SnackBarType { success, error, warning, info }
