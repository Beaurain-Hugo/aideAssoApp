import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aideAsso/models/tresorerie.dart';  // Assure-toi que tu as bien importé le modèle Tresorerie
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aideAsso/menu/navigationBar.widget.dart';
import 'package:intl/intl.dart';  // Pour formater la date

List<Tresorerie> parseTresorerie(String responseBody) {
  final Map<String, dynamic> jsonMap = json.decode(responseBody); // Décode en Map
  final List<dynamic> parsed = jsonMap["body"]; // Récupère la liste dans "body"
  return parsed.map<Tresorerie>((json) => Tresorerie.fromJson(json)).toList();
}

Future<List<Tresorerie>> fetchAsso() async {
  final response = await http.get(Uri.parse('http://localhost:3002/association/1/tresorerie'));
  if (response.statusCode == 200) {
    return parseTresorerie(response.body);
  } else {
    throw Exception("Impossible de récupérer les opérations");
  }
}



class TresoreriePage extends StatefulWidget {
  @override
  _TresoreriePageState createState() => _TresoreriePageState(transactions: fetchAsso());
}

class _TresoreriePageState extends State<TresoreriePage> {
  final Future<List<Tresorerie>> transactions;

  _TresoreriePageState({required this.transactions});

  bool isLoading = true;
  double totalCredit = 0;
  double totalDebit = 0;
  double netBalance = 0;

