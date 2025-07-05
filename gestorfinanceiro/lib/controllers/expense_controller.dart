import '../models/expense.dart';
import '../services/db_service.dart';

class ExpenseController {
  final DBService _db = DBService();

  Future<void> addExpense(Expense e) => _db.insertExpense(e);

  Future<List<Expense>> getAllExpenses() => _db.fetchExpenses();

  Future<void> removeExpense(int id) => _db.deleteExpense(id);
}
