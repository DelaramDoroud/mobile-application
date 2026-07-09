import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/theme/app_theme.dart';
import 'package:tourism_app/utils/accommodation_availability.dart';
import 'package:tourism_app/utils/reservation_pdf.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({
    super.key,
    this.title = 'My Reservations',
    this.statusFilter = 'reserved',
    this.emptyMessage = 'No reservations yet.',
    this.showBookNow = true,
  });

  final String title;
  final String statusFilter;
  final String emptyMessage;
  final bool showBookNow;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body:
          user == null
              ? Center(
                child: Text(
                  'Please sign in to view your reservations.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseFirestore.instance
                        .collection('my_reservations')
                        .where('userId', isEqualTo: user.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final items =
                      (snapshot.data?.docs ?? const [])
                          .where(
                            (doc) =>
                                (doc.data()['bookingStatus']?.toString() ??
                                    'reserved') ==
                                statusFilter,
                          )
                          .toList()
                        ..sort((a, b) {
                          final aTime =
                              (a.data()['createdAt'] as Timestamp?)?.toDate();
                          final bTime =
                              (b.data()['createdAt'] as Timestamp?)?.toDate();
                          if (aTime == null && bTime == null) return 0;
                          if (aTime == null) return 1;
                          if (bTime == null) return -1;
                          return bTime.compareTo(aTime);
                        });
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        emptyMessage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doc = items[index];
                      final data = items[index].data();
                      final stayStartDate =
                          (data['stayStartDate'] as Timestamp?)?.toDate();
                      final stayEndDate =
                          (data['stayEndDate'] as Timestamp?)?.toDate();
                      final returnDate =
                          (data['returnDate'] as Timestamp?)?.toDate();
                      final bookingStatus =
                          data['bookingStatus']?.toString() ?? 'reserved';
                      final isBooked = bookingStatus == 'booked';
                      final trackingCode = _trackingCodeFor(doc.id, data);
                      return InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['title']?.toString() ?? '',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                    ),
                                  ),
                                  if (showBookNow) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      tooltip: 'Remove reservation',
                                      icon: const Icon(Icons.close),
                                      color: Colors.redAccent,
                                      onPressed:
                                          () =>
                                              _deleteReservation(context, doc),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      (data['targetType']?.toString() ?? '')
                                          .toUpperCase(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  _BookingStatusChip(status: bookingStatus),
                                ],
                              ),
                              if (isBooked && !showBookNow) ...[
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    _TrackingCodeBadge(code: trackingCode),
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        foregroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      onPressed:
                                          () => _downloadReservationPdf(
                                            context,
                                            data,
                                            trackingCode,
                                          ),
                                      icon: const Icon(Icons.download_rounded),
                                      label: const Text('PDF'),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              if ((data['origin'] ?? '')
                                      .toString()
                                      .isNotEmpty ||
                                  (data['destination'] ?? '')
                                      .toString()
                                      .isNotEmpty)
                                Text(
                                  [
                                    if ((data['origin'] ?? '')
                                        .toString()
                                        .isNotEmpty)
                                      data['origin'].toString(),
                                    if ((data['destination'] ?? '')
                                        .toString()
                                        .isNotEmpty)
                                      data['destination'].toString(),
                                  ].join(' -> '),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              const SizedBox(height: 8),
                              Text(
                                (data['totalPrice'] ?? data['price'])
                                        ?.toString() ??
                                    '',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: AppColors.ink),
                              ),
                              if (stayStartDate != null &&
                                  stayEndDate != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Stay: ${_formatDate(stayStartDate)} - ${_formatDate(stayEndDate)}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.muted),
                                ),
                              ],
                              if ((data['tripType'] ?? '')
                                  .toString()
                                  .isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Trip: ${_displayTripType(data['tripType'])}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.muted),
                                ),
                              ],
                              if (returnDate != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Return: ${_formatDate(returnDate)}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.muted),
                                ),
                              ],
                              if ((data['roomLabel'] ?? '')
                                  .toString()
                                  .isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Room: ${data['roomLabel']}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.muted),
                                ),
                              ],
                              const SizedBox(height: 14),
                              Align(
                                alignment: Alignment.centerRight,
                                child:
                                    isBooked
                                        ? ElevatedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                            Icons.payment_rounded,
                                          ),
                                          label: const Text('Booked'),
                                        )
                                        : showBookNow
                                        ? ElevatedButton.icon(
                                          onPressed:
                                              () => _markReservationBooked(
                                                context,
                                                doc,
                                              ),
                                          icon: const Icon(
                                            Icons.payment_rounded,
                                          ),
                                          label: const Text('Book Now'),
                                        )
                                        : ElevatedButton.icon(
                                          onPressed: null,
                                          icon: const Icon(
                                            Icons.payment_rounded,
                                          ),
                                          label: const Text('Reserved'),
                                        ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

class _BookingStatusChip extends StatelessWidget {
  const _BookingStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final label = status.trim().isEmpty ? 'reserved' : status.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TrackingCodeBadge extends StatelessWidget {
  const _TrackingCodeBadge({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1B8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0A800)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.confirmation_number_rounded,
            size: 18,
            color: Color(0xFF8A5A00),
          ),
          const SizedBox(width: 8),
          Text(
            'Tracking Code: $code',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B4700),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationHistoryPage extends StatelessWidget {
  const ReservationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyReservationsPage(
      title: 'History',
      statusFilter: 'booked',
      emptyMessage: 'No booked reservations yet.',
      showBookNow: false,
    );
  }
}

Future<void> _markReservationBooked(
  BuildContext context,
  QueryDocumentSnapshot<Map<String, dynamic>> doc,
) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final data = doc.data();
    final trackingCode = _trackingCodeFor(doc.id, data);
    if (data['targetType'] == 'accommodation') {
      final start = (data['stayStartDate'] as Timestamp?)?.toDate();
      final end = (data['stayEndDate'] as Timestamp?)?.toDate();
      final targetId = data['targetId']?.toString();
      if (start == null || end == null || targetId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stay dates are missing.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final roomOption = data['roomOption'];
      final roomUnits =
          roomOption is Map ? (roomOption['rooms'] as num?)?.toInt() ?? 1 : 1;
      final bookedStays = await fetchBookedAccommodationStays(targetId);
      final isAvailable = isAccommodationStayAvailable(
        bookedStays: bookedStays,
        start: start,
        end: end,
        availableUnits: roomUnits < 1 ? 1 : roomUnits,
        roomLabel: data['roomLabel']?.toString(),
      );
      if (!isAvailable) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('This stay is no longer available for these dates.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final targetType = data['targetType']?.toString();
    if (targetType == 'transport' || targetType == 'tour') {
      final booked = await _bookCapacityTrackedReservation(
        doc,
        data,
        trackingCode,
      );
      if (!booked) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('No remaining capacity available.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('Successfully booked. Tracking code: $trackingCode'),
        ),
      );
      return;
    }

    await doc.reference.set({
      'bookingStatus': 'booked',
      'bookedAt': FieldValue.serverTimestamp(),
      'trackingCode': trackingCode,
    }, SetOptions(merge: true));

    messenger.showSnackBar(
      SnackBar(
        content: Text('Reservation booked. Tracking code: $trackingCode'),
      ),
    );
  } catch (error) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('Could not book reservation: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<bool> _bookCapacityTrackedReservation(
  QueryDocumentSnapshot<Map<String, dynamic>> reservationDoc,
  Map<String, dynamic> reservationData,
  String trackingCode,
) async {
  return FirebaseFirestore.instance.runTransaction((transaction) async {
    final refs = _capacityDocumentRefs(reservationData);
    if (refs.isEmpty) return false;
    final passengerCount =
        (reservationData['passengerCount'] as num?)?.toInt() ?? 1;
    final capacityToReserve = passengerCount < 1 ? 1 : passengerCount;

    final snapshots = <DocumentSnapshot<Map<String, dynamic>>>[];
    for (final ref in refs) {
      snapshots.add(await transaction.get(ref));
    }

    for (final snapshot in snapshots) {
      if (!snapshot.exists) return false;
      final capacity =
          (snapshot.data()?['remainingCapacity'] as num?)?.toInt() ?? 0;
      if (capacity < capacityToReserve) return false;
    }

    for (final snapshot in snapshots) {
      transaction.update(snapshot.reference, {
        'remainingCapacity': FieldValue.increment(-capacityToReserve),
      });
    }

    transaction.set(reservationDoc.reference, {
      'bookingStatus': 'booked',
      'bookedAt': FieldValue.serverTimestamp(),
      'trackingCode': trackingCode,
    }, SetOptions(merge: true));

    return true;
  });
}

Future<void> _downloadReservationPdf(
  BuildContext context,
  Map<String, dynamic> data,
  String trackingCode,
) async {
  final messenger = ScaffoldMessenger.of(context);

  try {
    final pdfData = await _reservationDataWithUserProfile(data);
    await downloadReservationPdf(data: pdfData, trackingCode: trackingCode);
  } catch (error) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('Could not create PDF: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<Map<String, dynamic>> _reservationDataWithUserProfile(
  Map<String, dynamic> data,
) async {
  final pdfData = Map<String, dynamic>.from(data);
  final hasName = pdfData['name']?.toString().trim().isNotEmpty ?? false;
  final hasSurname = pdfData['surname']?.toString().trim().isNotEmpty ?? false;
  if (hasName && hasSurname) return pdfData;

  final userId = pdfData['userId']?.toString();
  if (userId == null || userId.isEmpty) return pdfData;

  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  final userData = userDoc.data();
  if (userData == null) return pdfData;

  pdfData['name'] ??= userData['name'];
  pdfData['surname'] ??= userData['surname'];
  pdfData['username'] ??= userData['username'];
  return pdfData;
}

String _trackingCodeFor(String reservationId, Map<String, dynamic> data) {
  final existing = data['trackingCode']?.toString().trim();
  if (existing != null && existing.isNotEmpty) return existing;
  return _generateTrackingCode(reservationId);
}

String _generateTrackingCode(String seed) {
  final hash = seed.codeUnits.fold<int>(
    0,
    (value, unit) => (value * 31 + unit) & 0x7fffffff,
  );
  final code = hash.toRadixString(36).toUpperCase().padLeft(6, '0');
  return 'ST-${code.substring(code.length - 6)}';
}

List<DocumentReference<Map<String, dynamic>>> _capacityDocumentRefs(
  Map<String, dynamic> reservationData,
) {
  final db = FirebaseFirestore.instance;
  final targetType = reservationData['targetType']?.toString();

  if (targetType == 'tour') {
    final targetId = reservationData['targetId']?.toString();
    if (targetId == null || targetId.isEmpty) return const [];
    return [db.collection('tours').doc(targetId)];
  }

  if (targetType == 'transport') {
    final tickets =
        ((reservationData['transportTickets'] ?? const []) as List)
            .whereType<Map>()
            .map((ticket) => Map<String, dynamic>.from(ticket))
            .toList();
    if (tickets.isNotEmpty) {
      return tickets
          .map((ticket) => ticket['id']?.toString())
          .where((id) => id != null && id.isNotEmpty)
          .map((id) => db.collection('transports').doc(id))
          .toList();
    }

    final targetId = reservationData['targetId']?.toString();
    if (targetId == null || targetId.isEmpty) return const [];
    return [db.collection('transports').doc(targetId)];
  }

  return const [];
}

Future<void> _deleteReservation(
  BuildContext context,
  QueryDocumentSnapshot<Map<String, dynamic>> doc,
) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Remove reservation?'),
          content: const Text(
            'This item will be removed from your reservations.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        ),
  );

  if (shouldDelete != true || !context.mounted) return;

  try {
    await doc.reference.delete();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Reservation removed.')));
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not remove reservation: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String _displayTripType(Object? value) {
  final text = value?.toString() ?? '';
  if (text == 'round-trip') return 'Round trip';
  if (text == 'one-way') return 'One way';
  return text;
}
