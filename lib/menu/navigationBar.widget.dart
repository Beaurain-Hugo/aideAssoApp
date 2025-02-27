import 'package:flutter/material.dart';
import 'package:aideAsso/config/global.params.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  MyBottomNavigationBar({required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    String route = GlobalParams.menus[index]['route'];
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: GlobalParams.menus[currentIndex]['icon'].color, // Couleur du texte sélectionné
      unselectedItemColor: Colors.grey, // Couleur des icônes non sélectionnées
      type: BottomNavigationBarType.fixed, // Évite l'effet de zoom sur les icônes
      items: GlobalParams.menus.asMap().entries.map((entry) {
        int index = entry.key;
        var item = entry.value;

        return BottomNavigationBarItem(
          icon: item['icon'],
          label: item['title'],
        );
      }).toList(),
    );
  }
}
