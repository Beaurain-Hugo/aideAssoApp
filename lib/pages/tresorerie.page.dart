import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aideAsso/menu/navigationBar.widget.dart';

class TresoreriePage extends StatefulWidget {
  @override
  _TresoreriePageState createState() => _TresoreriePageState();
}

class _TresoreriePageState extends State<TresoreriePage> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  double totalCredit = 0;
  double totalDebit = 0;
  double netBalance = 0;

  TextEditingController nomController = TextEditingController();
  TextEditingController operationController = TextEditingController();
  TextEditingController tiersController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    await Future.delayed(Duration(seconds: 2)); // Simulation API
    setState(() {
      transactions = [
        {"nom_transaction": "Vente", "operation": 500, "date_operation": DateTime.now(), "tiers": "Client A"},
        {"nom_transaction": "Achat Matériel", "operation": -200, "date_operation": DateTime.now(), "tiers": "Fournisseur B"},
      ];
      totalCredit = transactions.where((t) => t["operation"] > 0).fold(0, (sum, t) => sum + t["operation"]);
      totalDebit = transactions.where((t) => t["operation"] < 0).fold(0, (sum, t) => sum + t["operation"].abs());
      netBalance = totalCredit - totalDebit;
      isLoading = false;
    });
  }

  void addTransaction() {
    if (nomController.text.isNotEmpty && operationController.text.isNotEmpty && selectedDate != null) {
      setState(() {
        transactions.add({
          "nom_transaction": nomController.text,
          "operation": double.parse(operationController.text),
          "date_operation": selectedDate!,
          "tiers": tiersController.text,
        });
        totalCredit = transactions.where((t) => t["operation"] > 0).fold(0, (sum, t) => sum + t["operation"]);
        totalDebit = transactions.where((t) => t["operation"] < 0).fold(0, (sum, t) => sum + t["operation"].abs());
        netBalance = totalCredit - totalDebit;
      });

      Navigator.pop(context);
    }
  }

  void showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter une transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomController, decoration: InputDecoration(labelText: "Nom de la transaction")),
              TextField(controller: operationController, decoration: InputDecoration(labelText: "Montant"), keyboardType: TextInputType.number),
              TextField(controller: tiersController, decoration: InputDecoration(labelText: "Tiers")),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (picked != null) setState(() => selectedDate = picked);
                },
                child: Text(selectedDate == null ? "Sélectionner une date" : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
            ElevatedButton(onPressed: addTransaction, child: Text("Ajouter")),
          ],
        );
      },
    );
  }

  Widget buildChart() {
    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: transactions.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value["operation"].toDouble())).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData: BarAreaData(show: true, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: Text("Trésorerie",style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue, // Change la couleur de fond
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Cartes récapitulatives
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard(Icons.calendar_today, "Total Transactions", transactions.length.toString()),
                _buildSummaryCard(Icons.account_balance_wallet, "Total Crédit", "$totalCredit €", color: Colors.green),
                _buildSummaryCard(Icons.remove_circle, "Total Débit", "$totalDebit €", color: Colors.red),
                _buildSummaryCard(Icons.attach_money, "Somme Totale", "$netBalance €", color: Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            // Graphique
            buildChart(),
            SizedBox(height: 20),
            // Tableau des transactions
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Nom")),
                    DataColumn(label: Text("Montant")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Tiers")),
                  ],
                  rows: transactions
                      .map(
                        (t) => DataRow(cells: [
                      DataCell(Text(t["nom_transaction"])),
                      DataCell(Text("${t["operation"]} €")),
                      DataCell(Text("${t["date_operation"].day}/${t["date_operation"].month}/${t["date_operation"].year}")),
                      DataCell(Text(t["tiers"])),
                    ]),
                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTransactionDialog,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 3), // Toujours 3 ici

    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value, {Color color = Colors.blue}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
