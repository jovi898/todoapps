part of 'calendar_bloc.dart';

@immutable
sealed class CalendarState {
  final DateTime? selectedDay;

  const CalendarState({required this.selectedDay});
}

class CalendarInitial extends CalendarState {
  const CalendarInitial({required super.selectedDay});
}
