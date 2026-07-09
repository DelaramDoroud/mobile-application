import 'package:cloud_firestore/cloud_firestore.dart';

class Transport {
  final String id;
  final Map<String, dynamic> from; // {code: "ROM", name: "Rome"}
  final Map<String, dynamic> to; // {code: "MIL", name: "Milan"}
  final String mode; // flight | train | bus | ship
  final num basePrice;
  final String currency;
  final String company;
  final String? flightNumber;
  final String? trainNumber;
  final int remainingCapacity;
  final List<dynamic> images; // URL or asset path for transport image
  final Map<String, dynamic> schedule;
  // final DateTime arrivalTime;
  final DateTime createdAt;

  Transport({
    required this.id,
    required this.from,
    required this.to,
    required this.mode,
    required this.basePrice,
    required this.currency,
    required this.company,
    this.flightNumber,
    this.trainNumber,
    required this.remainingCapacity,
    required this.images,
    required this.schedule,
    // required this.arrivalTime,
    required this.createdAt,
  });

  factory Transport.fromMap(String id, Map<String, dynamic> m) {
    return Transport(
      id: id,
      from: (m['from'] ?? {}) as Map<String, dynamic>,
      to: (m['to'] ?? {}) as Map<String, dynamic>,
      mode: m['mode'] ?? '',
      basePrice: m['basePrice'] ?? 0,
      currency: m['currency'] ?? 'USD',
      company: m['company'] ?? m['operator'] ?? '',
      flightNumber: m['flightNumber']?.toString(),
      trainNumber: m['trainNumber']?.toString(),
      remainingCapacity: (m['remainingCapacity'] as num?)?.toInt() ?? 40,
      images: (m['images'] ?? []) as List<dynamic>,
      schedule: (m['schedule'] ?? {}) as Map<String, dynamic>,
      // arrivalTime: (m['arriveAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
