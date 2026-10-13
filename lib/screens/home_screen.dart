import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';
import '../screens/transaction_list_screen.dart';
import '../screens/report_screen.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int _reload = 0;

  Future<void> _openAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
    setState(() => _reload++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          DashboardScreen(key: ValueKey('dash$_reload')),
          TransactionListScreen(key: ValueKey('list$_reload')),
          ReportScreen(key: ValueKey('rep$_reload')),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Resumo'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: 'Transacoes'),
          NavigationDestination(icon: Icon(Icons.pie_chart_outline), label: 'Relatorio'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}