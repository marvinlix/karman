import 'package:flutter/cupertino.dart';

class TaskFolder {
  final int? folder_id;
  final String name;
  final IconData icon;

  TaskFolder({
    this.folder_id,
    required this.name,
    this.icon = CupertinoIcons.folder_fill,
  });

  Map<String, dynamic> toMap() {
    return {
      'folder_id': folder_id,
      'name': name,
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily,
    };
  }

  factory TaskFolder.fromMap(Map<String, dynamic> map) {
    return TaskFolder(
      folder_id: map['folder_id'],
      name: map['name'],
      icon: IconData(
        map['icon_code_point'],
        fontFamily: map['icon_font_family'],
        fontPackage: CupertinoIcons.folder_fill.fontPackage,
      ),
    );
  }
}
