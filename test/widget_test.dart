import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:controle_financeiro/main.dart';
import 'package:controle_financeiro/services/finance_service.dart';

void main() {
  setUpAll(() async {
    Hive.init(Directory.systemTemp.path);
    await Hive.openBox(FinanceService.boxName);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
