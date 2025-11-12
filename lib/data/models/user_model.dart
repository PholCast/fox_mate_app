import 'package:fox_mate_app/domain/entities/user_entity.dart';

class UserModel extends UserEntity {

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.age = 0,
    super.career = '',
    super.semester = 0,
    super.imageUrl,
    super.interests = const [],
    super.bio = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      career: json['career'] ?? '',
      semester: json['semester'] ?? 0,
      imageUrl: json['imageUrl'],
      interests: List<String>.from(json['interests'] ?? []),
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'career': career,
      'semester': semester,
      'imageUrl': imageUrl,
      'interests': interests,
      'bio': bio,
    };
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      age: user.age,
      career: user.career,
      semester: user.semester,
      imageUrl: user.imageUrl,
      interests: user.interests,
      bio: user.bio,
    );
  }
}