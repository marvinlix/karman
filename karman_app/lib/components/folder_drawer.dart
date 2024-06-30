import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/components/dialog_window.dart';

class FolderDrawer extends StatelessWidget {
  final List<String> folders;
  final Function(String) onFolderSelected;
  final TextEditingController controller;
  final VoidCallback onCreateFolder;

  const FolderDrawer({super.key, 
    required this.folders,
    required this.onFolderSelected,
    required this.controller,
    required this.onCreateFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 300, 
        margin: EdgeInsets.only(
            top: 50, bottom: 50),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                child: Text('Add Folder'),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return TaskDialog(
                        controller: controller,
                        onSave: () {
                          onCreateFolder();
                          Navigator.of(context).pop();
                        },
                        onCancel: () {
                          controller.clear();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: folders.map((folder) {
                    return Container(
                      color: Colors.black,
                      child: CupertinoButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        onPressed: () {
                          onFolderSelected(folder);
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            folder,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
