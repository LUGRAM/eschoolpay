import 'package:intl/intl.dart';

class ChildModel {
  final String? id;

  // API: nom / prenom
  final String firstName;
  final String lastName;

  /// UI: dd/MM/yyyy
  final String birthDate;
  final String birthPlace;

  /// requis par swagger: sexe (string)
  /// (ex: "M" / "F")
  final String sexe;

  /// requis par swagger: matricule (string)
  /// si ton backend accepte auto, tu peux le générer côté app (voir helper)
  final String matricule;

  /// optionnel: chemin local fichier photo (pour multipart)
  final String? photoPath;

  /// champ requis par swagger: parent_model_id (int)
  final int parentId;

  /// champs additionnels optionnels (classe_id, ecole_id, etc.)
  final Map<String, String> extras;

  const ChildModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.birthPlace,
    required this.sexe,
    required this.matricule,
    required this.parentId,
    this.photoPath,
    this.extras = const {},
  });

  String get fullName => "$firstName $lastName";

  // -----------------------------
  // API -> Model
  // -----------------------------
  factory ChildModel.fromApi(Map<String, dynamic> json) {
    // date_naissance peut être "2025-10-01" ou ISO "2025-10-01T00:00:00.000000Z"
    final apiDate = (json['date_naissance'] ?? '').toString();
    final uiDate = _toUiDate(apiDate);

    return ChildModel(
      id: (json['id'] ?? '').toString(),
      firstName: (json['prenom'] ?? '').toString(),
      lastName: (json['nom'] ?? '').toString(),
      birthDate: uiDate,
      birthPlace: (json['lieu_naissance'] ?? '').toString(),
      sexe: (json['sexe'] ?? 'M').toString(),
      matricule: (json['matricule'] ?? '').toString(),
      parentId: int.tryParse(( json['parent_model_id'] ?? 0).toString()) ?? 0,
      // photoUrl côté API (si tu veux l’afficher) -> à gérer séparément si besoin
    );
  }

  // -----------------------------
  // Model -> multipart fields
  // -----------------------------
  Map<String, String> toMultipartFields() {
    return {
      "matricule": matricule,
      "nom": lastName,
      "prenom": firstName,
      "date_naissance": _toApiDate(birthDate), // yyyy-MM-dd
      "lieu_naissance": birthPlace,
      "sexe": sexe,
      "parent_model_id": parentId.toString(),
      ...extras,
    };
  }

  ChildModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? birthPlace,
    String? sexe,
    String? matricule,
    int? parentId,
    String? photoPath,
    Map<String, String>? extras,
  }) {
    return ChildModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      sexe: sexe ?? this.sexe,
      matricule: matricule ?? this.matricule,
      parentId: parentId ?? this.parentId,
      photoPath: photoPath ?? this.photoPath,
      extras: extras ?? this.extras,
    );
  }

  // -----------------------------
  // Helpers dates
  // -----------------------------
  static String _toUiDate(String apiDate) {
    if (apiDate.isEmpty) return "";
    try {
      final dt = DateTime.parse(apiDate);
      return DateFormat("dd/MM/yyyy").format(dt);
    } catch (_) {
      // si déjà dd/MM/yyyy
      return apiDate;
    }
  }

  static String _toApiDate(String uiDate) {
    if (uiDate.isEmpty) return "";
    try {
      final dt = DateFormat("dd/MM/yyyy").parse(uiDate);
      return DateFormat("yyyy-MM-dd").format(dt);
    } catch (_) {
      // si déjà yyyy-MM-dd
      return uiDate;
    }
  }

  // -----------------------------
  // Helper matricule (si besoin)
  // -----------------------------
  static String generateMatricule() {
    final now = DateTime.now();
    return "MAT-${now.year}${now.month.toString().padLeft(2, '0')}${now.millisecond}";
  }

  // ----------------------------
  // Helper date
  // ----------------------------
  bool get isAlreadyRegisteredThisYear =>
      academicYear == currentAcademicYear;

  static String get currentAcademicYear {
    final now = DateTime.now();
    final startYear = now.month >= 9 ? now.year : now.year - 1;
    return "$startYear-${startYear + 1}";
  }


  // Ces getters garantissent un String non-nul pour tes widgets
  String get displaySchool => schoolName ?? "Non renseignée";
  String get displayGrade => grade ?? "Classe non renseignée";

}

extension ChildExtras on ChildModel {
  String? get schoolId => extras["school_id"];
  String? get grade => extras["grade"];
  String? get academicYear => extras["academic_year"];
  String? get schoolName => extras["school_name"];
}

