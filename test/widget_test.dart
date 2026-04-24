// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqllite/main.dart';
import 'package:sqllite/data/repositories/user_repository.impl.dart';
import 'package:sqllite/helper/database_helper.dart';

void main() {
  testWidgets('User App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final dbHelper = DatabaseHelper();
    final userRepository = UserRepositoryImpl(dbHelper);
    await tester.pumpWidget(MyApp(repository: userRepository));

    // Wait for initial state load
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('Daftar User'), findsOneWidget);

    // Verify initial empty state message or user list
    expect(
      find.byType(FloatingActionButton),
      findsOneWidget,
      reason: 'Should have a FloatingActionButton to add users',
    );

    // Verify the app is properly initialized
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
