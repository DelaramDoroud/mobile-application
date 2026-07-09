import 'package:cloud_firestore/cloud_firestore.dart';

class Tour {
  final String id;
  final Map<String, dynamic> destination;
  final Map<String, dynamic> origin;
  final String name;
  final String type; // nature | city | adventure | ...
  final List<dynamic> types;
  final String tripScope; // domestic | international
  final String description;
  final int durationDays;
  final num price;
  final String currency;
  final int remainingCapacity;
  final double ratingAvg;
  final int ratingCount;
  final List<dynamic> images;
  final List<dynamic> gearSuggestions;
  final Map<String, dynamic> dates;
  final DateTime createdAt;

  Tour({
    required this.id,
    required this.destination,
    required this.origin,
    required this.name,
    required this.type,
    required this.types,
    required this.tripScope,
    required this.description,
    required this.durationDays,
    required this.price,
    required this.currency,
    required this.remainingCapacity,
    required this.ratingAvg,
    required this.ratingCount,
    required this.images,
    required this.gearSuggestions,
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
      types: _readTypes(m),
      tripScope: m['tripScope'] ?? 'domestic',
      description: m['description'] ?? '',
      durationDays: (m['durationDays'] as num?)?.toInt() ?? 0,
      price: m['price'] ?? 0,
      currency: m['currency'] ?? 'USD',
      remainingCapacity: (m['remainingCapacity'] as num?)?.toInt() ?? 20,
      ratingAvg: (m['ratingAvg'] ?? 0).toDouble(),
      ratingCount: (m['ratingCount'] ?? 0) as int,
      images: (m['images'] ?? []) as List<dynamic>,
      gearSuggestions: (m['gearSuggestions'] ?? []) as List<dynamic>,
      dates: (m['dates'] ?? {}) as Map<String, dynamic>,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static List<dynamic> _readTypes(Map<String, dynamic> m) {
    final value = m['types'];
    if (value is List) {
      return value.where((item) => item != null).toList();
    }

    final fallback = m['type'];
    if (fallback == null || fallback.toString().isEmpty) {
      return const [];
    }
    return [fallback.toString()];
  }
}
