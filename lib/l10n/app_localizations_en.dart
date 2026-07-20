// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'image_operation_rust';

  @override
  String get appBarTitle => 'image_operation_rust PoC';

  @override
  String get pickHighResPhoto => 'Pick high-res photo';

  @override
  String get uiLivenessBanner =>
      'UI liveness check: this spinner must keep rotating while Rust FFI processes the image. If it freezes, the UI thread is blocked.';

  @override
  String originalSize(String size) {
    return 'Original size: $size MB';
  }

  @override
  String originalResolution(String width, String height) {
    return 'Original resolution: $width x $height';
  }

  @override
  String get processWithRustFfi => 'Process with Rust FFI';

  @override
  String get processingOnRustWorker => 'Processing on Rust worker…';

  @override
  String elapsedMilliseconds(String milliseconds) {
    return 'Elapsed: $milliseconds ms';
  }

  @override
  String processedSize(String size) {
    return 'Processed size: $size MB';
  }

  @override
  String outputSpec(int width, int height, int quality) {
    return 'Output: ${width}x$height JPEG (q=$quality)';
  }

  @override
  String get languageEnglish => 'EN';

  @override
  String get languageTurkish => 'TR';
}
