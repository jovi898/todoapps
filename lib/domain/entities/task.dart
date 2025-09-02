class Task {
  final int id;
  final String text;
  final bool isDone;
  final bool favorite;

  const Task({required this.id, required this.text, this.isDone = false, this.favorite = false});

  Task copyWith({int? id, String? text, bool? isDone, bool? favorite}) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      favorite: favorite ?? this.favorite,
    );
  }
}
