import 'package:flutter/material.dart';
import 'package:aideAsso/menu/drawer.widget.dart';

//import 'package:shared_preferences/shared_preferences.dart'; // Import pour SharedPreferences

class TresoreriePage extends StatelessWidget {
  // Méthode pour gérer la déconnexion
  /* Future<void> _deconnexion(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mettre "connecte" à false au lieu de tout effacer
    prefs.setBool("connecte", false);

    Navigator.pushNamedAndRemoveUntil(context, '/authentification', (route) => false);
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          'Page Tresorerie',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          /*IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _deconnexion(context); // Appeler la méthode de déconnexion
            },
          ),*/
        ],
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la page Tresorerie',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}