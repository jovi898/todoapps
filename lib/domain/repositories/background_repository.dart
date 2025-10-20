import 'dart:typed_data';

abstract interface class BackgroundRepository {
  Future<Uint8List?> pickBackground();
}
