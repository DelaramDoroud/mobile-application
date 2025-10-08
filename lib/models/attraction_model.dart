import 'package:cloud_firestore/cloud_firestore.dart';

class Attraction {
  final String id;
  final Map<String, dynamic> destination;
  final String name;
  final String category;           // museum | nature | food | ...
  final String description;
  final double ratingAvg;
  final int ratingCount;
  final List<dynamic> images;
  final DateTime createdAt;

  Attraction({
    required this.id,
    required this.destination,
    required this.name,
    required this.category,
    required this.description,
    required this.ratingAvg,
    required this.ratingCount,
    required this.images,
    required this.createdAt,
  });

  factory Attraction.fromMap(String id, Map<String, dynamic> m) {
    return Attraction(
      id: id,
      destination: (m['destination'] ?? {}) as Map<String, dynamic>,
      name: m['name'] ?? '',
      category: m['category'] ?? '',
      description: m['description'] ?? '',
      ratingAvg: (m['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (m['ratingCount'] ?? 0) as int,
      images: (m['images'] ?? []) as List<dynamic>,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
