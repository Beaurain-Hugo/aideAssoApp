import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aideAsso/pages/information.page.dart';
import 'package:aideAsso/pages/benevole.page.dart';
import 'package:aideAsso/pages/tresorerie.page.dart';
import 'package:aideAsso/pages/home.page.dart';
import 'package:aideAsso/pages/authentification.page.dart';
import 'package:aideAsso/pages/inscription.page.dart';
import 'package:aideAsso/pages/dashboard.page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aide Asso',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Écran d'attente
      routes: {
        '/dashboard': (context) => DashboardPage(),
        '/information': (context) => InformationPage(),
        '/benevole': (context) => BenevolePage(),
        '/tresorerie': (context) => TresoreriePage(),
        '/authentification ': (context) => AuthentificationPage(),
        '/inscription': (context) => InscriptionPage(),
      },
    );
  }
}

// SplashScreen pour charger l'état de connexion
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  Future<void> _checkConnectionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isConnected = prefs.getBool("connecte") ?? false;

    // Naviguer en fonction de l'état
    if (isConnected) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/authentification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Indicateur de chargement
      ),
    );
  }
}



