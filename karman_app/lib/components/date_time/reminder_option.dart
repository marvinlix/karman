import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ReminderOptionWidget extends StatefulWidget {
  final bool isEnabled;
  final DateTime? dateTime;
  final Function(bool) onToggle;
  final Function(DateTime) onDateTimeSelected;
  final String title;
  final String placeholder;

  const ReminderOptionWidget({
    super.key,
    required this.isEnabled,
    required this.dateTime,
    required this.onToggle,
    required this.onDateTimeSelected,
    required this.title,
    required this.placeholder,
  });

  @override
  _ReminderOptionWidgetState createState() => _ReminderOptionWidgetState();
}

class _ReminderOptionWidgetState extends State<ReminderOptionWidget>
    with SingleTickerProviderStateMixin {
  bool isPickerVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePicker(bool value) {
    widget.onToggle(value);
    if (value) {
      setState(() {
        isPickerVisible = true;
      });
      _animationController.forward();
    } else {
      _animationController.reverse().then((_) {
        setState(() {
          isPickerVisible = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToggleRow(),
        SizeTransition(
          sizeFactor: _animation,
          child: isPickerVisible ? _buildDateTimePicker() : SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildToggleRow() {
    return Row(
      children: [
        Icon(CupertinoIcons.bell, color: CupertinoColors.white),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.isEnabled) {
                _togglePicker(true);
              }
            },
            child: Text(
              widget.dateTime == null
                  ? widget.placeholder
                  : DateFormat('MMM d, yyyy HH:mm').format(widget.dateTime!),
              style: TextStyle(
                  color: widget.isEnabled
                      ? CupertinoColors.white
                      : CupertinoColors.systemGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        CupertinoSwitch(
          value: widget.isEnabled,
          onChanged: _togglePicker,
          thumbColor: CupertinoColors.black,
          activeColor: CupertinoColors.white,
          trackColor: CupertinoColors.tertiaryLabel,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime: widget.dateTime ?? DateTime.now(),
              onDateTimeChanged: widget.onDateTimeSelected,
            ),
          ),
          CupertinoButton(
            child: Text(
              'Done',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),
            onPressed: () {
              _animationController.reverse().then((_) {
                setState(() {
                  isPickerVisible = false;
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
