import 'package:fellow4u/main.dart';
import 'package:fellow4u/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Fellow4U app builds', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      Fellow4UApp(authProvider: AuthProvider()),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
