import 'package:flutter/material.dart';
import 'package:karman_app/components/folder_tile.dart';
import 'package:karman_app/data/database.dart';

class SideDrawer extends StatefulWidget {
  final Function(String) onFolderSelected;
  final KarmanDataBase db;

  const SideDrawer({super.key, required this.onFolderSelected, required this.db});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final _controller = TextEditingController();

  void createNewFolder() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Folder'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.db.folders[_controller.text] = [];
                  widget.db.updateDatabase();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: widget.db.folders.keys.map((folder) {
                return FolderTile(
                  folderName: folder,
                  onChanged: (_) {},
                  onEdit: (context) {
                    _controller.text = folder;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Edit Folder Name'),
                          content: TextField(
                            controller: _controller,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  var tasks = widget.db.folders.remove(folder);
                                  widget.db.folders[_controller.text] = tasks!;
                                  widget.db.updateDatabase();
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDelete: (context) {
                    setState(() {
                      widget.db.folders.remove(folder);
                      widget.db.updateDatabase();
                    });
                  },
                  onTap: () {
                    widget.onFolderSelected(folder);
                  },
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.white),
            title: Text('Add Folder', style: TextStyle(color: Colors.white)),
            onTap: createNewFolder,
          ),
        ],
      ),
    );
  }
}
