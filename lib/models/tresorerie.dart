class Tresorerie {
  final int id;
  final int association_id;
  final String nom_transaction;
  final double operation;
  final String date_operation;
  final String tiers;
  Tresorerie(this.id,
              this.association_id,
              this.nom_transaction,
              this.operation,
              this.date_operation,
              this.tiers,
  );
  factory Tresorerie.fromJson(Map<String, dynamic> data) {
    return Tresorerie(
      data['id'],
      data['association_id'],
      data['nom_transaction'],
      data['operation'],
      data['date_operation'],
      data['tiers']
    );
  }
}

