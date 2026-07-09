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
  final List<Map<String, dynamic>> roomOptions;
  final List<dynamic> images; // storage paths
  final String description;
  final Map<String, dynamic> location;
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
    required this.roomOptions,
    required this.images,
    required this.description,
    required this.location,
    required this.createdAt,
  });

  String get address => (location['address'] ?? '').toString();
  double? get latitude => (location['lat'] as num?)?.toDouble();
  double? get longitude => (location['lng'] as num?)?.toDouble();

  factory Accommodation.fromMap(String id, Map<String, dynamic> m) {
    final destination = Map<String, dynamic>.from(
      m['destination'] ?? const {},
    );
    return Accommodation(
      id: id,
      destinationId: destination['id'] ?? '',
      destinationName: destination['name'] ?? '',
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
      roomOptions:
          ((m['roomOptions'] ?? const []) as List)
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(),
      images: (m['images'] ?? []) as List<dynamic>,
      location: Map<String, dynamic>.from(m['location'] ?? const {}),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
