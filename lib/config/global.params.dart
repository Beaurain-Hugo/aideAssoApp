import 'package:flutter/material.dart';
class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    { 'title': 'Accueil', 'icon': Icon (Icons.home, color: Colors.blue,), 'route': '/home' },
    { 'title': 'Bénévoles', 'icon': Icon (Icons.sunny, color: Colors.yellow,), 'route': '/benevole' },
    {'title': 'Information', 'icon': Icon (Icons.image, color: Colors.red,), 'route': '/information' },
    {'title': 'Trésorerie', 'icon': Icon (Icons.public, color: Colors.teal,), 'route': '/tresorerie'},

  ];

  /*static List<Map<String, dynamic>> accueil = [
    { 'title': 'Météo', 'image': Ink.image(height: 180,width: 180,image: AssetImage('assets/meteo.png'),), 'route': '/meteo' },
    {'title': 'Galerie', 'image': Ink.image(height: 180,width: 180,image: AssetImage('assets/galerie.png'),), 'route': '/galerie' },
    {'title': 'Pays', 'image': Ink.image(height: 180,width: 180,image: AssetImage('assets/pays.png'),), 'route': '/pays'},
    {'title': 'Contact', 'image': Ink.image(height: 180,width: 180,image: AssetImage('assets/contact.png'),), 'route': '/contact' },
    {'title': 'Paramètres', 'image': Ink.image(height: 180,width: 180,image: AssetImage('assets/parametres.png'),), 'route': '/parametres'},
    {'title': 'Déconnexion', 'image': Ink.image(height: 180,width: 180,image: AssetImage('assets/deconnexion.png'),), 'route': '/authentification' },
  ];*/
}