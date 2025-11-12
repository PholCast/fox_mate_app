import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String authorInitials;
  final String? authorProfileImage;
  final String content;
  final String? imageUrl;
  final List<String> tags;
  final DateTime timestamp;

  const PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorInitials,
    this.authorProfileImage,
    required this.content,
    this.imageUrl,
    required this.tags,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        authorId,
        authorName,
        authorInitials,
        authorProfileImage,
        content,
        imageUrl,
        tags,
        timestamp,
      ];
}