import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overcooked/Utils/colors.dart' as color;
import 'package:overcooked/newFlow/widgets/color.dart'as colors;

import '../../Utils/colors.dart';

class FreeAmountDialog extends StatefulWidget {
  final Function(String) onSave;

  const FreeAmountDialog({super.key, required this.onSave});

  @override
  State<FreeAmountDialog> createState() =>
      _FreeAmountDialogState();
}

class _FreeAmountDialogState extends State<FreeAmountDialog> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:colors. popupColor,
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "Add Emergency Number",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
      
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(_controller.text.trim());
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Save",
                    style: TextStyle(fontSize: 16, color: color.colorDark1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
