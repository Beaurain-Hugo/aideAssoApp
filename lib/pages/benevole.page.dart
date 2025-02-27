import 'package:flutter/material.dart';
import 'package:aideAsso/menu/navigationBar.widget.dart';

class BenevolePage extends StatefulWidget {
  @override
  _BenevolePageState createState() => _BenevolePageState();
}

class _BenevolePageState extends State<BenevolePage> {
  List<Map<String, dynamic>> membres = [
    {'id': 1, 'username': 'jdoe', 'prenom': 'John', 'nom': 'Doe', 'role': 'Bénévole', 'email': 'jdoe@example.com', 'dateAdhesion': '10/04/2024', 'estActif': true},
    {'id': 2, 'username': 'asmith', 'prenom': 'Alice', 'nom': 'Smith', 'role': 'Président', 'email': 'asmith@example.com', 'dateAdhesion': '05/06/2023', 'estActif': false},
  ];

  List<Map<String, dynamic>> selectedMembres = [];

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
            child: ListView.builder(
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
            ),
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
                membres.remove(membre);
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
                membres.removeWhere((membre) => selectedMembres.contains(membre));
                selectedMembres.clear();
              });
              Navigator.pop(context);
            }, child: Text("Oui")),
          ],
        );
      },
    );
  }
}
