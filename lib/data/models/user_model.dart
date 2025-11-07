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

List<UserModel> getDummyUsers() {
  return [
    const UserModel(
      email: 'user@email.com',
      id: '1',
      name: 'Ana García',
      age: 20,
      career: 'Diseño Gráfico',
      semester: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
      interests: ['Fotografía', 'Cine', 'Senderismo'],
    ),
    const UserModel(
      email: 'user@email.com',
      id: '2',
      name: 'Carlos Mendoza',
      age: 22,
      career: 'Ingeniería de Sistemas',
      semester: 6,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      interests: ['Programación', 'Videojuegos', 'Música'],
    ),
    const UserModel(
      email: 'user@email.com',
      id: '3',
      name: 'Laura Rodríguez',
      age: 21,
      career: 'Psicología',
      semester: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800',
      interests: ['Lectura', 'Yoga', 'Café'],
    ),
    const UserModel(
      email: 'user@email.com',
      id: '4',
      name: 'Daniel Torres',
      age: 23,
      career: 'Administración de Empresas',
      semester: 7,
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800',
      interests: ['Emprendimiento', 'Deportes', 'Networking'],
    ),
    const UserModel(
      email: 'user@email.com',
      id: '5',
      name: 'Valentina Silva',
      age: 19,
      career: 'Comunicación Social',
      semester: 3,
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800',
      interests: ['Fotografía', 'Redes Sociales', 'Arte'],
    ),
  ];
}
UserModel getCurrentUser() {
  return UserModel(
    id: 'current_user',
    name: 'Sofia Rodriguez',
    age: 20,
    career: 'Diseño Gráfico',
    semester: 4,
    imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
    interests: ['Música', 'Deportes', 'Cine', 'Tecnología', 'Arte'],
    email: 's.rodriguez@soyudemedellin.edu.co',
    bio: 'Apasionada por la ilustración digital y el branding. En mi tiempo libre me gusta salir a correr y leer novelas de ciencia ficción. Me encanta conocer personas que compartan mis intereses y proyectar nuevas ideas.',
  );
}