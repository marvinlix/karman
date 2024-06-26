// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:ffi';

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
      backgroundColor: Colors.transparent,
      content: Container(
        height: 120,
        child: Column(
          children: [
            // user input field
            TextField(
              controller: controller,
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),

            // cancel and save buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                    label: "Cancel", color: Colors.redAccent, onPressed: onCancel),
                MyButton(
                    label: "Save", color: Colors.lightBlue, onPressed: onSave),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
