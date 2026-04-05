import 'package:cloud_firestore/cloud_firestore.dart';

class Attraction {
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
    required this.ticketPrice,
    required this.openHours,
    required this.location,
  });

  final String id;
  final Map<String, dynamic> destination;
  final String name;
  final String category;
  final String description;
  final double ratingAvg;
  final int ratingCount;
  final List<dynamic> images;
  final DateTime createdAt;
  final num ticketPrice;
  final String openHours;
  final Map<String, dynamic> location;

  String get destinationId => (destination['id'] ?? '').toString();
  String get destinationName => (destination['name'] ?? '').toString();
  String get address => (location['address'] ?? '').toString();

  factory Attraction.fromMap(String id, Map<String, dynamic> m) {
    return Attraction(
      id: id,
      destination: Map<String, dynamic>.from(m['destination'] ?? const {}),
      name: m['name'] ?? '',
      category: m['category'] ?? '',
      description: m['description'] ?? '',
      ratingAvg: (m['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (m['ratingCount'] ?? 0) as int,
      images: (m['images'] ?? []) as List<dynamic>,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ticketPrice: m['ticketPrice'] ?? 0,
      openHours: m['openHours'] ?? '',
      location: Map<String, dynamic>.from(m['location'] ?? const {}),
    );
  }
}
