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
  final int maxGuests;
  final int bedrooms;
  final int beds;
  final int bathrooms;
  final List<dynamic> amenities;
  final List<dynamic> images; // storage paths
  final String description;
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
    required this.maxGuests,
    required this.bedrooms,
    required this.beds,
    required this.bathrooms,
    required this.amenities,
    required this.images,
    required this.description,
    required this.createdAt,
  });

  factory Accommodation.fromMap(String id, Map<String, dynamic> m) {
    return Accommodation(
      id: id,
      destinationId: m['destination']['id'] ?? '',
      destinationName: m['destination']['name'] ?? '',
      name: m['name'],
      type: m['type'],
      description: m['description'] ?? '',
      stars: (m['stars'] ?? 0) as int,
      ratingAvg: (m['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (m['ratingCount'] ?? 0) as int,
      pricePerNight: m['pricePerNight'] ?? 0,
      currency: m['currency'] ?? 'USD',
      maxGuests: (m['maxGuests'] ?? 2) as int,
      bedrooms: (m['bedrooms'] ?? 1) as int,
      beds: (m['beds'] ?? 1) as int,
      bathrooms: (m['bathrooms'] ?? 1) as int,
      amenities: (m['amenities'] ?? []) as List<dynamic>,
      images: (m['images'] ?? []) as List<dynamic>,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
