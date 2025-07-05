import 'package:flutter/material.dart';
import '../../controllers/expense_controller.dart';
import '../../models/expense.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseController _controller = ExpenseController();

  late Future<List<Expense>> _futureExpenses;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _futureExpenses = _controller.getAllExpenses();
    setState(() {}); // triggers rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Expenses')),
      body: FutureBuilder<List<Expense>>(
        future: _futureExpenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No expenses yet.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) => ExpenseTile(
              expense: data[i],
              onDelete: () async {
                await _controller.removeExpense(data[i].id!);
                _refresh();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
          if (added == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