  TextEditingController nomController = TextEditingController();
  TextEditingController operationController = TextEditingController();
  TextEditingController tiersController = TextEditingController();
  DateTime? selectedDate;
  Future<void> sendTresorerie() async {
    // L'URL de l'API
    final url = Uri.parse('http://localhost:3002/tresorerie/add');
  print(selectedDate);
    // Les données à envoyer
    final Map<String, dynamic> data = {
      'nom_transaction': nomController.text,
      'association_id': 1,
      'operation': operationController.text,
      'tiers': tiersController.text,
      'date_operation': selectedDate.toString()
    };

    try {
      // Faire la requête POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Type du contenu envoyé
          'Accept': 'application/json', // (optionnel) Si tu veux du JSON en retour
        },
        body: jsonEncode(data), // Encodage JSON des données
      );

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        print('Succès : ${response.body}');
      } else {
        print('Erreur ${response.statusCode} : ${response.body}');
      }
    } catch (e) {
      print('Erreur réseau : $e');
    }
  }

  @override
  void initState() {
    super.initState();
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
            ElevatedButton(onPressed: sendTresorerie, child: Text("Ajouter")),
          ],
        );
      },
    );
  }
  void addTransaction() {
    if (nomController.text.isNotEmpty && operationController.text.isNotEmpty && selectedDate != null) {
      setState(() {
      /*  transactions.add({
          "nom_transaction": nomController.text,
          "operation": double.parse(operationController.text),
          "date_operation": selectedDate!,
          "tiers": tiersController.text,
        });
        totalCredit = transactions.where((t) => t["operation"] > 0).fold(0, (sum, t) => sum + t["operation"]);
        totalDebit = transactions.where((t) => t["operation"] < 0).fold(0, (sum, t) => sum + t["operation"].abs());
        netBalance = totalCredit - totalDebit; */
      });

      Navigator.pop(context);
    }
  }

  List<MapEntry<DateTime, double>> groupAndSumTransactionsForChart(List<Tresorerie> transactions) {
  // Utilise un map pour regrouper les transactions par date
  Map<DateTime, double> transactionMap = {};

  for (var t in transactions) {
  DateTime date = DateTime.parse(t.date_operation);
  if (transactionMap.containsKey(date)) {
  transactionMap[date] = transactionMap[date]! + t.operation;
  } else {
  transactionMap[date] = t.operation;
  }
  }
  for (var transaction in transactions) {
    if(transaction.operation > 0){
      totalCredit += transaction.operation;
      print("Crédit ${totalCredit}");
    } else {
      totalDebit += transaction.operation;
      print("Débit ${totalDebit}");
    }
    netBalance = totalCredit + totalDebit;
  }

  // Convertir le map en une liste d'entrées (pour un tri par date croissante)
  List<MapEntry<DateTime, double>> sortedTransactions = transactionMap.entries.toList()
  ..sort((a, b) => a.key.compareTo(b.key)); // Trie par date croissante

  // ✅ Calcul du cumul des montants
  double cumulativeSum = 0;
  List<MapEntry<DateTime, double>> cumulativeTransactions = [];

  for (var entry in sortedTransactions) {
  cumulativeSum += entry.value; // Ajoute chaque montant au cumul
  cumulativeTransactions.add(MapEntry(entry.key, cumulativeSum)); // Associe la date à la somme cumulée
  }

  return cumulativeTransactions;
  }


  // Fonction pour construire le graphique
  Widget buildChart(List<MapEntry<DateTime, double>> groupedTransactions) {
    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: groupedTransactions
                  .map((entry) {
                return FlSpot(
                  entry.key.millisecondsSinceEpoch.toDouble(),
                  entry.value.toDouble(),
                );
              }).toList(),
              isCurved: false,
              color: Colors.blue,
              barWidth: 4,
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameSize: 16,
              axisNameWidget: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  String formattedDate = DateFormat('dd/MM/yyyy').format(date);
                  return Transform.rotate(
                    angle: -0.8, // Rotation de 45 degrés (en radians)
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Transform.translate(
                        offset: const Offset(-20.0, 0.0),
                      child: Text(
                          formattedDate,
                          style: TextStyle(fontSize: 10)
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 16,
              axisNameWidget: Text('Montant', style: TextStyle(fontWeight: FontWeight.bold)),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0), // Montant arrondi sans virgule
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),

            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Masquer les titres sur l'axe droit
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Masquer les titres sur l'axe supérieur
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Trésorerie", style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Cartes récapitulatives
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               // _buildSummaryCard(Icons.calendar_today, "Total Transactions", "${parseTresorerie.lenght}", color: Colors.blue),
                _buildSummaryCard(Icons.account_balance_wallet, "Total Crédit", "$totalCredit €", color: Colors.green),
                _buildSummaryCard(Icons.remove_circle, "Total Débit", "$totalDebit €", color: Colors.red),
                _buildSummaryCard(Icons.attach_money, "Somme Totale", "$netBalance €", color: Colors.orange),
              ],
            )),
            SizedBox(height: 20),
            // Graphique
            FutureBuilder<List<Tresorerie>>(
              future: transactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Aucune donnée disponible"));
                } else {
                  List<MapEntry<DateTime, double>> groupedTransactionsForChart = groupAndSumTransactionsForChart(snapshot.data!);
                  return buildChart(groupedTransactionsForChart); // Passe les transactions regroupées pour le graphique
                }
              },
            ),
            SizedBox(height: 20),
            // Tableau des transactions
            Expanded(
              child: FutureBuilder<List<Tresorerie>>(
                future: transactions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur : ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Aucune donnée disponible"));
                  } else {
                    List<Tresorerie> allTransactions = snapshot.data!;
                    // Transactions sans regroupement
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text("Nom")),
                          DataColumn(label: Text("Montant")),
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Tiers")),
                        ],
                        rows: allTransactions.map((t) {
                          // Conversion de la date en string au format DateTime
                          DateTime date = DateTime.parse(t.date_operation);
                          return DataRow(cells: [
                            DataCell(Text(t.nom_transaction)),
                            DataCell(Text("${t.operation.toString()} €")),
                            DataCell(Text("${DateFormat('dd/MM/yyyy').format(date)}")),
                            DataCell(Text(t.tiers)),
                          ]);
                        }).toList(),
                      ),
                      )
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionDialog();
        }, // Ajoute l'action pour ajouter une transaction
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
