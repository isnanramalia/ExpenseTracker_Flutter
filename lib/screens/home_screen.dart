import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  DateTime? _selectedMonth;

  void _addExpense(String title, double amount, DateTime date) {
    final newExpense = Expense(title: title, amount: amount, date: date);
    setState(() {
      _expenses.add(newExpense);
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  double _calculateMonthlyTotal() {
    final selectedMonth = _selectedMonth ?? DateTime.now();
    return _expenses
        .where((expense) =>
    expense.date.month == selectedMonth.month &&
        expense.date.year == selectedMonth.year)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _pickMonth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedMonth = DateTime(pickedDate.year, pickedDate.month);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalMonthlyExpense = _calculateMonthlyTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Monthly Expense',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    TextButton(
                      onPressed: _pickMonth,
                      child: Text(
                        _selectedMonth == null
                            ? 'Select Month'
                            : DateFormat.yMMMM().format(_selectedMonth!),
                        style: const TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${totalMonthlyExpense.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
          _expenses.isEmpty
              ? Expanded(
            child: Center(
              child: const Text(
                'No expenses yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return ExpenseCard(
                  expense: _expenses[index],
                  onDelete: () => _deleteExpense(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
                onAddExpense: _addExpense,
              ),
            ),
          );
        },
      ),
    );
  }
}
