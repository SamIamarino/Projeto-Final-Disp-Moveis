import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  final VoidCallback onChange;
  const ExpenseTile({super.key, required this.expense, required this.onDelete, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.title),
      subtitle:
          Text('${expense.category} • ${expense.date.toLocal()}'.split(' ')[0]),
      trailing: Text('R\$ ${expense.amount.toStringAsFixed(2)}'),
      onLongPress: onDelete,
      onTap: onChange,
    );
  }
}
