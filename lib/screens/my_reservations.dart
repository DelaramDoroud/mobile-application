import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/screens/details_page.dart';
import 'package:tourism_app/theme/app_theme.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('My Reservations')),
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

                  final items = (snapshot.data?.docs ?? const []).toList()
                    ..sort((a, b) {
                      final aTime = (a.data()['createdAt'] as Timestamp?)
                          ?.toDate();
                      final bTime = (b.data()['createdAt'] as Timestamp?)
                          ?.toDate();
                      if (aTime == null && bTime == null) return 0;
                      if (aTime == null) return 1;
                      if (bTime == null) return -1;
                      return bTime.compareTo(aTime);
                    });
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No reservations yet.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = items[index].data();
                      return InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => DetailsPage(
                                    id: data['targetId']?.toString() ?? '',
                                    title: data['title']?.toString() ?? '',
                                    type: data['targetType']?.toString() ?? '',
                                    price: data['price']?.toString() ?? '',
                                    origin: data['origin']?.toString(),
                                    destination: data['destination']?.toString(),
                                    description: data['description']?.toString(),
                                    ratingAvg:
                                        (data['ratingAvg'] as num?)
                                            ?.toDouble(),
                                    relatedDestinationId:
                                        data['relatedDestinationId']?.toString(),
                                    maxGuests:
                                        (data['maxGuests'] as num?)?.toInt(),
                                    bedrooms:
                                        (data['bedrooms'] as num?)?.toInt(),
                                    beds: (data['beds'] as num?)?.toInt(),
                                    bathrooms:
                                        (data['bathrooms'] as num?)?.toInt(),
                                    amenities:
                                        (data['amenities'] as List?)?.toList(),
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title']?.toString() ?? '',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                (data['targetType']?.toString() ?? '')
                                    .toUpperCase(),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              if ((data['origin'] ?? '').toString().isNotEmpty ||
                                  (data['destination'] ?? '').toString().isNotEmpty)
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
                                data['price']?.toString() ?? '',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: AppColors.ink),
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
