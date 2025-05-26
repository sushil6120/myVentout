import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overcooked/Utils/colors.dart' as color;
import 'package:overcooked/newFlow/widgets/color.dart'as colors;

import '../../Utils/colors.dart';

class AddEmergencyNumberDialog extends StatefulWidget {
  final Function(String) onSave;

  const AddEmergencyNumberDialog({super.key, required this.onSave});

  @override
  State<AddEmergencyNumberDialog> createState() =>
      _AddEmergencyNumberDialogState();
}

class _AddEmergencyNumberDialogState extends State<AddEmergencyNumberDialog> {
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
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10)
                ],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: "Emergency Contact Number",
                  labelStyle: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  hintText: "Enter 10-digit number",
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon:
                      const Icon(Icons.phone_android, color: Colors.white70),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white30, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color.primaryColor, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 2),
                  ),
                  fillColor: Colors.black54,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a number";
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                    return "Enter a valid 10-digit number";
                  }
                  return null;
                },
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
