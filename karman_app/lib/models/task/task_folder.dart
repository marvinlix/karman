class TaskFolder {
  final int? folder_id; // Changed from id to folder_id
  final String name;

  TaskFolder({
    this.folder_id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'folder_id': folder_id, // Changed from id to folder_id
      'name': name,
    };
  }

  factory TaskFolder.fromMap(Map<String, dynamic> map) {
    return TaskFolder(
      folder_id: map['folder_id'], // Changed from id to folder_id
      name: map['name'],
    );
  }
}
