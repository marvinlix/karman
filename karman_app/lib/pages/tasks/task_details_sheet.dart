import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskDetailsSheet extends StatefulWidget {
  final String taskName;
  final String initialNote;
  final DateTime? initialDueDate;
  final String initialPriority;
  final Function(String, DateTime?, String) onSave;

  const TaskDetailsSheet({
    super.key,
    required this.taskName,
    required this.initialNote,
    required this.initialDueDate,
    required this.initialPriority,
    required this.onSave,
  });

  @override
  _TaskDetailsSheetState createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
  late TextEditingController _noteController;
  late DateTime? _dueDate;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
    _dueDate = widget.initialDueDate;
    _priority = widget.initialPriority;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    widget.onSave(_noteController.text, _dueDate, _priority);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.taskName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _saveChanges,
                        child: Icon(
                          CupertinoIcons.check_mark_circled,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        CupertinoTextField(
                          controller: _noteController,
                          placeholder: 'Add a note...',
                          style: TextStyle(color: Colors.white),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey.darkColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Due Date:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          color: CupertinoColors.systemGrey.darkColor,
                          child: Text(
                            _dueDate == null
                                ? 'Select Due Date'
                                : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _showDatePicker(context);
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Priority:',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildPriorityOption('Low', Colors.green),
                            _buildPriorityOption('Medium', Colors.yellow),
                            _buildPriorityOption('High', Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriorityOption(String priority, Color color) {
    bool isSelected = _priority == priority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = priority;
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color : Colors.transparent,
              border: Border.all(
                color: isSelected ? color : Colors.white,
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.flag_fill,
                color: isSelected ? Colors.black : color,
                size: 20,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            priority,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 240,
              child: CupertinoDatePicker(
                initialDateTime: _dueDate ?? DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _dueDate = dateTime;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }
}
