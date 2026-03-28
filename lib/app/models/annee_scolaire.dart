class AnneeScolaire {
  final int id;
  final String annee_scolaire;

  AnneeScolaire({required this.id, required this.annee_scolaire});

  factory AnneeScolaire.fromJson(Map<String, dynamic> json) {
    return AnneeScolaire(
      id: json['id'],
      annee_scolaire: json['annee_scolaire'],
    );
  }
}