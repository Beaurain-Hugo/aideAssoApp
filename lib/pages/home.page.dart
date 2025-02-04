import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import pour SharedPreferences
import 'package:aideAsso/menu/drawer.widget.dart';
import 'package:aideAsso/config/global.params.dart';

class HomePage extends StatelessWidget {
  // Méthode pour gérer la déconnexion
  Future<void> _deconnexion(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Mettre "connecte" à false au lieu de tout effacer
    prefs.setBool("connecte", false);

    Navigator.pushNamedAndRemoveUntil(context, '/authentification', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Center(
          child: Image.asset(
              "Logo_aide_asso.png",
              width:200
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _deconnexion(context); // Appeler la méthode de déconnexion
            },
          ),
        ],
      ),
      body: Text("test"),
      );
  }
}



