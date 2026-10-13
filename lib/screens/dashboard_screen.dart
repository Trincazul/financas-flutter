import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../services/finance_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _service = FinanceService();
  late List<FinanceTransaction> _items;

  @override
  void initState() {
    super.initState();
    _items = _service.byMonth(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final income = _service.totalIncome(_items);
    final expense = _service.totalExpense(_items);
    final balance = income - expense;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo do Mes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              _card('Receitas', income, Colors.green, fmt),
              const SizedBox(width: 8),
              _card('Despesas', expense, Colors.red, fmt),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            color: balance >= 0 ? Colors.teal.shade50 : Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo', style: TextStyle(fontSize: 14)),
                  Text(fmt.format(balance), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Ultimas transacoes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_items.isEmpty) const Center(child: Text('Nenhuma transacao neste mes.')),
          ..._items.take(8).map(_tile),
        ],
      ),
    );
  }

  Widget _card(String title, double value, Color color, NumberFormat fmt) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(fmt.format(value), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(FinanceTransaction t) {
    final isIncome = t.type == TransactionType.income;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.green : Colors.red),
      ),
      title: Text(t.category),
      subtitle: Text(t.note ?? DateFormat('dd/MM/yyyy').format(t.date)),
      trailing: Text(
        (isIncome ? '+' : '-') + t.amount.toStringAsFixed(2),
        style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}