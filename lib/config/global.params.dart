import 'package:flutter/material.dart';

class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    { 'title': 'Accueil', 'icon': Icon(Icons.home, color: Colors.blue), 'route': '/home' },
    { 'title': 'Bénévoles', 'icon': Icon(Icons.sunny, color: Colors.yellow), 'route': '/benevole' },
    { 'title': 'Information', 'icon': Icon(Icons.image, color: Colors.red), 'route': '/information' },
    { 'title': 'Trésorerie', 'icon': Icon(Icons.public, color: Colors.teal), 'route': '/tresorerie' },
    { 'title': 'Inscription', 'icon': Icon(Icons.person, color: Colors.teal), 'route': '/inscription' },
  ];
}