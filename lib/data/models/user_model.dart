class UserProfile {
  final String id;
  final String name;
  final int age;
  final String career;
  final String semester;
  final String imageUrl;
  final List<String> interests;
  final String? email;
  final String? bio;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.career,
    required this.semester,
    required this.imageUrl,
    required this.interests,
    this.email,
    this.bio,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? career,
    String? semester,
    String? imageUrl,
    List<String>? interests,
    String? email,
    String? bio,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      career: career ?? this.career,
      semester: semester ?? this.semester,
      imageUrl: imageUrl ?? this.imageUrl,
      interests: interests ?? this.interests,
      email: email ?? this.email,
      bio: bio ?? this.bio,
    );
  }
}

List<UserProfile> getDummyUsers() {
  return [
    UserProfile(
      id: '1',
      name: 'Ana García',
      age: 20,
      career: 'Diseño Gráfico',
      semester: '4° semestre',
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
      interests: ['Fotografía', 'Cine', 'Senderismo'],
    ),
    UserProfile(
      id: '2',
      name: 'Carlos Mendoza',
      age: 22,
      career: 'Ingeniería de Sistemas',
      semester: '6° semestre',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      interests: ['Programación', 'Videojuegos', 'Música'],
    ),
    UserProfile(
      id: '3',
      name: 'Laura Rodríguez',
      age: 21,
      career: 'Psicología',
      semester: '5° semestre',
      imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800',
      interests: ['Lectura', 'Yoga', 'Café'],
    ),
    UserProfile(
      id: '4',
      name: 'Daniel Torres',
      age: 23,
      career: 'Administración de Empresas',
      semester: '7° semestre',
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800',
      interests: ['Emprendimiento', 'Deportes', 'Networking'],
    ),
    UserProfile(
      id: '5',
      name: 'Valentina Silva',
      age: 19,
      career: 'Comunicación Social',
      semester: '3° semestre',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800',
      interests: ['Fotografía', 'Redes Sociales', 'Arte'],
    ),
  ];
}

UserProfile getCurrentUser() {
  return UserProfile(
    id: 'current_user',
    name: 'Sofia Rodriguez',
    age: 20,
    career: 'Diseño Gráfico',
    semester: '4° Semestre',
    imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
    interests: ['Música', 'Deportes', 'Cine', 'Tecnología', 'Arte'],
    email: 's.rodriguez@soyudemedellin.edu.co',
    bio: 'Apasionada por la ilustración digital y el branding. En mi tiempo libre me gusta salir a correr y leer novelas de ciencia ficción. Me encanta conocer personas que compartan mis intereses y proyectar nuevas ideas.',
  );
}