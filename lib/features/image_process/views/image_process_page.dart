import 'package:flutter/material.dart';
import 'package:image_operation_rust/features/image_process/view_models/image_process_view_model.dart';
import 'package:image_operation_rust/features/image_process/widgets/language_toggle_buttons.dart';
import 'package:image_operation_rust/features/image_process/widgets/original_image_section.dart';
import 'package:image_operation_rust/features/image_process/widgets/processed_image_section.dart';
import 'package:image_operation_rust/features/image_process/widgets/ui_liveness_banner.dart';
import 'package:image_operation_rust/l10n/app_localizations.dart';
import 'package:image_operation_rust/l10n/locale_controller.dart';

class ImageProcessPage extends StatefulWidget {
  const ImageProcessPage({
    required this.localeController,
    super.key,
  });

  final LocaleController localeController;

  @override
  State<ImageProcessPage> createState() => _ImageProcessPageState();
}

class _ImageProcessPageState extends State<ImageProcessPage> {
  late final ImageProcessViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ImageProcessViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.appBarTitle),
            actions: <Widget>[
              LanguageToggleButtons(
                localeController: widget.localeController,
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const UiLivenessBanner(),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _viewModel.isProcessing
                      ? null
                      : _viewModel.pickImageFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(localizations.pickHighResPhoto),
                ),
                if (_viewModel.hasOriginalImage) ...<Widget>[
                  const SizedBox(height: 12),
                  OriginalImageSection(
                    originalBytes: _viewModel.originalBytes!,
                    originalSizeInMegabytes: _viewModel.originalSizeInMegabytes,
                    originalWidth: _viewModel.originalWidth,
                    originalHeight: _viewModel.originalHeight,
                    isProcessing: _viewModel.isProcessing,
                    onProcessPressed: _viewModel.processWithRustFfi,
                  ),
                ],
                if (_viewModel.hasError) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    _viewModel.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                if (_viewModel.hasProcessedImage) ...<Widget>[
                  const SizedBox(height: 20),
                  ProcessedImageSection(
                    processedBytes: _viewModel.processedBytes!,
                    processedSizeInMegabytes:
                        _viewModel.processedSizeInMegabytes,
                    elapsedMilliseconds: _viewModel.elapsedMilliseconds,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
