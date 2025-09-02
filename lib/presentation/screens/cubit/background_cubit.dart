import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'background_state.dart';

class BackgroundCubit extends Cubit<String?> {
  BackgroundCubit() : super(null);

  void changeBackground(String? path) {
    emit(path);
  }
}
