part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class DaySelected extends CalendarEvent {
  final DateTime selectedDay;

  DaySelected(this.selectedDay);
}
