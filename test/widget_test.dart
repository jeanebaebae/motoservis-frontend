import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('opens login page from onboarding page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MotoServis'), findsOneWidget);
    expect(find.text('Masuk dengan Email'), findsOneWidget);

    await tester.ensureVisible(find.text('Masuk dengan Email'));
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk MotoServis'), findsOneWidget);
    expect(find.text('Lupa Password?'), findsOneWidget);
    expect(find.text('Belum punya akun? '), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('opens forgot password page from login page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Masuk dengan Email'));
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lupa Password?'));
    await tester.pumpAndSettle();

    expect(find.text('Buat Password Baru'), findsOneWidget);
    expect(find.text('Konfirmasi Password'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('opens sign up page from login page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Masuk dengan Email'));
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Daftar Sekarang'));
    await tester.tap(find.text('Daftar Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Daftar MotoServis'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
  });

  testWidgets('shows updated settings options', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Masuk dengan Email'));
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();

    expect(find.text('Informasi Akun'), findsOneWidget);
    expect(find.text('Password'), findsNothing);
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('opens account information page from settings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Masuk dengan Email'));
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Informasi Akun'));
    await tester.pumpAndSettle();

    expect(find.text('Informasi Akun'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Tanggal Bergabung'), findsOneWidget);
    expect(find.text('budi.santoso@motor.com'), findsOneWidget);
  });

  testWidgets('opens forgot password page from account information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Masuk dengan Email'));
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Informasi Akun'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Password'));
    await tester.pumpAndSettle();

    expect(find.text('Buat Password Baru'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Konfirmasi Password'), findsOneWidget);
  });

  testWidgets('logout returns to onboarding page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Masuk dengan Email'));
    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Kelola servis motormu dengan mudah'), findsOneWidget);
    expect(find.text('Masuk dengan Email'), findsOneWidget);
  });
}
