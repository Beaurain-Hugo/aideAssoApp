import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import nécessaire
import 'package:aideAsso/menu/navigationBar.widget.dart';

class InscriptionPage extends StatefulWidget {
  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}
class _InscriptionPageState extends State<InscriptionPage> {
  // Déclaration des contrôleurs pour les champs de texte
  final TextEditingController txtNom = TextEditingController();
  final TextEditingController txtPrenom = TextEditingController();
  final TextEditingController txtDateNaissance = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  // Déclaration des FocusNode pour gérer le focus des champs
  final FocusNode focusNom = FocusNode();
  final FocusNode focusPrenom = FocusNode();
  final FocusNode focusDateNaissance = FocusNode();
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  // Méthode pour l'inscription
  Future<void> onInscrire(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (txtNom.text.isNotEmpty &&
        txtPrenom.text.isNotEmpty &&
        txtDateNaissance.text.isNotEmpty &&
        txtEmail.text.isNotEmpty &&
        txtPassword.text.isNotEmpty) {
      // Enregistrer les informations dans les préférences partagées
      prefs.setString("nom", txtNom.text);
      prefs.setString("prenom", txtPrenom.text);
      prefs.setString("date_naissance", txtDateNaissance.text);
      prefs.setString("email", txtEmail.text);
      prefs.setString("password", txtPassword.text);

      // Initialiser le booléen "connecte" à false
      prefs.setBool("connecte", false);

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inscription réussie! Bienvenue!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
      Navigator.pushNamed(context, '/authentification');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  void dispose() {
    // Libérer les FocusNode lorsque la page est fermée
    focusNom.dispose();
    focusPrenom.dispose();
    focusDateNaissance.dispose();
    focusEmail.dispose();
    focusPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        backgroundColor: Colors.blue, // Change la couleur de fond
        title: Text(
          'Page Inscription',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              // Champ pour le nom
              TextFormField(
                controller: txtNom,
                focusNode: focusNom, // Ajout du FocusNode
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Champ pour le prénom
              TextFormField(
                controller: txtPrenom,
                focusNode: focusPrenom, // Ajout du FocusNode
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outlined),
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Champ pour la date de naissance
              TextFormField(
                controller: txtDateNaissance,
                focusNode: focusDateNaissance, // Ajout du FocusNode
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'Date de naissance',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Champ pour l'email
              TextFormField(
                controller: txtEmail,
                focusNode: focusEmail, // Ajout du FocusNode
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Champ pour le mot de passe
              TextFormField(
                controller: txtPassword,
                obscureText: true,
                focusNode: focusPassword, // Ajout du FocusNode
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Bouton pour s'inscrire
              ElevatedButton(
                onPressed: () {
                  onInscrire(context);
                },
                child: Text('Créer un compte'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 16),
              // Bouton pour aller à la page d'authentification si déjà un compte
              TextButton(
                child: Text(
                  "J'ai déjà un compte",
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/authentification');
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 4), // Toujours 4 ici
    );
  }
}
