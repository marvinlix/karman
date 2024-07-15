import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/models/habits/habit.dart';
import 'package:karman_app/controllers/habit/habit_controller.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HabitCompletionSheet extends StatefulWidget {
  final Habit habit;

  const HabitCompletionSheet({
    super.key,
    required this.habit,
  });

  @override
  _HabitCompletionSheetState createState() => _HabitCompletionSheetState();
}

class _HabitCompletionSheetState extends State<HabitCompletionSheet> {
  final TextEditingController _logController = TextEditingController();

  @override
  void dispose() {
    _logController.dispose();
    super.dispose();
  }

  Future<void> _completeHabit() async {
    final habitController = context.read<HabitController>();
    await habitController.completeHabitForToday(
        widget.habit, _logController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
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
                _buildDragHandle(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete ${widget.habit.habitName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildLogField(),
                          SizedBox(height: 20),
                          _buildSlideToAct(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildLogField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Log (Optional):',
          style: TextStyle(color: CupertinoColors.white, fontSize: 16),
        ),
        SizedBox(height: 8),
        TaskNote(
          controller: _logController,
          hintText: 'Enter your log here...',
        ),
      ],
    );
  }

  Widget _buildSlideToAct() {
    return SlideAction(
      innerColor: CupertinoColors.white,
      outerColor: CupertinoColors.systemGrey,
      sliderButtonIcon: Icon(
        CupertinoIcons.circle_grid_hex,
        color: CupertinoColors.black,
      ),
      sliderRotate: false,
      elevation: 0,
      text: 'Complete your habit',
      textColor: CupertinoColors.black,
      onSubmit: _completeHabit,
    );
  }
}

class TaskNote extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const TaskNote({
    Key? key,
    required this.controller,
    this.hintText = 'Add a note...',
  }) : super(key: key);

  @override
  _TaskNoteState createState() => _TaskNoteState();
}

class _TaskNoteState extends State<TaskNote> {
  int _noteLines = 1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateNoteLines);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateNoteLines);
    super.dispose();
  }

  void _updateNoteLines() {
    final newLines = '\n'.allMatches(widget.controller.text).length + 1;
    if (newLines != _noteLines) {
      setState(() {
        _noteLines = newLines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemBackground.darkColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoTextField(
        controller: widget.controller,
        style: TextStyle(color: Colors.white),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        placeholder: widget.hintText,
        placeholderStyle: TextStyle(color: Colors.grey),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        padding: EdgeInsets.all(12),
      ),
    );
  }
}
