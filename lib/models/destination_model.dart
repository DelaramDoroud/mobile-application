import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String id;
  final String name;
  final String country;           // museum | nature | food | ...
  final String city;
  final double ratingAvg;
  final int ratingCount;
  final List<dynamic> images;
  final DateTime createdAt;

  Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    required this.ratingAvg,
    required this.ratingCount,
    required this.images,
    required this.createdAt,
  });

  factory Destination.fromMap(String id, Map<String, dynamic> m) {
    return Destination(
      id: id,
      name: m['name'] ?? '',
      country: m['country'] ?? '',
      city: m['city'] ?? '',
      ratingAvg: (m['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (m['ratingCount'] ?? 0) as int,
      images: (m['images'] ?? []) as List<dynamic>,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
