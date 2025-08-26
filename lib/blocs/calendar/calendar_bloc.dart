import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(const CalendarInitial(selectedDay: null)) {
    on<DaySelected>((event, emit) {
      emit(CalendarInitial(selectedDay: event.selectedDay));
    });
  }
}
