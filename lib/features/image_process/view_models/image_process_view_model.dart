import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image_operation_rust/features/image_process/image_process_constants.dart';
import 'package:image_operation_rust/features/image_process/services/image_size_resolver.dart';
import 'package:image_operation_rust/native_image_api.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessViewModel extends ChangeNotifier {
  ImageProcessViewModel({
    ImagePicker? imagePicker,
    ImageSizeResolver? imageSizeResolver,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageSizeResolver = imageSizeResolver ?? const ImageSizeResolver();

  final ImagePicker _imagePicker;
  final ImageSizeResolver _imageSizeResolver;
  Uint8List? _originalBytes;
  Uint8List? _processedBytes;
  int? _originalWidth;
  int? _originalHeight;
  int? _elapsedMilliseconds;
  String? _errorMessage;
  bool _isProcessing = false;

  Uint8List? get originalBytes => _originalBytes;
  Uint8List? get processedBytes => _processedBytes;
  int? get originalWidth => _originalWidth;
  int? get originalHeight => _originalHeight;
  int? get elapsedMilliseconds => _elapsedMilliseconds;
  String? get errorMessage => _errorMessage;
  bool get isProcessing => _isProcessing;
  bool get hasOriginalImage => _originalBytes != null;
  bool get hasProcessedImage => _processedBytes != null;
  bool get hasError => _errorMessage != null;

  double get originalSizeInMegabytes {
    if (_originalBytes == null) {
      return 0;
    }
    return _originalBytes!.lengthInBytes /
        ImageProcessConstants.bytesPerMegabyte;
  }

  double get processedSizeInMegabytes {
    if (_processedBytes == null) {
      return 0;
    }
    return _processedBytes!.lengthInBytes /
        ImageProcessConstants.bytesPerMegabyte;
  }

  Future<void> pickImageFromGallery() async {
    _errorMessage = null;
    notifyListeners();
    final XFile? selectedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedFile == null) {
      return;
    }
    final Uint8List bytes = await selectedFile.readAsBytes();
    final ui.Size? decodedSize =
        await _imageSizeResolver.resolveImageSize(bytes);
    _originalBytes = bytes;
    _originalWidth = decodedSize?.width.toInt();
    _originalHeight = decodedSize?.height.toInt();
    _processedBytes = null;
    _elapsedMilliseconds = null;
    notifyListeners();
  }

  Future<void> processWithRustFfi() async {
    if (_originalBytes == null || _isProcessing) {
      return;
    }
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      final Uint8List result = await processImage(
        imageBytes: _originalBytes!,
        targetWidth: ImageProcessConstants.targetWidth,
        targetHeight: ImageProcessConstants.targetHeight,
        quality: ImageProcessConstants.jpegQuality,
      );
      stopwatch.stop();
      _processedBytes = result;
      _elapsedMilliseconds = stopwatch.elapsedMilliseconds;
    } catch (error) {
      stopwatch.stop();
      _errorMessage = error.toString();
      _elapsedMilliseconds = stopwatch.elapsedMilliseconds;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
