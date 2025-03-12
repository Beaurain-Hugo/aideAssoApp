import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import pour SharedPreferences

class AuthentificationPage extends StatefulWidget {
  @override
  _AuthentificationPageState createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  // Déclaration des contrôleurs pour les champs de texte
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  // Méthode pour l'authentification
  Future<void> _onAuthentifier(BuildContext context) async {
    // Récupérer l'instance des préférences partagées
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Récupérer les informations enregistrées dans les préférences
    String storedEmail = prefs.getString("email") ?? '';
    String storedPassword = prefs.getString("password") ?? '';

    // Comparer les valeurs saisies avec celles stockées
    if (txtEmail.text == storedEmail && txtPassword.text == storedPassword) {
      // Mettre "connecte" à true
      await prefs.setBool("connecte", true);

      // Naviguer vers la page d'accueil
      Navigator.pushNamed(context, '/home');
    } else {
      // Si les informations sont incorrectes, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Identifiants incorrects')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: Text("Authentification",style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue, // Change la couleur de fond
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              // Champ pour l'email
              TextFormField(
                controller: txtEmail,
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
                obscureText: true, // Masquer le mot de passe
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Bouton de connexion
              ElevatedButton(
                onPressed: () {
                  _onAuthentifier(context); // Appeler la méthode d'authentification
                },
                child: Text('Connexion'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 16),
              // Bouton pour aller à la page d'inscription
              ElevatedButton(
                child: Text(
                  "Je n'ai pas de compte",
                  style: TextStyle(fontSize: 22),
                ),
                onPressed: () {
                  Navigator.pop(context); // Retourner à la page précédente
                  Navigator.pushNamed(context, '/inscription'); // Naviguer vers la page d'inscription
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
