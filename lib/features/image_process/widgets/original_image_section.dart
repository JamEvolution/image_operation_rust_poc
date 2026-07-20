import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_operation_rust/l10n/app_localizations.dart';

class OriginalImageSection extends StatelessWidget {
  const OriginalImageSection({
    required this.originalBytes,
    required this.originalSizeInMegabytes,
    required this.originalWidth,
    required this.originalHeight,
    required this.isProcessing,
    required this.onProcessPressed,
    super.key,
  });

  final Uint8List originalBytes;
  final double originalSizeInMegabytes;
  final int? originalWidth;
  final int? originalHeight;
  final bool isProcessing;
  final VoidCallback onProcessPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final String widthLabel = originalWidth?.toString() ?? '-';
    final String heightLabel = originalHeight?.toString() ?? '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          localizations.originalSize(
            originalSizeInMegabytes.toStringAsFixed(2),
          ),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          localizations.originalResolution(widthLabel, heightLabel),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            originalBytes,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: isProcessing ? null : onProcessPressed,
          icon: const Icon(Icons.memory),
          label: Text(
            isProcessing
                ? localizations.processingOnRustWorker
                : localizations.processWithRustFfi,
          ),
        ),
      ],
    );
  }
}
