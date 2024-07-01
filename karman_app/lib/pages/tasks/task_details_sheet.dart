import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskDetailsSheet extends StatefulWidget {
  final String taskName;

  const TaskDetailsSheet({
    super.key,
    required this.taskName,
  });

  @override
  _TaskDetailsSheetState createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          CupertinoIcons.clear_circled,
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
                  child: Column(
                    children: [
                      // Additional features will be added here
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
