import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FolderTile extends StatelessWidget {
  final String folderName;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? onEdit;
  final Function(BuildContext)? onDelete;
  final Function()? onTap;  // Add this line

  const FolderTile({
    super.key,
    required this.folderName,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,  // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,  // Add this line
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Slidable(
          key: ValueKey(folderName),
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: onEdit,
                backgroundColor: Colors.grey[900]!,
                foregroundColor: Colors.blueAccent,
                icon: Icons.mode_edit_outline_rounded,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: onDelete,
                backgroundColor: Colors.grey[900]!,
                foregroundColor: Colors.redAccent,
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[700]!,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              folderName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
