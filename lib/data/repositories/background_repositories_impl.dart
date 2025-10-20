import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:todoapp/domain/repositories/background_repository.dart';

class BackgroundRepositoriesImpl implements BackgroundRepository {
  final ImagePicker picker;

  const BackgroundRepositoriesImpl(this.picker);

  @override
  Future<Uint8List?> pickBackground() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.readAsBytes();
    }
    return null;
  }
}
