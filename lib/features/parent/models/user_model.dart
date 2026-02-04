// lib/app/data/models/user_model.dart
class UserModel {
  String id;
  String name;
  String email;
  String? phone;
  String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
  });
}