import 'package:cloud_firestore/cloud_firestore.dart';

class BookedStayRange {
  const BookedStayRange({
    required this.start,
    required this.end,
    this.roomLabel,
  });

  final DateTime start;
  final DateTime end;
  final String? roomLabel;
}

Future<List<BookedStayRange>> fetchBookedAccommodationStays(
  String accommodationId,
) async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('my_reservations')
          .where('targetId', isEqualTo: accommodationId)
          .get();

  return snapshot.docs
      .map((doc) {
        final data = doc.data();
        if (data['targetType'] != 'accommodation' ||
            data['bookingStatus'] != 'booked') {
          return null;
        }
        final start = (data['stayStartDate'] as Timestamp?)?.toDate();
        final end = (data['stayEndDate'] as Timestamp?)?.toDate();
        if (start == null || end == null) return null;

        return BookedStayRange(
          start: DateTime(start.year, start.month, start.day),
          end: DateTime(end.year, end.month, end.day),
          roomLabel: data['roomLabel']?.toString(),
        );
      })
      .whereType<BookedStayRange>()
      .toList();
}

bool isAccommodationStayAvailable({
  required List<BookedStayRange> bookedStays,
  required DateTime start,
  required DateTime end,
  required int availableUnits,
  String? roomLabel,
}) {
  final normalizedStart = DateTime(start.year, start.month, start.day);
  final normalizedEnd = DateTime(end.year, end.month, end.day);
  if (!normalizedEnd.isAfter(normalizedStart)) return false;

  final overlappingCount =
      bookedStays.where((stay) {
        if (roomLabel != null &&
            roomLabel.isNotEmpty &&
            stay.roomLabel != roomLabel) {
          return false;
        }
        return normalizedStart.isBefore(stay.end) &&
            normalizedEnd.isAfter(stay.start);
      }).length;

  return overlappingCount < availableUnits;
}
