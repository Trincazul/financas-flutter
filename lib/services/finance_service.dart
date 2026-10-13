import 'package:hive/hive.dart';

import '../models/transaction.dart';

class FinanceService {
  static const String boxName = 'transactions';

  Box get _box => Hive.box(boxName);

  List<FinanceTransaction> all() {
    return _box.values
        .map((e) => FinanceTransaction.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<FinanceTransaction> byMonth(DateTime month) {
    return all()
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .toList();
  }

  Future<void> upsert(FinanceTransaction t) async {
    await _box.put(t.id, t.toMap());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  double totalIncome(List<FinanceTransaction> items) =>
      items.where((t) => t.type == TransactionType.income).fold(0.0, (s, t) => s + t.amount);

  double totalExpense(List<FinanceTransaction> items) =>
      items.where((t) => t.type == TransactionType.expense).fold(0.0, (s, t) => s + t.amount);
}