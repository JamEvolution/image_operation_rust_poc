import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_operation_rust/features/image_process/views/image_process_page.dart';
import 'package:image_operation_rust/l10n/app_localizations.dart';
import 'package:image_operation_rust/l10n/locale_controller.dart';

class ImageOperationRustApp extends StatefulWidget {
  const ImageOperationRustApp({super.key});

  @override
  State<ImageOperationRustApp> createState() => _ImageOperationRustAppState();
}

class _ImageOperationRustAppState extends State<ImageOperationRustApp> {
  late final LocaleController _localeController;

  @override
  void initState() {
    super.initState();
    _localeController = LocaleController();
  }

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _localeController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          onGenerateTitle: (BuildContext context) {
            return AppLocalizations.of(context).appTitle;
          },
          debugShowCheckedModeBanner: false,
          locale: _localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
            useMaterial3: true,
          ),
          home: ImageProcessPage(localeController: _localeController),
        );
      },
    );
  }
}
