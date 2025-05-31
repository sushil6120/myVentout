import 'package:flutter/material.dart';
import 'package:overcooked/Utils/colors.dart';

void showConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  String title = 'Confirmation',
  String message = 'Are you sure?',
  String confirmText = 'Yes',
  String cancelText = 'No',
  Color? backgroundColor,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
  bool barrierDismissible = true,
  bool useRoundedButtons = true,
  Duration transitionDuration = const Duration(milliseconds: 250),
}) {
  final theme = Theme.of(context);
  
  // Default colors if not provided
  backgroundColor ??= primaryColorDark;
  confirmButtonColor ??= primaryColor;
  cancelButtonColor ??= colorLightWhite;
  
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black54,

    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          if (useRoundedButtons)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: cancelButtonColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: BorderSide(color: cancelButtonColor!, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: cancelButtonColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmButtonColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel?.call();
                  },
                  child: Text(
                    cancelText,
                    style: TextStyle(
                      color: cancelButtonColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  child: Text(
                    confirmText,
                    style: TextStyle(
                      color: confirmButtonColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    },
  );
}