class HabitLog {
  final int? id;
  final int habitId;
  final String date;
  final bool status;

  HabitLog({
    this.id,
    required this.habitId,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date,
      'status': status ? 1 : 0,
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'],
      habitId: map['habitId'],
      date: map['date'],
      status: map['status'] == 1,
    );
  }

  HabitLog copyWith({
    int? id,
    int? habitId,
    String? date,
    bool? status,
  }) {
    return HabitLog(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
