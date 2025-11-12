import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_mate_app/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.authorInitials,
    super.authorProfileImage,
    required super.content,
    super.imageUrl,
    required super.tags,
    required super.timestamp,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, String id) {
    return PostModel(
      id: id,
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorInitials: json['authorInitials'] ?? '',
      authorProfileImage: json['authorProfileImage'],
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorInitials': authorInitials,
      'authorProfileImage': authorProfileImage,
      'content': content,
      'imageUrl': imageUrl,
      'tags': tags,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory PostModel.fromEntity(PostEntity post) {
    return PostModel(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      authorInitials: post.authorInitials,
      authorProfileImage: post.authorProfileImage,
      content: post.content,
      imageUrl: post.imageUrl,
      tags: post.tags,
      timestamp: post.timestamp,
    );
  }
}