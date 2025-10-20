import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/domain/repositories/background_repository.dart';

part 'background_state.dart';

class BackgroundCubit extends Cubit<Uint8List?> {
  final BackgroundRepository backgroundRepository;

  BackgroundCubit(this.backgroundRepository) : super(null);

  Future<void> pickBackgroundImage() async {
    final imageBytes = await backgroundRepository.pickBackground();
    emit(imageBytes);
  }
}
