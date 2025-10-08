import 'package:cloud_firestore/cloud_firestore.dart';

class Accommodation {
  final String id;
  final String destinationId;
  final String destinationName;
  final String name;
  final String type;
  final int stars;
  final double ratingAvg;
  final int ratingCount;
  final num pricePerNight;
  final String currency;
  final List<dynamic> amenities;
  final List<dynamic> images; // storage paths
  final DateTime createdAt;

  Accommodation({
    required this.id,
    required this.destinationId,
    required this.destinationName,
    required this.name,
    required this.type,
    required this.stars,
    required this.ratingAvg,
    required this.ratingCount,
    required this.pricePerNight,
    required this.currency,
    required this.amenities,
    required this.images,
    required this.createdAt,
  });

  factory Accommodation.fromMap(String id, Map<String, dynamic> m) {
    return Accommodation(
      id: id,
      destinationId: m['destination']['id'] ?? '',
      destinationName: m['destination']['name'] ?? '',
      name: m['name'],
      type: m['type'],
      stars: (m['stars'] ?? 0) as int,
      ratingAvg: (m['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (m['ratingCount'] ?? 0) as int,
      pricePerNight: m['pricePerNight'] ?? 0,
      currency: m['currency'] ?? 'USD',
      amenities: (m['amenities'] ?? []) as List<dynamic>,
      images: (m['images'] ?? []) as List<dynamic>,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
