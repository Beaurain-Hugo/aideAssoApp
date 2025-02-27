import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import pour SharedPreferences
import 'package:aideAsso/menu/drawer.widget.dart';
import 'package:aideAsso/config/global.params.dart';
import 'package:flutter/material.dart';
import 'package:aideAsso/menu/navigationBar.widget.dart';
import 'package:aideAsso/config/global.params.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: Text("Accueil",style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue, // Change la couleur de fond
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            FeaturesSection(),
            CallToActionSection(),
            ContactSection(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 0), // Toujours 0 ici
    );
  }
}

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Aide Asso - Gérez facilement votre association",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Avec Aide Asso, simplifiez la gestion de votre association : membres, trésorerie, démarches administratives, et bien plus encore.",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text("En savoir plus"),
          ),
          SizedBox(height: 20),
          Image.asset("images/Partnership-bro.png"),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Pourquoi choisir Aide Asso ?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        FeatureCard(
          title: "Gestion d'associations",
          description:
          "Ajoutez et gérez facilement votre association, y compris son RNA, SIREN, statuts, et règlement.",
          image: "images/Design-team-amico.png",
        ),
        FeatureCard(
          title: "Gestion des membres",
          description:
          "Suivez les adhésions et gérez efficacement vos membres avec un tableau de bord simple et intuitif.",
          image: "images/Team-goals-pana.png",
        ),
        FeatureCard(
          title: "Trésorerie simplifiée",
          description:
          "Gérez les finances de votre association, avec des rapports détaillés sur les entrées et sorties.",
          image: "images/Investment-data-bro.png",
        ),
        FeatureCard(
          title: "Démarches administratives",
          description:
          "Réalisez facilement vos démarches administratives en ligne, telles que la création d'associations ou la gestion d'AG.",
          image: "images/Admin-bro.png",
        ),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  FeatureCard({required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Image.asset(image),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(description, textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallToActionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.blue,
      child: Column(
        children: [
          Text(
            "Prêt à simplifier la gestion de votre association ?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text("Inscrivez-vous gratuitement"),
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Text("Contactez-nous", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          TextField(decoration: InputDecoration(labelText: "Nom")),
          TextField(decoration: InputDecoration(labelText: "Email")),
          TextField(
            decoration: InputDecoration(labelText: "Message"),
            maxLines: 4,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text("Envoyer"),
          ),
        ],
      ),
    );
  }
}



