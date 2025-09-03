import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'background_state.dart';

class BackgroundCubit extends Cubit<String?> {
  final ImagePicker picker = ImagePicker();
  BackgroundCubit() : super(null);

  void changeBackground(String? path) {
    emit(path);
  }

  Future<void> pickBackgroundImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(image.path);
    }
  }
}
