import 'package:cloud_firestore/cloud_firestore.dart';

class Transport {
  final String id;
  final Map<String, dynamic> from;   // {code: "ROM", name: "Rome"}
  final Map<String, dynamic> to;     // {code: "MIL", name: "Milan"}
  final String mode;                 // flight | train | bus | boat
  final num basePrice;
  final String currency;
  final String company;
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
      company: m['company'] ?? '',
      schedule: (m['schedule'] ?? {}) as Map<String, dynamic>,
      // arrivalTime: (m['arriveAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
