import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:aideAsso/menu/navigationBar.widget.dart';


class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final _formKey = GlobalKey<FormState>();
  String? logoBase64;
  String nom = '';
  String sigle = '';
  String numeroRNA = '';
  String numeroSIREN = '';
  String pageWeb = '';
  String telephone = '';
  String email = '';
  String adresse = '';
  String description = '';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        logoBase64 = base64Encode(bytes);
      });
    }
  }

  void _saveInformation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Enregistrement : Nom: $nom, Sigle: $sigle, RNA: $numeroRNA, SIREN: $numeroSIREN, Page: $pageWeb, Téléphone: $telephone, Email: $email, Adresse: $adresse, Description: $description');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour
        title: Text("Informations de l'association",style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue, // Change la couleur de fond
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                  children: [
                  if (logoBase64 != null)
              Image.memory(base64Decode(logoBase64!), height: 100),
      ElevatedButton(
        onPressed: _pickImage,
        child: Text('Choisir un logo'),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Nom de l association'),
            onSaved: (value) => nom = value ?? '',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Sigle'),
        onSaved: (value) => sigle = value ?? '',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Numéro RNA'),
        enabled: false,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Numéro SIREN'),
        enabled: false,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Page Web'),
        onSaved: (value) => pageWeb = value ?? '',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Téléphone'),
        keyboardType: TextInputType.phone,
        onSaved: (value) => telephone = value ?? '',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => email = value ?? '',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Adresse'),
        onSaved: (value) => adresse = value ?? '',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Objet de l association'),
          maxLines: 3,
          onSaved: (value) => description = value ?? '',
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveInformation,
          child: Text('Enregistrer'),
        ),
        ],
      ),
    ),
    ),
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: 2), // Toujours 2 ici
    );
  }
}