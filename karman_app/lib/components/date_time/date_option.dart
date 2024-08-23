import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DateOptionWidget extends StatefulWidget {
  final bool isEnabled;
  final DateTime? date;
  final Function(bool) onToggle;
  final Function(DateTime) onDateSelected;
  final String title;
  final String placeholder;

  const DateOptionWidget({
    Key? key,
    required this.isEnabled,
    required this.date,
    required this.onToggle,
    required this.onDateSelected,
    required this.title,
    required this.placeholder,
  }) : super(key: key);

  @override
  _DateOptionWidgetState createState() => _DateOptionWidgetState();
}

class _DateOptionWidgetState extends State<DateOptionWidget>
    with SingleTickerProviderStateMixin {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  bool isPickerVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.date ?? DateTime.now();
    _selectedDay = widget.date;
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
          child: isPickerVisible ? _buildCalendarPicker() : SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildToggleRow() {
    return Row(
      children: [
        Icon(CupertinoIcons.calendar, color: CupertinoColors.white),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.isEnabled) {
                _togglePicker(true);
              }
            },
            child: Text(
              widget.date == null
                  ? widget.placeholder
                  : DateFormat('MMM d, yyyy').format(widget.date!),
              style: TextStyle(
                color: widget.isEnabled
                    ? CupertinoColors.white
                    : CupertinoColors.systemGrey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
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

  Widget _buildCalendarPicker() {
    return Container(
      color: CupertinoColors.darkBackgroundGray,
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: CupertinoColors.white),
              holidayTextStyle: TextStyle(color: CupertinoColors.white),
              todayTextStyle: TextStyle(
                  color: CupertinoColors.black, fontWeight: FontWeight.bold),
              selectedTextStyle: TextStyle(
                  color: CupertinoColors.black, fontWeight: FontWeight.bold),
              defaultTextStyle: TextStyle(color: CupertinoColors.white),
              todayDecoration: BoxDecoration(
                color: CupertinoColors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: CupertinoColors.white,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: CupertinoColors.white),
              weekendStyle: TextStyle(color: CupertinoColors.white),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: CupertinoColors.white,
                fontSize: 17,
              ),
              leftChevronIcon: Icon(
                CupertinoIcons.left_chevron,
                color: CupertinoColors.white,
              ),
              rightChevronIcon: Icon(
                CupertinoIcons.right_chevron,
                color: CupertinoColors.white,
              ),
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
              if (_selectedDay != null) {
                widget.onDateSelected(_selectedDay!);
              }
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
