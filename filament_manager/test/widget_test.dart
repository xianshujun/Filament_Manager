import 'package:flutter_test/flutter_test.dart';

import 'package:filament_manager/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FilamentManagerApp());

    expect(find.text('耗材管家'), findsOneWidget);
  });
}