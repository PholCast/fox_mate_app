//Equatable sirve para comparar objetos de manera eficiente
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final int age;
  final String career;
  final int semester;
  final String? imageUrl;
  final List<String> interests;


  const UserEntity({required this.id, 
    required this.name, 
    required this.email,
    required this.age,
    required this.career,
    required this.semester,
    this.imageUrl,
    required this.interests,
  });

  UserEntity copyWith({String? id, String? name, String? email, int? age, String? career, int? semester, String? imageUrl, List<String>? interests}) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      career: career ?? this.career,
      semester: semester ?? this.semester,
      interests: interests ?? this.interests,
      imageUrl: imageUrl ?? this.imageUrl
    );
  }

  @override
  List<Object?> get props => [id, name, email, age, career, semester, imageUrl, interests];
}