import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/widgets/ChatListWidget.dart';

void main() {
  MaterialApp app = MaterialApp(
    home: Scaffold(
      body: ChatListWidget(),
    ),
  );
  testWidgets('ChatListWidget UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    expect(find.byType(ListView), findsOneWidget);
  });
}