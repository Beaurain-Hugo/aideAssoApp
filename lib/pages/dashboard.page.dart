import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aideAsso/menu/drawer.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aideAsso/models/association.dart';

List<Association> parseAsso(String responseBody) {
  final Map<String, dynamic> jsonMap = json.decode(responseBody); // Décode en Map
  final List<dynamic> parsed = jsonMap["body"]; // Récupère la liste dans "body"
  return parsed.map<Association>((json) => Association.fromJson(json)).toList();
}

Future<List<Association>> fetchAsso() async {

  final response = await http.get(Uri.parse('http://localhost:3002/user/2/associations'));
  if (response.statusCode == 200) {
    return parseAsso(response.body);
  } else {
    throw Exception("Impossible de récupérer les associations");
  }
}

class DashboardPage extends StatelessWidget {
  DashboardPage({Key?key}) : super(key: key);

  late SharedPreferences prefs;
  @override
Widget build(BuildContext context){
  return page(associations: fetchAsso());
  }
}
class page extends StatelessWidget {
  final Future<List<Association>> associations;
  page({Key? key,required this.associations}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: Text("Page Tableau de bord",style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue, // Change la couleur de fond
        actions: [
        ],
      ),
        body: Center(
          child: FutureBuilder<List<Association>>(
            future: associations,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData ? testList(items: snapshot.data!) : Center(child:CircularProgressIndicator());
            },
          ),
        )
    );
  }

}

class testList extends StatelessWidget {
  final List<Association> items;
  testList({Key?key, required this.items});
  @override
  Widget build(BuildContext context){
    return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        child: test2(item: items[index]),
      );
    },
    );

  }
}

class test2 extends StatelessWidget {
  test2({Key? key, required this.item}) : super(key: key);
  final Association item;

  Widget build(BuildContext context)
  {
    return Container(
        padding: EdgeInsets.all(2),
        height: 140,
        child: Card(
          child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: <Widget>[Text(this.item.nom,
                                style: TextStyle(fontWeight:
                                FontWeight.bold)),
                            Text(this.item.description)],

                        )),);
  }
}

