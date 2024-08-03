import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskNameInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSave;
  final bool isTaskNameEmpty;

  const TaskNameInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSave,
    required this.isTaskNameEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoTextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            placeholder: 'Task Name',
            placeholderStyle: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(width: 20),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isTaskNameEmpty ? null : onSave,
          child: Text(
            'Save',
            style: TextStyle(
              color: isTaskNameEmpty
                  ? CupertinoColors.systemGrey
                  : CupertinoColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
