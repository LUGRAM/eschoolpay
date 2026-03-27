// features/children/models/child_model.dart

import 'package:intl/intl.dart';

class ChildModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String birthPlace;
  final String sexe;
  final String matricule;

  /// Chemin local après crop (avant upload)
  final String? photoPath;

  /// URL distante retournée par l'API après upload
  final String? photoUrl;

  final int parentId;
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
    this.photoUrl,
    this.extras = const {},
  });

  String get fullName => "$firstName $lastName";

  // ─── API → Model ─────────────────────────────────────────────
  factory ChildModel.fromApi(Map<String, dynamic> json) {
    final apiDate = (json['date_naissance'] ?? '').toString();
    final uiDate = _toUiDate(apiDate);

    // L'API retourne "photo" qui peut être null ou une URL complète
    const _baseStorageUrl = 'https://eschool.itmaster-africa.com/storage/';

    final rawPhoto = json['photo']?.toString();
    final photoUrl = (rawPhoto != null && rawPhoto.isNotEmpty)
        ? (rawPhoto.startsWith('http') ? rawPhoto : '$_baseStorageUrl$rawPhoto')
        : null;

    return ChildModel(
      id: (json['id'] ?? '').toString(),
      firstName: (json['prenom'] ?? '').toString(),
      lastName: (json['nom'] ?? '').toString(),
      birthDate: uiDate,
      birthPlace: (json['lieu_naissance'] ?? '').toString(),
      sexe: (json['sexe'] ?? 'M').toString(),
      matricule: (json['matricule'] ?? '').toString(),
      parentId: int.tryParse(
          (json['parent_model_id'] ??
              json['parentProfile']?['id'] ??
              0)
              .toString()) ??
          0,
      photoUrl: photoUrl,
      extras: {
        "school_id": (json['school_id'] ?? '').toString(),
        "grade": (json['grade'] ?? '').toString(),
        "academic_year": (json['academic_year'] ?? '').toString(),
        "school_name": (json['school_name'] ?? '').toString(),
        "niveau_id": (json['niveau_id'] ?? '').toString(),
      },
    );
  }

  // ─── Model → multipart fields ─────────────────────────────────
  Map<String, String> toMultipartFields() {
    return {
      "matricule": matricule,
      "nom": lastName,
      "prenom": firstName,
      "date_naissance": _toApiDate(birthDate),
      "lieu_naissance": birthPlace,
      "sexe": sexe,
      "parent_model_id": parentId.toString(),
      ...extras,
    };
  }

  // ─── copyWith ─────────────────────────────────────────────────
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
    String? photoUrl,
    bool clearPhotoPath = false,
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
      photoPath: clearPhotoPath ? null : (photoPath ?? this.photoPath),
      photoUrl: photoUrl ?? this.photoUrl,
      extras: extras ?? this.extras,
    );
  }

  // ─── Helpers dates ────────────────────────────────────────────
  static String _toUiDate(String apiDate) {
    if (apiDate.isEmpty) return "";
    try {
      final dt = DateTime.parse(apiDate);
      return DateFormat("dd/MM/yyyy").format(dt);
    } catch (_) {
      return apiDate;
    }
  }

  static String _toApiDate(String uiDate) {
    if (uiDate.isEmpty) return "";
    try {
      final dt = DateFormat("dd/MM/yyyy").parse(uiDate);
      return DateFormat("yyyy-MM-dd").format(dt);
    } catch (_) {
      return uiDate;
    }
  }

  static String generateMatricule() {
    final now = DateTime.now();
    return "MAT-${now.year}${now.month.toString().padLeft(2, '0')}${now.millisecond}";
  }

  bool get isAlreadyRegisteredThisYear =>
      academicYear == currentAcademicYear;

  static String get currentAcademicYear {
    final now = DateTime.now();
    final startYear = now.month >= 9 ? now.year : now.year - 1;
    return "$startYear-${startYear + 1}";
  }

  String get displaySchool => schoolName ?? "Non renseignée";

  String get displayGrade {
    final g = grade;
    if (g == null || g.isEmpty) return "";
    return g;
  }
}

extension ChildExtras on ChildModel {
  String? get schoolId => extras["school_id"];
  String? get grade => extras["grade"];
  String? get academicYear => extras["academic_year"];
  String? get schoolName => extras["school_name"];
}