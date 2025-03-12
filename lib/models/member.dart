import 'dart:convert';

class Member {
  final int id;
  final int association_id;
  final String nom;
  final String prenom;
  final String role;
  final String username;
  final int user_id;
  final String email;
  Member(this.id,
              this.association_id,
              this.nom,
              this.prenom,
              this.role,
              this.username,
              this.user_id,
              this.email,
      );

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }

  // Ajouter une méthode toJson pour convertir l'objet en un objet JSON
  Map<String, dynamic> toJson() {
    return {

      'user_id': user_id,

    };
  }

  factory Member.fromJson(Map<String, dynamic> data) {
    return Member(
      data['id'],
      data['association_id'],
      data['nom'],
      data['prenom'],
      data['role'],
      data['username'],
      data['user_id'],
      data['email']
    );
  }
}



