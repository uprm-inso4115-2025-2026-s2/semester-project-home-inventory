// lib/features/core_inventory/presentation/widgets/error_state_widget.dart
import 'package:flutter/material.dart';
import '../utils/error_handler.dart';

/// Widget for displaying error states in place of content
class ErrorStateWidget extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;
  final bool fullScreen;
  
  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.fullScreen = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final friendlyError = InventoryErrorHandler.getUserFriendlyMessage(error);
    
    final content = Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForType(friendlyError.type),
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              friendlyError.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              friendlyError.message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              friendlyError.action,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
    
    if (fullScreen) {
      return Scaffold(body: content);
    }
    
    return content;
  }
  
  IconData _getIconForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.signal_wifi_off;
      case ErrorType.permission:
        return Icons.lock_outline;
      case ErrorType.validation:
        return Icons.edit_note;
      case ErrorType.server:
        return Icons.cloud_off;
      case ErrorType.notFound:
        return Icons.inventory_2_outlined;
      default:
        return Icons.error_outline;
    }
  }
}
