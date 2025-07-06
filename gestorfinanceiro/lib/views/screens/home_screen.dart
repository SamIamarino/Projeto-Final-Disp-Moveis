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

  Future<Expense?> _showEditDialog(BuildContext context, Expense expense){

    final titleController = TextEditingController(text: expense.title);
    final amountController = TextEditingController(text: expense.amount.toString());
    final categoryController = TextEditingController(text: expense.category);

    return showDialog<Expense>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Editar Despesa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller:titleController,
                decoration: const InputDecoration( labelText: 'Nome'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration( labelText: 'Valor'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration( labelText: 'Categoria'),
              )
            ]
          ),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: (){
                final updatedExpense = Expense(
                  id: expense.id,
                  title: titleController.text, 
                  amount: double.tryParse(amountController.text) ?? expense.amount, 
                  category: categoryController.text, 
                  date: expense.date
                );
                Navigator.of(context).pop(updatedExpense);
              },
              child: const Text('Salvar'),
            ),
          ],
        );

      }
      
    );


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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return  AlertDialog(
                      title: Text('Confirmar Exclusão?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Tem certeza que deseja excluir este item?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'), 
                      ),
                      TextButton(
                      onPressed: () async {
                          await _controller.removeExpense(data[i].id!);
                          _refresh();
                          Navigator.of(context).pop();
                      },
                      child: const Text('Excluir'))
                      ],
                    );
                  }
                );
              },
              onChange: () async {

                final updatedExpense = await _showEditDialog(context, data[i]);

                if(updatedExpense != null){

                  await _controller.changeExpense(updatedExpense);
                  _refresh();

                }
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
                backgroundColor: Colors.lightGreen.shade200,
                child: const Icon(Icons.add)),
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
              heroTag: "bottomLeftBtn", // Example icon
              backgroundColor: Colors.lightGreen.shade200, // Crucial for multiple FABs
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
    );
  }
}
