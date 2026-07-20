import 'package:flutter/material.dart';
import 'package:image_operation_rust/l10n/app_localizations.dart';
import 'package:image_operation_rust/l10n/locale_controller.dart';

class LanguageToggleButtons extends StatelessWidget {
  const LanguageToggleButtons({
    required this.localeController,
    super.key,
  });

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: localeController,
      builder: (BuildContext context, Widget? child) {
        final String languageCode = localeController.locale.languageCode;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SegmentedButton<String>(
            segments: <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: 'en',
                label: Text(localizations.languageEnglish),
              ),
              ButtonSegment<String>(
                value: 'tr',
                label: Text(localizations.languageTurkish),
              ),
            ],
            selected: <String>{languageCode},
            onSelectionChanged: (Set<String> selection) {
              final String selectedCode = selection.first;
              if (selectedCode == 'tr') {
                localeController.selectTurkish();
                return;
              }
              localeController.selectEnglish();
            },
          ),
        );
      },
    );
  }
}
