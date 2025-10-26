class Event {
  final String id;
  final String title;
  final String description;
  final String creatorName;
  final DateTime eventDate;
  final DateTime createdAt;
  final String? imageUrl;
  final String category;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorName,
    required this.eventDate,
    required this.createdAt,
    this.imageUrl,
    required this.category,
  });
}

List<Event> getDummyEvents() {
  return [
    Event(
      id: '1',
      title: 'Torneo de FIFA',
      description: '¡Demuestra quién es el mejor en la cancha virtual! Te esperamos para una tarde de pura competencia y diversión.',
      creatorName: 'Juan Pérez',
      eventDate: DateTime(2025, 10, 25, 18, 0),
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800',
      category: 'Deportivos',
    ),
    Event(
      id: '2',
      title: 'Grupo de estudio para cálculo',
      description: '¿Luchando con las derivadas? ¡No estás solo! Únete a nuestro grupo para resolver dudas y prepararnos juntos para el parcial.',
      creatorName: 'María González',
      eventDate: DateTime(2025, 10, 26, 15, 30),
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
      category: 'Académicos',
    ),
    Event(
      id: '3',
      title: 'Noche de cine al aire libre',
      description: 'Proyección especial de películas clásicas bajo las estrellas. Trae tu cobija y disfruta de una noche mágica en el campus.',
      creatorName: 'Carlos Ramírez',
      eventDate: DateTime(2025, 10, 27, 19, 0),
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800',
      category: 'Social',
    ),
    Event(
      id: '4',
      title: 'Workshop de desarrollo web',
      description: 'Aprende las bases de React y Flutter en este taller práctico. Ideal para principiantes que quieren iniciarse en el desarrollo de aplicaciones.',
      creatorName: 'Ana Torres',
      eventDate: DateTime(2025, 10, 28, 14, 0),
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      category: 'Académicos',
    ),
    Event(
      id: '5',
      title: 'Partido de fútbol intramural',
      description: '¡La gran final del torneo intramural! Ven a apoyar a tu facultad y disfrutar de un emocionante partido entre los mejores equipos del semestre.',
      creatorName: 'Luis Martínez',
      eventDate: DateTime(2025, 10, 29, 16, 0),
      createdAt: DateTime.now().subtract(Duration(hours: 8)),
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800',
      category: 'Deportivos',
    ),
  ];
}