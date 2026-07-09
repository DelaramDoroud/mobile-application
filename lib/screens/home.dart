import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/details_frame.dart';
import '../components/home_section_carousel.dart';
import '../data/firestore_repo.dart';
import '../models/accommodation_model.dart';
import '../models/tour_model.dart';
import '../models/transportation_model.dart';
import '../theme/app_theme.dart';
import '../widgets/image_slideshow.dart';
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
          colors: [
            AppColors.surface,
            AppColors.surfaceStrong.withValues(alpha: 0.7),
          ],
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
                final transport = Transport.fromMap(m['id'] as String, m);
                final title = transport.mode.toUpperCase();
                final price =
                    '${transport.currency == "USD" ? r"$" : transport.currency} ${transport.basePrice}';
                final date = _transportDateText(transport);

                return DetailsFrame(
                  id: transport.id,
                  imagePath:
                      transport.images.isNotEmpty
                          ? transport.images[0].toString()
                          : 'images/pic3.jpg',
                  title: title,
                  type: 'transport',
                  relatedDestinationId: transport.to['code']?.toString(),
                  origin: transport.from['city']?.toString(),
                  destination: transport.to['city']?.toString(),
                  description:
                      '${_vehicleDisplayName(transport.mode)} ticket operated by ${transport.company.isEmpty ? 'local partner' : transport.company}.',
                  images: transport.images,
                  remainingCapacity: transport.remainingCapacity,
                  price: date.isEmpty ? price : '$price - $date',
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
                final accommodation = Accommodation.fromMap(
                  m['id'] as String,
                  m,
                );
                final priceText =
                    '${accommodation.currency == 'USD' ? r'$' : accommodation.currency} ${accommodation.pricePerNight}';

                return DetailsFrame(
                  id: accommodation.id,
                  imagePath:
                      accommodation.images.isNotEmpty
                          ? accommodation.images[0].toString()
                          : 'images/pic3.jpg',
                  title: accommodation.name,
                  type: 'accommodation',
                  relatedDestinationId: accommodation.destinationId,
                  maxGuests: accommodation.maxGuests,
                  bedrooms: accommodation.bedrooms,
                  beds: accommodation.beds,
                  bathrooms: accommodation.bathrooms,
                  amenities: accommodation.amenities,
                  roomOptions: accommodation.roomOptions,
                  images: accommodation.images,
                  address: accommodation.address,
                  latitude: accommodation.latitude,
                  longitude: accommodation.longitude,
                  ratingAvg: accommodation.ratingAvg,
                  itemTypeLabel: _displayType(accommodation.type),
                  destination: accommodation.destinationName,
                  price: '$priceText - per night',
                  description: accommodation.description,
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
                final tour = Tour.fromMap(m['id'] as String, m);
                final priceText =
                    '${tour.currency == "USD" ? r"$" : tour.currency} ${tour.price}';
                final startDate = _dateFromMap(tour.dates, 'startDate');
                final date =
                    startDate == null
                        ? 'Flexible'
                        : DateFormat('d MMM').format(startDate);
                final description = _tourDescriptionWithDepartureTime(
                  tour.description,
                  startDate,
                );

                return DetailsFrame(
                  id: tour.id,
                  imagePath:
                      tour.images.isNotEmpty
                          ? tour.images[0].toString()
                          : 'images/pic3.jpg',
                  title: tour.name,
                  type: 'tour',
                  origin: tour.origin['name']?.toString(),
                  destination: tour.destination['name']?.toString(),
                  description: description,
                  itemTypeLabel: _displayTypes(tour.types, fallback: tour.type),
                  tripScope: tour.tripScope,
                  tourDurationDays: tour.durationDays,
                  remainingCapacity: tour.remainingCapacity,
                  gearSuggestions: tour.gearSuggestions,
                  images: tour.images,
                  price: '$priceText - $date',
                  ratingAvg: tour.ratingAvg,
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.16),
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
              const ImageSlideshow(
                imagePaths: [
                  'images/pic1.png',
                  'images/pic3.jpg',
                  'images/pic4.jpg',
                  'images/pic5.jpg',
                  'images/pic8.jpg',
                ],
                fallbackImagePath: 'images/pic1.png',
                height: 280,
                borderRadius: 0,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black.withValues(alpha: 0.52),
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

String _displayType(String value) {
  if (value.isEmpty) return '';
  return value
      .split(RegExp(r'[-_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

String _displayTypes(List<dynamic> values, {String fallback = ''}) {
  final labels =
      values
          .map((value) => value.toString())
          .where((value) => value.isNotEmpty)
          .map(_displayType)
          .where((value) => value.isNotEmpty)
          .toList();

  if (labels.isEmpty) return _displayType(fallback);
  return labels.join(', ');
}

DateTime? _dateFromMap(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value == null) return null;
  if (value is DateTime) return value;
  return value.toDate();
}

String _tourDescriptionWithDepartureTime(
  String description,
  DateTime? startDate,
) {
  if (startDate == null) return description;
  final departureTime = DateFormat('HH:mm').format(startDate);
  return '$description\nDeparture time: $departureTime';
}

String _transportDateText(Transport transport) {
  final value = transport.schedule['departAt'];
  if (value == null) return '';
  final date = value is DateTime ? value : value.toDate();
  return DateFormat('d MMM').format(date);
}

String _vehicleDisplayName(String mode) {
  if (mode == 'ship') return 'Ship';
  return mode.isEmpty ? 'Transport' : mode[0].toUpperCase() + mode.substring(1);
}
