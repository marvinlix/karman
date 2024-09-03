import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskNameInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSave;
  final bool isTaskNameEmpty;
  final bool hasChanges;

  const TaskNameInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSave,
    required this.isTaskNameEmpty,
    required this.hasChanges,
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
              fontSize: 20,
            ),
            placeholder: 'Task Name',
            placeholderStyle: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(width: 20),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onSave,
          child: Text(
            'Save',
            style: TextStyle(
              color: (hasChanges && !isTaskNameEmpty)
                  ? CupertinoColors.white
                  : CupertinoColors.systemGrey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
