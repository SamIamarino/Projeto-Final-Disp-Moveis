import 'package:flutter/material.dart';
import 'package:gestorfinanceiro/views/screens/grafics_expense_screen.dart';
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
      appBar: AppBar(title: const Text('Meus Gastos')),
      body: FutureBuilder<List<Expense>>(
        future: _futureExpenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('Sem gastos registrados ainda!'));
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
      // Use a Stack to position multiple FloatingActionButtons
      floatingActionButton: Stack(
        children: <Widget>[
          // Bottom Right FloatingActionButton (existing)
          Positioned(
            bottom: 12.0, // Adjust as needed
            right: 10.0, // Adjust as needed
            child: FloatingActionButton(
                onPressed: () async {
                  final added = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                  );
                  if (added == true) _refresh();
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.lightGreen.shade200),
          ),
          // Bottom Left FloatingActionButton (new)
          Positioned(
            bottom: 12.0, // Adjust as needed
            left: 40.0, // Adjust as needed
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GraphicsExpenseScreen(),
                  ),
                );
              },
              heroTag: "bottomLeftBtn", // Crucial for multiple FABs
              child: const Icon(Icons.filter_list), // Example icon
              backgroundColor: Colors.lightGreen.shade200,
            ),
          ),
        ],
      ),
    );
  }
}
