import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../services/finance_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _service = FinanceService();

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final expenses = _service.all().where((t) => t.type == TransactionType.expense).toList();
    final map = <String, double>{};
    for (final t in expenses) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    final entries = map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = expenses.fold(0.0, (s, t) => s + t.amount);

    return Scaffold(
      appBar: AppBar(title: const Text('Relatorio de Despesas')),
      body: entries.isEmpty
          ? const Center(child: Text('Sem despesas registradas.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Total de despesas: ${fmt.format(total)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                ...entries.map((e) {
                  final pct = total == 0 ? 0.0 : e.value / total;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(e.key), Text(fmt.format(e.value))],
                        ),
                        const SizedBox(height: 4),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: pct),
                          duration: const Duration(milliseconds: 500),
                          builder: (_, v, __) => LinearProgressIndicator(value: v, minHeight: 8),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}