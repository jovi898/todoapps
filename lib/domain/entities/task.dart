class Task {
  final int id;
  final String text;
  final bool isDone;
  final bool freeze;

  const Task({required this.id, required this.text, this.isDone = false, this.freeze = false});

  Task copyWith({int? id, String? text, bool? isDone, bool? freeze}) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      freeze: freeze ?? this.freeze,
    );
  }
}
