class Association {
  final int id;
  final int association_id;
  final String nom;
  final String numero_rna;
  final String numero_siren;
  final String page_web_url;
  final String description;
  final String email;
  final String telephone;
  Association(this.id,
              this.association_id,
              this.nom,
              this.numero_rna,
              this.numero_siren,
              this.page_web_url,
              this.description,
              this.email,
              this.telephone,
      );
  factory Association.fromJson(Map<String, dynamic> data) {
    return Association(
      data['id'],
      data['association_id'],
      data['nom'],
      data['numero_rna'],
      data['numero_siren'],
      data['page_web_url'],
      data['description'],
      data['email'],
      data['telephone'],
    );
  }
}

