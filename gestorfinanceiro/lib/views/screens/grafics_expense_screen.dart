import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/expense_controller.dart';
import '../../models/expense.dart';
import 'dart:math' show Random; // For random colors

class GraphicsExpenseScreen extends StatefulWidget {
  const GraphicsExpenseScreen({super.key});

  @override
  State<GraphicsExpenseScreen> createState() => _GraphicsExpenseScreenState();
}

class _GraphicsExpenseScreenState extends State<GraphicsExpenseScreen> {
  final ExpenseController _controller = ExpenseController();

  late Future<List<Expense>> _futureExpenses;

  // A list of predefined colors for chart sections
  final List<Color> _chartColors = [
    Colors.blue.shade300,
    Colors.red.shade300,
    Colors.green.shade300,
    Colors.orange.shade300,
    Colors.purple.shade300,
    Colors.teal.shade300,
    Colors.pink.shade300,
    Colors.indigo.shade300,
    Colors.brown.shade300,
    Colors.cyan.shade300,
  ];

  @override
  void initState() {
    super.initState();
    _refreshGraphicData();
  }

  void _refreshGraphicData() {
    _futureExpenses = _controller.getAllExpenses();
    setState(() {}); // Triggers a rebuild
  }

  // Helper method to group expenses by category
  Map<String, double> _groupExpensesByCategory(List<Expense> expenses) {
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return categoryTotals;
  }

  // Helper method to create PieChartSectionData
  List<PieChartSectionData> _getSections(
      Map<String, double> categoryTotals, double totalExpenses) {
    if (categoryTotals.isEmpty) {
      return [];
    }

    final List<PieChartSectionData> sections = [];
    int i = 0;
    categoryTotals.forEach((category, amount) {
      final double percentage = (amount / totalExpenses) * 100;
      final color =
          _chartColors[i % _chartColors.length]; // Cycle through colors
      i++;

      sections.add(
        PieChartSectionData(
          color: color,
          value: amount, // The value determines the size of the slice
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 100, // Adjust this for bigger/smaller pie
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          badgeWidget: _buildCategoryBadge(
              category, color), // Show category name as badge
          badgePositionPercentageOffset: 1.05, // Position the badge outside
        ),
      );
    });
    return sections;
  }

  Widget _buildCategoryBadge(String category, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white70, width: 0.5),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gráficos de Gastos')),
      body: FutureBuilder<List<Expense>>(
        future: _futureExpenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
                child: Text('Sem dados de gastos para gerar o gráfico.'));
          }

          final Map<String, double> categoryTotals =
              _groupExpensesByCategory(data);
          final double totalExpenses =
              categoryTotals.values.fold(0.0, (sum, item) => sum + item);

          // Get the pie chart sections
          final List<PieChartSectionData> sections =
              _getSections(categoryTotals, totalExpenses);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Gastos por Categoria',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.3, // Adjust aspect ratio for shape
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event,
                              PieTouchResponse? pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                // Reset selection if no interaction or no section touched
                                // This part can be used to highlight a section on touch
                              }
                            });
                          },
                        ),
                        borderData: FlBorderData(
                            show: false), // No border for pie chart
                        sectionsSpace: 2, // Space between sections
                        centerSpaceRadius:
                            40, // Inner circle radius (donut hole)
                        sections: sections,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Legend for categories
                Column(
                  children: categoryTotals.entries.map((entry) {
                    final int colorIndex =
                        categoryTotals.keys.toList().indexOf(entry.key);
                    final Color color =
                        _chartColors[colorIndex % _chartColors.length];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${entry.key}: R\$${entry.value.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                _refreshGraphicData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gráfico atualizado!')),
                );
              },
              heroTag: "refreshGraphicBtn",
              child: const Icon(Icons.refresh),
            ),
          ),
          Positioned(
            bottom: 12.0,
            left: 40.0,
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Opções de gráfico (filtro, tipo)')),
                );
              },
              heroTag: "graphicOptionsBtn",
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
    );
  }
}
