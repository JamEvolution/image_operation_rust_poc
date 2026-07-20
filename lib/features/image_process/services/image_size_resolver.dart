import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageSizeResolver {
  const ImageSizeResolver();

  Future<ui.Size?> resolveImageSize(Uint8List bytes) async {
    final Completer<ui.Size> completer = Completer<ui.Size>();
    ui.decodeImageFromList(bytes, (ui.Image image) {
      completer.complete(
        ui.Size(image.width.toDouble(), image.height.toDouble()),
      );
      image.dispose();
    });
    try {
      return await completer.future;
    } catch (_) {
      return null;
    }
  }
}
