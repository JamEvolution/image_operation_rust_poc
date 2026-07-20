import 'package:flutter_test/flutter_test.dart';
import 'package:image_operation_rust/app/image_operation_rust_app.dart';
import 'package:image_operation_rust/native_image_api.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  testWidgets('Shows image process PoC UI', (WidgetTester tester) async {
    await tester.pumpWidget(const ImageOperationRustApp());
    await tester.pumpAndSettle();
    expect(find.text('image_operation_rust PoC'), findsOneWidget);
    expect(find.text('Pick high-res photo'), findsOneWidget);
  });
}
