// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'image_operation_rust';

  @override
  String get appBarTitle => 'image_operation_rust PoC';

  @override
  String get pickHighResPhoto => 'Yüksek çözünürlüklü fotoğraf seç';

  @override
  String get uiLivenessBanner =>
      'UI canlılık kontrolü: Rust FFI görüntüyü işlerken bu spinner dönmeye devam etmeli. Donarsa UI thread bloklanmış demektir.';

  @override
  String originalSize(String size) {
    return 'Orijinal boyut: $size MB';
  }

  @override
  String originalResolution(String width, String height) {
    return 'Orijinal çözünürlük: $width x $height';
  }

  @override
  String get processWithRustFfi => 'Rust FFI ile işle';

  @override
  String get processingOnRustWorker => 'Rust worker üzerinde işleniyor…';

  @override
  String elapsedMilliseconds(String milliseconds) {
    return 'Süre: $milliseconds ms';
  }

  @override
  String processedSize(String size) {
    return 'İşlenmiş boyut: $size MB';
  }

  @override
  String outputSpec(int width, int height, int quality) {
    return 'Çıktı: ${width}x$height JPEG (q=$quality)';
  }

  @override
  String get languageEnglish => 'EN';

  @override
  String get languageTurkish => 'TR';
}
