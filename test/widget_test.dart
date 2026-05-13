import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('opens edit profile page from settings tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MotoServis'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Profil'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Push Notification'), findsOneWidget);

    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profil'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Simpan Perubahan'), findsOneWidget);
  });
}
