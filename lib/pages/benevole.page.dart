import 'package:flutter/material.dart';
import 'package:aideAsso/menu/navigationBar.widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aideAsso/models/member.dart';

List<Member> parseMember(String responseBody) {
  final Map<String, dynamic> jsonMap = json.decode(responseBody); // Décode en Map
  final List<dynamic> parsed = jsonMap["body"]; // Récupère la liste dans "body"
  return parsed.map<Member>((json) => Member.fromJson(json)).toList();
}

Future<List<Member>> fetchAsso() async {

  final response = await http.get(Uri.parse('http://localhost:3002/association/1/membres'));
  if (response.statusCode == 200) {
    return parseMember(response.body);
  } else {
    throw Exception("Impossible de récupérer les bénévoles");
  }
}

List<Member> selectedMembers = [];


class BenevolePage extends StatefulWidget {
  BenevolePage({Key?key}) : super(key: key);

  @override
  _BenevolePage createState() => _BenevolePage(members: fetchAsso());

  /*Widget build(BuildContext context){
    return _BenevolePage(members: fetchAsso());
  }*/
}
class _BenevolePage extends State<BenevolePage> {
  final Future<List<Member>> members;
  _BenevolePage({required this.members});

  List<Member> selectedMembers = []; // Gère la sélection ici
  TextEditingController nomController = TextEditingController();
  TextEditingController operationController = TextEditingController();
  TextEditingController tiersController = TextEditingController();
  DateTime? selectedDate;

  Future<void> deleteMember() async {
    // L'URL de l'API
    final url = Uri.parse('http://localhost:3002/tresorerie/add');
    // Les données à envoyer
    final Map<String, dynamic> data = {
      'deletedMembers': selectedMembers
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Gérer les bénévoles", style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Nouveau"),
                  onPressed: () => _openNewMembreDialog(context),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text("Supprimer"),
                  onPressed: selectedMembers.isNotEmpty ? _confirmDeleteSelected : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Member>>(
              future: members,
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData ? testList(
                  items: snapshot.data!,
                  onSelectionChanged: _handleSelectionChanged, // Passer la fonction de gestion de sélection
                ) : Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 1),
    );
  }
  void _openNewMembreDialog(BuildContext context) {
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
           // ElevatedButton(onPressed: null, child: Text("Ajouter")),
          ],
        );
      },
    );
  }


  void _handleSelectionChanged(Member member, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedMembers.add(member);
        print(selectedMembers);// Ajoute le membre à la sélection
      } else {
        selectedMembers.remove(member); // Retire le membre de la sélection
      }
    });
  }

  void _confirmDeleteSelected() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Êtes-vous sûr de vouloir supprimer les membres sélectionnés ?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Non")),
            ElevatedButton(onPressed: () {
              deleteMember();
              setState(() {
                // Supprimer les membres de la liste ici
                selectedMembers.clear();
              });
              Navigator.pop(context);
            }, child: Text("Oui")),
          ],
        );
      },
    );
  }
}



class testList extends StatelessWidget {
  final List<Member> items;
  final Function(Member, bool) onSelectionChanged; // Fonction pour gérer la sélection

  testList({Key? key, required this.items, required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: test2(
            item: items[index],
            onSelectionChanged: onSelectionChanged, // Passer la fonction ici
          ),
        );
      },
    );
  }
}

class test2 extends StatefulWidget {
  final Member item;
  final Function(Member, bool) onSelectionChanged; // Fonction pour informer le parent

  test2({Key? key, required this.item, required this.onSelectionChanged}) : super(key: key);

  @override
  _test2State createState() => _test2State();
}

class _test2State extends State<test2> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 140,
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: isSelected,
            onChanged: (bool? selected) {
              setState(() {
                isSelected = selected ?? false; // Met à jour l'état local
                widget.onSelectionChanged(widget.item, isSelected); // Informe le parent
              });
            },
          ),
          title: Text(
            "${widget.item.prenom} ${widget.item.nom} - ${widget.item.username}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${widget.item.role} - ${widget.item.email}",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}


/*class _BenevolePageState extends State<BenevolePage> {
  /*List<Map<String, dynamic>> membres = [
    {'id': 1, 'username': 'jdoe', 'prenom': 'John', 'nom': 'Doe', 'role': 'Bénévole', 'email': 'jdoe@example.com', 'dateAdhesion': '10/04/2024', 'estActif': true},
    {'id': 2, 'username': 'asmith', 'prenom': 'Alice', 'nom': 'Smith', 'role': 'Président', 'email': 'asmith@example.com', 'dateAdhesion': '05/06/2023', 'estActif': false},
  ];*/
  final Future<List<Member>> members;
  _BenevolePageState({Key? key, required this.members}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: Text("Gérer les bénévoles",style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue, // Change la couleur de fond
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Nouveau"),
                  onPressed: () => _openNewMembreDialog(context),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text("Supprimer"),
                  onPressed: selectedMembres.isNotEmpty ? _confirmDeleteSelected : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Member>>(
              future: members,
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData ? testList(items: snapshot.data!) : Center(child:CircularProgressIndicator());
              },
            ),


            /*ListView.builder(
              itemCount: membres.length,
              itemBuilder: (context, index) {
                final membre = membres[index];
                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: selectedMembres.contains(membre),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            selectedMembres.add(membre);
                          } else {
                            selectedMembres.remove(membre);
                          }
                        });
                      },
                    ),
                    title: Text("${membre['prenom']} ${membre['nom']}", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${membre['role']} - ${membre['email']} - Adhésion: ${membre['dateAdhesion']}", style: TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editMembreDialog(context, membre),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteMembre(membre),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ), */
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 1), // Toujours 1 ici

    );
  }

  void _openNewMembreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter un membre"),
          content: Text("Formulaire d'ajout ici..."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
            ElevatedButton(onPressed: () {}, child: Text("Enregistrer")),
          ],
        );
      },
    );
  }

  void _editMembreDialog(BuildContext context, Map<String, dynamic> membre) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier ${membre['prenom']} ${membre['nom']}"),
          content: Text("Formulaire de modification ici..."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
            ElevatedButton(onPressed: () {}, child: Text("Enregistrer")),
          ],
        );
      },
    );
  }

  void _confirmDeleteMembre(Map<String, dynamic> membre) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Êtes-vous sûr de vouloir supprimer ${membre['prenom']} ${membre['nom']} ?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Non")),
            ElevatedButton(onPressed: () {
              setState(() {
                /*members.remove(membre);*/
              });
              Navigator.pop(context);
            }, child: Text("Oui")),
          ],
        );
      },
    );
  }

  void _confirmDeleteSelected() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Êtes-vous sûr de vouloir supprimer les membres sélectionnés ?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Non")),
            ElevatedButton(onPressed: () {
              setState(() {
              /*  members.removeWhere((membre) => selectedMembres.contains(membre));
                selectedMembres.clear(); */
              });
              Navigator.pop(context);
            }, child: Text("Oui")),
          ],
        );
      },
    );
  }
} */

