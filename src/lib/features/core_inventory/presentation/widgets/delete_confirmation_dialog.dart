import 'package:flutter/material.dart';
import '../utils/error_handler.dart';

class DeleteConfirmationDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String itemName,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text(
          'Are you sure you want to delete "$itemName"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop(true);
              try {
                // Remove 'await' here since onConfirm returns void, not Future
                onConfirm();
              } catch (error) {
                if (context.mounted) {
                  InventoryErrorHandler.showErrorSnackbar(context, error);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
