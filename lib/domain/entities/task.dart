import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String text;
  final bool isDone;
  final bool freeze;

  const Task({required this.id, required this.text, this.isDone = false, this.freeze = false});

  @override
  List<Object?> get props => [id, text, isDone, freeze];

  Task copyWith({int? id, String? text, bool? isDone, bool? freeze}) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      freeze: freeze ?? this.freeze,
    );
  }
}
