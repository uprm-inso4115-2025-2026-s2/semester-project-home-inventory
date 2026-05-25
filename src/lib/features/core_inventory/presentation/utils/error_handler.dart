// lib/features/core_inventory/presentation/utils/error_handler.dart
import 'package:flutter/material.dart';

/// User-friendly error messages for the inventory feature
class InventoryErrorHandler {
  /// Converts any exception to a user-friendly message
  static InventoryErrorMessage getUserFriendlyMessage(dynamic error) {
    // Log technical details for debugging
    debugPrint('ERROR DETAILS: $error');
    
    final errorStr = error.toString().toLowerCase();
    
    // Network/Connection errors
    if (errorStr.contains('socket') || 
        errorStr.contains('network') || 
        errorStr.contains('connection') ||
        errorStr.contains('timeout')) {
      return InventoryErrorMessage(
        title: 'Connection Issue',
        message: 'Unable to connect to the server. Please check your internet connection.',
        action: 'Check your Wi-Fi or mobile data and try again.',
        type: ErrorType.network,
      );
    }
    
    // Supabase specific errors
    if (errorStr.contains('postgrest') || errorStr.contains('supabase')) {
      if (errorStr.contains('permission') || errorStr.contains('unauthorized')) {
        return InventoryErrorMessage(
          title: 'Access Denied',
          message: 'You don\'t have permission to perform this action.',
          action: 'Please contact support if you think this is a mistake.',
          type: ErrorType.permission,
        );
      }
      if (errorStr.contains('duplicate') || errorStr.contains('unique')) {
        return InventoryErrorMessage(
          title: 'Duplicate Entry',
          message: 'An item with this information already exists.',
          action: 'Try using different details or edit the existing item.',
          type: ErrorType.validation,
        );
      }
      return InventoryErrorMessage(
        title: 'Server Error',
        message: 'Something went wrong on our end.',
        action: 'Please try again in a moment.',
        type: ErrorType.server,
      );
    }
    
    // Repository/Data source errors
    if (errorStr.contains('repositoryexception') || 
        errorStr.contains('datasourceexception')) {
      if (errorStr.contains('not found')) {
        return InventoryErrorMessage(
          title: 'Not Found',
          message: 'The requested item or inventory could not be found.',
          action: 'It may have been deleted. Refresh the page to see latest items.',
          type: ErrorType.notFound,
        );
      }
    }
    
    // Validation errors (from repository/use cases)
    if (errorStr.contains('cannot be empty')) {
      return InventoryErrorMessage(
        title: 'Missing Information',
        message: 'Please fill in all required fields.',
        action: 'Check that you\'ve entered a name and description.',
        type: ErrorType.validation,
      );
    }
    
    if (errorStr.contains('quantity')) {
      return InventoryErrorMessage(
        title: 'Invalid Quantity',
        message: 'The quantity must be a positive number.',
        action: 'Enter a number greater than zero.',
        type: ErrorType.validation,
      );
    }
    
    if (errorStr.contains('expiration date')) {
      return InventoryErrorMessage(
        title: 'Invalid Date',
        message: 'The expiration date cannot be in the past.',
        action: 'Please select a future date for expiration.',
        type: ErrorType.validation,
      );
    }
    
    // Generic fallback
    return InventoryErrorMessage(
      title: 'Something Went Wrong',
      message: 'An unexpected error occurred.',
      action: 'Please try again. If the problem persists, restart the app.',
      type: ErrorType.unknown,
    );
  }
  
  /// Shows a user-friendly error snackbar
  static void showErrorSnackbar(
    BuildContext context, 
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    final friendlyError = getUserFriendlyMessage(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              friendlyError.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(friendlyError.message),
            const SizedBox(height: 2),
            Text(
              friendlyError.action,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: _getErrorColor(friendlyError.type),
        duration: const Duration(seconds: 5),
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }
  
  /// Shows a user-friendly error dialog for critical errors
  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) async {
    final friendlyError = getUserFriendlyMessage(error);
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(_getErrorIcon(friendlyError.type), color: Colors.red),
            const SizedBox(width: 8),
            Text(friendlyError.title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(friendlyError.message),
            const SizedBox(height: 8),
            Text(
              friendlyError.action,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDismiss?.call();
            },
            child: const Text('Dismiss'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onRetry();
              },
              child: const Text('Try Again'),
            ),
        ],
      ),
    );
  }
  
  static Color _getErrorColor(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.permission:
        return Colors.red;
      case ErrorType.validation:
        return Colors.amber;
      case ErrorType.server:
        return Colors.red;
      case ErrorType.notFound:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }
  
  static IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.permission:
        return Icons.lock;
      case ErrorType.validation:
        return Icons.warning;
      case ErrorType.server:
        return Icons.cloud_off;
      case ErrorType.notFound:
        return Icons.search_off;
      default:
        return Icons.error;
    }
  }
}

/// User-friendly error message structure
class InventoryErrorMessage {
  final String title;
  final String message;
  final String action;
  final ErrorType type;
  
  InventoryErrorMessage({
    required this.title,
    required this.message,
    required this.action,
    required this.type,
  });
}

enum ErrorType {
  network,
  permission,
  validation,
  server,
  notFound,
  unknown,
}
