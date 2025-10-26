class Post {
  final String id;
  final String authorName;
  final String authorInitials;
  final String content;
  final String? imageUrl;
  final List<String> tags;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.content,
    this.imageUrl,
    required this.tags,
    required this.timestamp,
  });
}

List<Post> getDummyPosts() {
  return [
    Post(
      id: '1',
      authorName: 'Ana Pérez',
      authorInitials: 'AP',
      content: 'Alguien tiene apuntes de la clase de Microeconomía? Los necesito urgente!',
      tags: ['Apuntes', 'Microeconomia', 'Polll', 'Angelllll', 'Tareaaaa', 'Ayudadaaaaa', 'Porfaaaaa', 'Potoo', 'Quiero'],
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Post(
      id: '2',
      authorName: 'Carlos Gómez',
      authorInitials: 'CG',
      content: '¡Fiesta de bienvenida en la residencia X este viernes!',
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800',
      tags: ['Fiesta', 'Social'],
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Post(
      id: '3',
      authorName: 'María López',
      authorInitials: 'ML',
      content: 'Vendo libros de Cálculo I y II, en excelente estado. Precio negociable.',
      imageUrl: 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=800',
      tags: ['Venta', 'Libros', 'Calculo'],
      timestamp: DateTime.now().subtract(Duration(hours: 8)),
    ),
    Post(
      id: '4',
      authorName: 'Juan Ramírez',
      authorInitials: 'JR',
      content: 'Alguien más se une al torneo de fútbol del sábado? Necesitamos 2 personas más para completar el equipo',
      tags: ['Deportes', 'Futbol', 'Social'],
      timestamp: DateTime.now().subtract(Duration(hours: 12)),
    ),
    Post(
      id: '5',
      authorName: 'Sofia Martinez',
      authorInitials: 'SM',
      content: 'Grupo de estudio de Programación este fin de semana. Quien se apunta?',
      imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
      tags: ['Estudio', 'Programacion', 'Académico'],
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];
}