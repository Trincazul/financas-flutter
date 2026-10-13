import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../services/finance_service.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final _service = FinanceService();
  List<FinanceTransaction> _items = [];
  TransactionType? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() => _items = _service.all());
  }

  Future<void> _delete(FinanceTransaction t) async {
    await _service.delete(t.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final visible = _filter == null ? _items : _items.where((t) => t.type == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacoes'),
        actions: [
          PopupMenuButton<TransactionType?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) => setState(() => _filter = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('Todas')),
              PopupMenuItem(value: TransactionType.income, child: Text('Receitas')),
              PopupMenuItem(value: TransactionType.expense, child: Text('Despesas')),
            ],
          ),
        ],
      ),
      body: visible.isEmpty
          ? const Center(child: Text('Nenhuma transacao.'))
          : ListView.builder(
              itemCount: visible.length,
              itemBuilder: (_, i) {
                final t = visible[i];
                final isIncome = t.type == TransactionType.income;
                return Dismissible(
                  key: Key(t.id),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
                  confirmDismiss: (_) async => true,
                  onDismissed: (_) => _delete(t),
                  child: ListTile(
                    leading: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.green : Colors.red),
                    title: Text(t.category),
                    subtitle: Text('${DateFormat('dd/MM/yyyy').format(t.date)}${t.note != null ? ' • ${t.note}' : ''}'),
                    trailing: Text(
                      (isIncome ? '+' : '-') + fmt.format(t.amount),
                      style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}