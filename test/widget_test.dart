import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity/main.dart'; // package is antigravity

void main() {
  testWidgets('App compiles and runs completely', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AntiGravityApp()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
