import 'package:flutter/material.dart';
import 'package:karman_app/components/my_button.dart';

class TaskDialog extends StatelessWidget {
  final controller;
  VoidCallback onCancel;
  VoidCallback onSave;

  TaskDialog({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(191, 33, 33, 33),
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: TextField(
                controller: controller,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // cancel and save buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  label: "Cancel",
                  color: Colors.redAccent,
                  onPressed: onCancel,
                ),
                MyButton(
                  label: "Save",
                  color: Colors.lightBlue,
                  onPressed: onSave,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
