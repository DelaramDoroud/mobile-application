import 'package:cloud_firestore/cloud_firestore.dart';

class Tour {
  final String id;
  final Map<String, dynamic> destination; // {id: "dest_bali", name: "Indonesia - Denpasar"}
  final Map<String, dynamic> origin;      // {id: "dest_yogyakarta", name: "Indonesia - Yogyakarta"}
  final String name;
  final String type;                // nature | city | adventure | ...
  final String description;
  final num price;
  final String currency;
  final double ratingAvg;
  final int ratingCount;
  final List<dynamic> images;
  final Map<String,dynamic> dates; // {startDate: DateTime, endDate: DateTime}
  final DateTime createdAt;

  Tour({
    required this.id,
    required this.destination,
    required this.origin,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.currency,
    required this.ratingAvg,
    required this.ratingCount,
    required this.images,
    required this.dates,
    required this.createdAt,
  });

  factory Tour.fromMap(String id, Map<String, dynamic> m) {
    return Tour(
      id: id,
      destination: (m['destination'] ?? {}) as Map<String, dynamic>,
      origin: (m['origin'] ?? {}) as Map<String, dynamic>,
      name: m['name'] ?? '',
      type: m['type'] ?? '',
      description: m['description'] ?? '',
      price: m['price'] ?? 0,
      currency: m['currency'] ?? 'USD',
      ratingAvg: (m['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (m['ratingCount'] ?? 0) as int,
      images: (m['images'] ?? []) as List<dynamic>,
      dates: (m['dates'] ?? {}) as Map<String,dynamic>,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
