import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_operation_rust/features/image_process/image_process_constants.dart';
import 'package:image_operation_rust/l10n/app_localizations.dart';

class ProcessedImageSection extends StatelessWidget {
  const ProcessedImageSection({
    required this.processedBytes,
    required this.processedSizeInMegabytes,
    required this.elapsedMilliseconds,
    super.key,
  });

  final Uint8List processedBytes;
  final double processedSizeInMegabytes;
  final int? elapsedMilliseconds;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final String millisecondsLabel = elapsedMilliseconds?.toString() ?? '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          localizations.elapsedMilliseconds(millisecondsLabel),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          localizations.processedSize(
            processedSizeInMegabytes.toStringAsFixed(2),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          localizations.outputSpec(
            ImageProcessConstants.targetWidth,
            ImageProcessConstants.targetHeight,
            ImageProcessConstants.jpegQuality,
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            processedBytes,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
