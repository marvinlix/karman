import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karman_app/components/dialog_window.dart';
import 'package:karman_app/components/folder_tile.dart';
import 'package:karman_app/controllers/task/task_controller.dart';
import 'package:karman_app/models/task/task_folder.dart';
import 'package:provider/provider.dart';

class FolderDrawer extends StatelessWidget {
  final Function(TaskFolder) onFolderSelected;
  final TextEditingController controller;
  final VoidCallback onCreateFolder;

  const FolderDrawer({
    Key? key,
    required this.onFolderSelected,
    required this.controller,
    required this.onCreateFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        List<TaskFolder> folders = taskController.folders;

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
                            'Folders',
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
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return KarmanDialogWindow(
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
                            child: Icon(
                              CupertinoIcons.add_circled,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        return FolderTile(
                          folder: folders[index],
                          onTap: () {
                            onFolderSelected(folders[index]);
                            Navigator.of(context).pop();
                          },
                          onEdit: (context) => _editFolder(
                              context, taskController, folders[index]),
                          onDelete: (context) => _deleteFolder(
                              context, taskController, folders[index].folder_id!),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _editFolder(
      BuildContext context, TaskController taskController, TaskFolder folder) {
    controller.text = folder.name;
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return KarmanDialogWindow(
          controller: controller,
          onSave: () {
            final updatedFolder =
                TaskFolder(folder_id: folder.folder_id, name: controller.text);
            taskController.updateFolder(updatedFolder);
            controller.clear();
            Navigator.of(context).pop();
          },
          onCancel: () {
            controller.clear();
            Navigator.of(context).pop();
          },
          initialText: folder.name,
        );
      },
    );
  }

  void _deleteFolder(
      BuildContext context, TaskController taskController, int id) {
    taskController.deleteFolder(id);
  }
}
