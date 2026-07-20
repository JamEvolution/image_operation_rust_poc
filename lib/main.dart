import 'package:flutter/material.dart';
import 'package:image_operation_rust/app/image_operation_rust_app.dart';
import 'package:image_operation_rust/native_image_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const ImageOperationRustApp());
}
