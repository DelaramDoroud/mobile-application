import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/details_frame.dart';
import '../components/home_section_carousel.dart';
import '../data/firestore_repo.dart';
import '../theme/app_theme.dart';
import 'reservation.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _repo = FirestoreRepo();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surface, AppColors.surfaceStrong.withOpacity(0.7)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _HeroBanner(),
            HomeSectionCarousel(
              index: 0,
              title: 'Recommended Transports',
              onMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            ReservePage(accomodations: false, transport: false),
                  ),
                );
              },
              stream: _repo.streamLatestTransports(limit: 4),
              itemBuilder: (m) {
                final type = (m['mode'] ?? '').toString();
                final origin = m['from']['city'] ?? '';
                final destination = m['to']['city'] ?? '';
                final price = (m['basePrice'] ?? 0).toString();
                final schedule = m['schedule'] as Map<String, dynamic>? ?? {};
                var dateText = '';
                if (schedule.isNotEmpty) {
                  final start = (schedule['departAt']).toDate();
                  dateText = '${start.day} ${_mon(start)}';
                }

                return DetailsFrame(
                  id: m['id'],
                  imagePath: 'images/pic3.jpg',
                  title: type,
                  type: 'transport',
                  relatedDestinationId: m['to']['code']?.toString(),
                  origin: origin,
                  destination: destination,
                  price: '$price \$ - $dateText',
                  color: const Color(0xFF8BC8F3),
                );
              },
            ),
            HomeSectionCarousel(
              index: 1,
              title: 'Recommended Accommodations',
              onMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            ReservePage(accomodations: true, transport: false),
                  ),
                );
              },
              stream: _repo.streamLatestAccommodations(limit: 4),
              itemBuilder: (m) {
                final name = (m['name'] ?? '').toString();
                final destination = (m['destination']['name'] ?? '').toString();
                final price = (m['pricePerNight'] ?? 0).toString();
                return DetailsFrame(
                  id: m['id'],
                  imagePath: 'images/pic3.jpg',
                  title: name,
                  type: 'accommodation',
                  relatedDestinationId: m['destination']['id']?.toString(),
                  maxGuests: (m['maxGuests'] ?? 2) as int,
                  bedrooms: (m['bedrooms'] ?? 1) as int,
                  beds: (m['beds'] ?? 1) as int,
                  bathrooms: (m['bathrooms'] ?? 1) as int,
                  amenities: (m['amenities'] ?? const []) as List<dynamic>,
                  destination: destination,
                  price: '$price \$ - per night',
                  color: const Color(0xFFF3CB86),
                );
              },
            ),
            HomeSectionCarousel(
              index: 2,
              title: 'Recommended Tours',
              onMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            ReservePage(accomodations: false, transport: false),
                  ),
                );
              },
              stream: _repo.streamLatestTours(limit: 4),
              itemBuilder: (m) {
                final name = (m['name'] ?? '').toString();
                final origin = (m['origin']['name'] ?? '').toString();
                final price = (m['price'] ?? 0).toString();
                var dateText = '';
                final dates = m['dates'] as Map<String, dynamic>? ?? {};
                if (dates.isNotEmpty) {
                  final start = (dates['startDate']).toDate();
                  dateText = '${start.day} ${_mon(start)} ${start.year}';
                }

                return DetailsFrame(
                  id: m['id'],
                  imagePath: 'images/pic3.jpg',
                  title: name,
                  type: 'tour',
                  origin: origin,
                  price: '$price \$ - $dateText',
                  color: const Color(0xFF93D8B2),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.16),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('images/pic1.png', fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.12),
                      Colors.black.withOpacity(0.52),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 84, 24, 24),
                child: Text(
                  'Plan your travel',
                  style: GoogleFonts.adamina(
                    color: AppColors.white,
                    fontSize: width < 380 ? 32 : 38,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _mon(DateTime d) {
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return m[d.month - 1];
}
