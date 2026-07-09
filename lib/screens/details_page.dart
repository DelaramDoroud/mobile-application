import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/data/firestore_repo.dart';
import 'package:tourism_app/models/attraction_model.dart';
import 'package:tourism_app/screens/attraction_details.dart';
import 'package:tourism_app/theme/app_theme.dart';
import 'package:tourism_app/utils/accommodation_availability.dart';
import 'package:tourism_app/utils/directions_launcher.dart';
import 'package:tourism_app/widgets/image_slideshow.dart';
import 'package:tourism_app/widgets/user_reviews_section.dart';
import 'package:tourism_app/screens/my_reservations.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    this.origin,
    this.destination,
    this.description,
    this.ratingAvg,
    this.itemTypeLabel,
    this.tripScope,
    this.tourDurationDays,
    this.remainingCapacity,
    this.gearSuggestions,
    this.relatedDestinationId,
    this.address,
    this.latitude,
    this.longitude,
    this.maxGuests,
    this.bedrooms,
    this.beds,
    this.bathrooms,
    this.amenities,
    this.roomOptions,
    this.images,
    this.roundTrip = false,
    this.returnDate,
    this.transportTickets,
  });

  final String id;
  final String title;
  final String type;
  final String price;
  final String? origin;
  final String? destination;
  final String? description;
  final double? ratingAvg;
  final String? itemTypeLabel;
  final String? tripScope;
  final int? tourDurationDays;
  final int? remainingCapacity;
  final List<dynamic>? gearSuggestions;
  final String? relatedDestinationId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? maxGuests;
  final int? bedrooms;
  final int? beds;
  final int? bathrooms;
  final List<dynamic>? amenities;
  final List<Map<String, dynamic>>? roomOptions;
  final List<dynamic>? images;
  final bool roundTrip;
  final DateTime? returnDate;
  final List<Map<String, dynamic>>? transportTickets;

  @override
  Widget build(BuildContext context) {
    final visual = _visualsFor(type);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: visual.gradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: visual.appBarColor,
                surfaceTintColor: visual.appBarColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                pinned: true,
                title: Text(
                  visual.pageTitle,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.white),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heroCard(context, visual),
                      const SizedBox(height: 16),
                      if (_showAccommodationSpecs)
                        _AccommodationStaySection(
                          id: id,
                          title: title,
                          type: type,
                          price: price,
                          origin: origin,
                          destination: destination,
                          description: description,
                          ratingAvg: ratingAvg,
                          relatedDestinationId: relatedDestinationId,
                          address: address,
                          latitude: latitude,
                          longitude: longitude,
                          itemTypeLabel: itemTypeLabel,
                          maxGuests: maxGuests,
                          bedrooms: bedrooms,
                          beds: beds,
                          bathrooms: bathrooms,
                          amenities: amenities,
                          roomOptions: roomOptions,
                          images: images,
                        ),
                      if (_showAccommodationSpecs) const SizedBox(height: 16),
                      if (_showCapacityCard) _capacityCard(context),
                      if (_showCapacityCard) const SizedBox(height: 16),
                      if (_showTourSpecs) _tourSpecsCard(context),
                      if (_showTourSpecs) const SizedBox(height: 16),
                      if ((description ?? '').isNotEmpty)
                        _descriptionCard(context),
                      if ((description ?? '').isNotEmpty)
                        const SizedBox(height: 16),
                      if (!_showAccommodationSpecs) _ctaRow(context),
                      const SizedBox(height: 20),
                      if (_showRelatedAttractions)
                        _RelatedAttractionsSection(
                          destinationId: relatedDestinationId!,
                          accent: visual.accent,
                        ),
                      if (_showRelatedAttractions) const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: UserReviewsSection(
                          targetId: id,
                          targetType: type,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _showRelatedAttractions {
    return relatedDestinationId != null &&
        relatedDestinationId!.isNotEmpty &&
        (type == 'accommodation' || type == 'transport');
  }

  bool get _showAccommodationSpecs => type == 'accommodation';

  bool get _showCapacityCard =>
      (type == 'transport' || type == 'tour') && remainingCapacity != null;

  bool get _showTourSpecs =>
      type == 'tour' &&
      (((itemTypeLabel ?? '').isNotEmpty) ||
          ((tripScope ?? '').isNotEmpty) ||
          ((tourDurationDays ?? 0) > 0) ||
          (gearSuggestions ?? const []).isNotEmpty);

  Widget _heroCard(BuildContext context, _DetailsVisuals visual) {
    final textTheme = Theme.of(context).textTheme;
    final routeText = [
      if ((origin ?? '').isNotEmpty) origin,
      if ((destination ?? '').isNotEmpty) destination,
    ].join(type == 'transport' ? ' -> ' : '\n');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                ImageSlideshow(
                  imagePaths: images ?? const [],
                  fallbackImagePath: visual.imagePath,
                  height: 220,
                  borderRadius: 22,
                ),
                if (_showCapacityCard)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${remainingCapacity ?? 0} left',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 10),
          _ratingSummary(context, visual),
          if (routeText.trim().isNotEmpty)
            Text(
              routeText,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.white.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),
          if ((itemTypeLabel ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoPill(icon: Icons.category_rounded, label: itemTypeLabel!),
          ],
        ],
      ),
    );
  }

  Widget _ratingSummary(BuildContext context, _DetailsVisuals visual) {
    final textTheme = Theme.of(context).textTheme;
    final fallbackRating = ratingAvg ?? 0;

    return StreamBuilder<ReviewStats>(
      stream: FirestoreRepo().streamReviewStats(targetType: type, targetId: id),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        final average =
            stats != null && stats.count > 0 ? stats.average : fallbackRating;
        final count = stats?.count ?? 0;

        if (average <= 0 && count == 0) return const SizedBox(height: 10);

        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < average.round()
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: const Color(0xFFFFD54F),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${average.toStringAsFixed(1)} ($count)',
                style: textTheme.bodyLarge?.copyWith(color: AppColors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _descriptionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this ${type == 'transport' ? 'route' : type}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 10),
          Text(
            description ?? '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white.withValues(alpha: 0.92),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaRow(BuildContext context) {
    return _BookingCtaRow(
      id: id,
      title: title,
      type: type,
      price: price,
      origin: origin,
      destination: destination,
      description: description,
      ratingAvg: ratingAvg,
      relatedDestinationId: relatedDestinationId,
      address: address,
      latitude: latitude,
      longitude: longitude,
      itemTypeLabel: itemTypeLabel,
      tourDurationDays: tourDurationDays,
      remainingCapacity: remainingCapacity,
      maxGuests: maxGuests,
      bedrooms: bedrooms,
      beds: beds,
      bathrooms: bathrooms,
      amenities: amenities,
      roomOptions: roomOptions,
      tripScope: tripScope,
      gearSuggestions: gearSuggestions,
      images: images,
      roundTrip: roundTrip,
      returnDate: returnDate,
      transportTickets: transportTickets,
    );
  }

  Widget _capacityCard(BuildContext context) {
    final capacity = remainingCapacity ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_seat_rounded, color: AppColors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Remaining capacity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '$capacity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tourSpecsCard(BuildContext context) {
    final gear = gearSuggestions ?? const [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tour details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.white),
          ),
          if ((itemTypeLabel ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoPill(icon: Icons.category_rounded, label: itemTypeLabel!),
          ],
          if ((tripScope ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoPill(
              icon: Icons.public_rounded,
              label:
                  '${tripScope![0].toUpperCase()}${tripScope!.substring(1)} trip',
            ),
          ],
          if ((tourDurationDays ?? 0) > 0) ...[
            const SizedBox(height: 12),
            _InfoPill(
              icon: Icons.calendar_month_rounded,
              label:
                  '${tourDurationDays!} ${tourDurationDays == 1 ? 'day' : 'days'}',
            ),
          ],
          if (gear.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Recommended gear',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  gear
                      .map(
                        (item) => _InfoPill(
                          icon: Icons.backpack_rounded,
                          label: item.toString().replaceAll('-', ' '),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccommodationStaySection extends StatefulWidget {
  const _AccommodationStaySection({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    this.origin,
    this.destination,
    this.description,
    this.ratingAvg,
    this.relatedDestinationId,
    this.address,
    this.latitude,
    this.longitude,
    this.itemTypeLabel,
    this.maxGuests,
    this.bedrooms,
    this.beds,
    this.bathrooms,
    this.amenities,
    this.roomOptions,
    this.images,
  });

  final String id;
  final String title;
  final String type;
  final String price;
  final String? origin;
  final String? destination;
  final String? description;
  final double? ratingAvg;
  final String? relatedDestinationId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? itemTypeLabel;
  final int? maxGuests;
  final int? bedrooms;
  final int? beds;
  final int? bathrooms;
  final List<dynamic>? amenities;
  final List<Map<String, dynamic>>? roomOptions;
  final List<dynamic>? images;

  @override
  State<_AccommodationStaySection> createState() =>
      _AccommodationStaySectionState();
}

class _AccommodationStaySectionState extends State<_AccommodationStaySection> {
  Map<String, dynamic>? _selectedRoom;

  bool get _isHotel => (widget.itemTypeLabel ?? '').toLowerCase() == 'hotel';

  List<Map<String, dynamic>> get _roomOptions => widget.roomOptions ?? const [];

  Map<String, dynamic>? get _activeRoom =>
      _selectedRoom ?? (_roomOptions.isNotEmpty ? _roomOptions.first : null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stayDetailsCard(context),
        const SizedBox(height: 16),
        _MapDirectionsCard(
          address:
              (widget.address ?? '').isNotEmpty
                  ? widget.address!
                  : (widget.destination ?? ''),
          latitude: widget.latitude,
          longitude: widget.longitude,
        ),
        const SizedBox(height: 16),
        _BookingCtaRow(
          id: widget.id,
          title: widget.title,
          type: widget.type,
          price: widget.price,
          origin: widget.origin,
          destination: widget.destination,
          description: widget.description,
          ratingAvg: widget.ratingAvg,
          relatedDestinationId: widget.relatedDestinationId,
          address: widget.address,
          latitude: widget.latitude,
          longitude: widget.longitude,
          itemTypeLabel: widget.itemTypeLabel,
          maxGuests: _specValue('maxGuests', fallback: widget.maxGuests),
          bedrooms: _specValue('bedrooms', fallback: widget.bedrooms),
          beds: _specValue('beds', fallback: widget.beds),
          bathrooms: _specValue('bathrooms', fallback: widget.bathrooms),
          amenities: widget.amenities,
          roomOptions: widget.roomOptions,
          selectedRoom: _activeRoom,
          images: widget.images,
        ),
      ],
    );
  }

  Widget _stayDetailsCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activeRoom = _activeRoom;
    final info = [
      _SpecItem(
        label: 'Max guests',
        value: _specText('maxGuests', fallback: widget.maxGuests),
        icon: Icons.groups_rounded,
      ),
      _SpecItem(
        label: 'Bedrooms',
        value: _specText('bedrooms', fallback: widget.bedrooms),
        icon: Icons.bedroom_parent_rounded,
      ),
      _SpecItem(
        label: 'Beds',
        value: _specText('beds', fallback: widget.beds),
        icon: Icons.bed_rounded,
      ),
      _SpecItem(
        label: 'Bathrooms',
        value: _specText('bathrooms', fallback: widget.bathrooms),
        icon: Icons.bathtub_rounded,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay details',
            style: textTheme.titleLarge?.copyWith(color: AppColors.white),
          ),
          if (_isHotel && _roomOptions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  _roomOptions.map((room) {
                    final selected = identical(room, activeRoom);
                    return ChoiceChip(
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedRoom = room),
                      label: Text(_roomOptionLabel(room)),
                      selectedColor: AppColors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.16),
                      labelStyle: textTheme.bodyMedium?.copyWith(
                        color: selected ? AppColors.primary : AppColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    );
                  }).toList(),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Price: ${activeRoom == null ? widget.price : _roomPriceText(activeRoom)}',
              style: textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: info.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final item = info[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(item.icon, color: AppColors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.label,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.78),
                            ),
                          ),
                          Text(
                            item.value,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if ((widget.amenities ?? const []).isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Amenities',
              style: textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  (widget.amenities ?? const [])
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.toString(),
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  int? _specValue(String key, {int? fallback}) {
    final room = _activeRoom;
    if (room == null) return fallback;
    final value = room[key] ?? (key == 'maxGuests' ? room['capacity'] : null);
    return (value as num?)?.toInt() ?? fallback;
  }

  String _specText(String key, {int? fallback}) {
    final value = _specValue(key, fallback: fallback);
    return (value ?? 0) > 0 ? '$value' : '-';
  }

  String _roomOptionLabel(Map<String, dynamic> room) {
    final label = room['label']?.toString();
    final capacity = (room['capacity'] as num?)?.toInt();
    if (label != null && label.isNotEmpty) return label;
    if (capacity != null) return '$capacity person room';
    return 'Room';
  }

  String _roomPriceText(Map<String, dynamic> room) {
    final price = room['pricePerNight'];
    final currency = room['currency']?.toString() ?? r'$';
    return '$currency $price / night';
  }
}

class _MapDirectionsCard extends StatelessWidget {
  const _MapDirectionsCard({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String address;
  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final lat = latitude;
    final lng = longitude;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: textTheme.titleLarge?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child:
                  lat == null || lng == null
                      ? const _MapFallback()
                      : Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            _staticMapUrl(lat, lng),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const _MapFallback(),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.22),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.place_rounded,
                                color: AppColors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  address.isEmpty ? 'Address not available' : address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed:
                    lat == null || lng == null
                        ? null
                        : () => openDirectionsFromCurrentLocation(
                          context,
                          destinationLat: lat,
                          destinationLng: lng,
                        ),
                icon: const Icon(Icons.directions_rounded),
                label: const Text('Directions'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _staticMapUrl(double lat, double lng) {
    return Uri.https('staticmap.openstreetmap.de', '/staticmap.php', {
      'center': '$lat,$lng',
      'zoom': '15',
      'size': '640x320',
      'markers': '$lat,$lng,red-pushpin',
    }).toString();
  }
}

class _MapFallback extends StatelessWidget {
  const _MapFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceStrong,
      child: const Center(
        child: Icon(Icons.map_rounded, color: AppColors.primary, size: 42),
      ),
    );
  }
}

class _BookingCtaRow extends StatefulWidget {
  const _BookingCtaRow({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    this.origin,
    this.destination,
    this.description,
    this.ratingAvg,
    this.relatedDestinationId,
    this.address,
    this.latitude,
    this.longitude,
    this.itemTypeLabel,
    this.tourDurationDays,
    this.remainingCapacity,
    this.maxGuests,
    this.bedrooms,
    this.beds,
    this.bathrooms,
    this.amenities,
    this.roomOptions,
    this.selectedRoom,
    this.tripScope,
    this.gearSuggestions,
    this.images,
    this.roundTrip = false,
    this.returnDate,
    this.transportTickets,
  });

  final String id;
  final String title;
  final String type;
  final String price;
  final String? origin;
  final String? destination;
  final String? description;
  final double? ratingAvg;
  final String? relatedDestinationId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? itemTypeLabel;
  final int? tourDurationDays;
  final int? remainingCapacity;
  final int? maxGuests;
  final int? bedrooms;
  final int? beds;
  final int? bathrooms;
  final List<dynamic>? amenities;
  final List<Map<String, dynamic>>? roomOptions;
  final Map<String, dynamic>? selectedRoom;
  final String? tripScope;
  final List<dynamic>? gearSuggestions;
  final List<dynamic>? images;
  final bool roundTrip;
  final DateTime? returnDate;
  final List<Map<String, dynamic>>? transportTickets;

  @override
  State<_BookingCtaRow> createState() => _BookingCtaRowState();
}

class _BookingCtaRowState extends State<_BookingCtaRow> {
  DateTimeRange? _stayRange;
  int _passengerCount = 1;

  bool get _isAccommodation => widget.type == 'accommodation';
  bool get _isTransport => widget.type == 'transport';
  bool get _isRoundTrip =>
      widget.roundTrip || (widget.transportTickets?.length ?? 0) > 1;
  bool get _isHotel =>
      _isAccommodation && (widget.itemTypeLabel ?? '').toLowerCase() == 'hotel';
  List<Map<String, dynamic>> get _roomOptions => widget.roomOptions ?? const [];
  Map<String, dynamic>? get _activeRoom =>
      widget.selectedRoom ??
      (_roomOptions.isNotEmpty ? _roomOptions.first : null);

  String? get _activeRoomLabel => _activeRoom?['label']?.toString();

  int get _availableUnits {
    final units = (_activeRoom?['rooms'] as num?)?.toInt() ?? 1;
    return units < 1 ? 1 : units;
  }

  int get _transportCapacity {
    final capacities =
        _resolvedTransportTickets
            .map((ticket) => (ticket['remainingCapacity'] as num?)?.toInt())
            .whereType<int>()
            .toList();
    if (capacities.isNotEmpty) {
      return capacities.reduce((a, b) => a < b ? a : b);
    }
    return widget.remainingCapacity ?? 1;
  }

  Future<void> _pickStayRange() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final bookedStays = await fetchBookedAccommodationStays(widget.id);
    if (!mounted) return;

    bool isSelectableRange(
      DateTime day,
      DateTime? selectedStart,
      DateTime? selectedEnd,
    ) {
      final candidateDay = DateUtils.dateOnly(day);
      if (candidateDay.isBefore(today)) return false;

      if (selectedStart == null || selectedEnd != null) {
        return isAccommodationStayAvailable(
          bookedStays: bookedStays,
          start: candidateDay,
          end: candidateDay.add(const Duration(days: 1)),
          availableUnits: _availableUnits,
          roomLabel: _activeRoomLabel,
        );
      }

      final start = DateUtils.dateOnly(selectedStart);
      final end = candidateDay.isAfter(start) ? candidateDay : start;
      return isAccommodationStayAvailable(
        bookedStays: bookedStays,
        start: start,
        end: end,
        availableUnits: _availableUnits,
        roomLabel: _activeRoomLabel,
      );
    }

    final initialRange =
        _stayRange != null &&
                isAccommodationStayAvailable(
                  bookedStays: bookedStays,
                  start: _stayRange!.start,
                  end: _stayRange!.end,
                  availableUnits: _availableUnits,
                  roomLabel: _activeRoomLabel,
                )
            ? _stayRange
            : null;

    final range = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(today.year + 2, today.month, today.day),
      initialDateRange: initialRange,
      selectableDayPredicate: isSelectableRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (range == null) return;
    final isAvailable = isAccommodationStayAvailable(
      bookedStays: bookedStays,
      start: range.start,
      end: range.end,
      availableUnits: _availableUnits,
      roomLabel: _activeRoomLabel,
    );
    if (!isAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('These dates are not available for this stay.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _stayRange = range);
  }

  Future<void> _book() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_isAccommodation && _stayRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your stay dates first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_isHotel && _roomOptions.isNotEmpty && _activeRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a room type first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_isTransport && _passengerCount > _transportCapacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passenger count exceeds remaining capacity.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_isAccommodation) {
      final bookedStays = await fetchBookedAccommodationStays(widget.id);
      final isAvailable = isAccommodationStayAvailable(
        bookedStays: bookedStays,
        start: _stayRange!.start,
        end: _stayRange!.end,
        availableUnits: _availableUnits,
        roomLabel: _activeRoomLabel,
      );
      if (!isAvailable) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('These dates are no longer available.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    final docId = _reservationDocId(user.uid);
    final data = {
      'userId': user.uid,
      'targetId': widget.id,
      'targetType': widget.type,
      'title': widget.title,
      'price': widget.price,
      'origin': widget.origin,
      'destination': widget.destination,
      'description': widget.description,
      'ratingAvg': widget.ratingAvg,
      'relatedDestinationId': widget.relatedDestinationId,
      'address': widget.address,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
      'itemTypeLabel': widget.itemTypeLabel,
      'tourDurationDays': widget.tourDurationDays,
      'remainingCapacity': widget.remainingCapacity,
      'maxGuests': widget.maxGuests,
      'bedrooms': widget.bedrooms,
      'beds': widget.beds,
      'bathrooms': widget.bathrooms,
      'amenities': widget.amenities,
      'roomOptions': widget.roomOptions,
      'tripScope': widget.tripScope,
      'gearSuggestions': widget.gearSuggestions,
      'images': widget.images,
      'bookingStatus': 'reserved',
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (_isAccommodation) {
      final stayNights = _stayNightCount(_stayRange!);
      data.addAll({
        'stayStartDate': Timestamp.fromDate(_stayRange!.start),
        'stayEndDate': Timestamp.fromDate(_stayRange!.end),
        'stayNights': stayNights,
        'totalPrice': _totalPriceText(stayNights),
      });
      final activeRoom = _activeRoom;
      if (activeRoom != null) {
        data.addAll({
          'roomOption': activeRoom,
          'roomLabel': activeRoom['label']?.toString(),
          'roomCapacity': (activeRoom['capacity'] as num?)?.toInt(),
        });
      }
    }
    if (_isTransport) {
      data.addAll({
        'tripType': _isRoundTrip ? 'round-trip' : 'one-way',
        'isRoundTrip': _isRoundTrip,
        'passengerCount': _passengerCount,
        'totalPrice': _transportTotalPriceText(),
        'transportTickets': _resolvedTransportTickets,
      });
      final returnDate = _returnTicketDate;
      if (returnDate != null) {
        data['returnDate'] = Timestamp.fromDate(returnDate);
      }
    }

    await FirebaseFirestore.instance
        .collection('my_reservations')
        .doc(docId)
        .set(data, SetOptions(merge: true));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text('Added to My Reservations'),
            TextButton(
              onPressed:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyReservationsPage(),
                      ),
                    ),
                  },
              child: Text(
                'Open',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_isAccommodation) {
      final stayNights =
          _stayRange == null ? null : _stayNightCount(_stayRange!);
      final roomPriceText =
          _activeRoom == null ? widget.price : _roomPriceText(_activeRoom!);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _pickStayRange,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.date_range_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _stayRange == null
                          ? 'Select stay dates'
                          : '${_formatDate(_stayRange!.start)} - ${_formatDate(_stayRange!.end)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    stayNights == null
                        ? 'Total: select dates'
                        : 'Total: ${_totalPriceText(stayNights)}',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _book,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Reserve Now'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Nightly price: $roomPriceText',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.86),
            ),
          ),
        ],
      );
    }

    if (_isTransport) {
      final tickets = _resolvedTransportTickets;
      final capacity = _transportCapacity;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...tickets.map(
            (ticket) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TransportTicketSummary(ticket: ticket),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Passengers',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      _passengerCount <= 1
                          ? null
                          : () => setState(() => _passengerCount--),
                  icon: const Icon(Icons.remove_rounded),
                  color: AppColors.white,
                ),
                Text(
                  '$_passengerCount',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed:
                      _passengerCount >= capacity
                          ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Passenger count exceeds remaining capacity.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          : () => setState(() => _passengerCount++),
                  icon: const Icon(Icons.add_rounded),
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Total: ${_transportTotalPriceText()}',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _book,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Reserve Now'),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Price: ${widget.price}',
              style: textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _book,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primary,
          ),
          child: const Text('Reserve Now'),
        ),
      ],
    );
  }

  String _reservationDocId(String userId) {
    final base = '${userId}_${widget.type}_${widget.id}';
    if (_isAccommodation && _stayRange != null) {
      final start = _docDate(_stayRange!.start);
      final end = _docDate(_stayRange!.end);
      final room = _docSafeText(_activeRoomLabel ?? 'stay');
      return '${base}_${start}_${end}_$room';
    }
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    return '$base${_isRoundTrip ? '_round_trip' : ''}_$createdAt';
  }

  String _docDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}$month$day';
  }

  String _docSafeText(String value) {
    final cleaned = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    return cleaned.isEmpty ? 'item' : cleaned;
  }

  int _stayNightCount(DateTimeRange range) {
    final nights = range.end.difference(range.start).inDays;
    return nights < 1 ? 1 : nights;
  }

  String _totalPriceText(int nights) {
    final pricePerNight =
        _activeRoom == null
            ? _firstNumber(widget.price)
            : (_activeRoom!['pricePerNight'] as num?)?.toDouble();
    if (pricePerNight == null) return widget.price;

    final total = pricePerNight * nights;
    final currency =
        _activeRoom?['currency']?.toString() ??
        (widget.price.contains(r'$') ? r'$' : '');
    final totalText =
        total % 1 == 0 ? total.toInt().toString() : total.toStringAsFixed(2);
    return currency.isEmpty ? totalText : '$currency $totalText';
  }

  String _transportTotalPriceText() {
    final tickets = _resolvedTransportTickets;
    if (tickets.isEmpty) return widget.price;

    final total =
        tickets.fold<double>(
          0,
          (total, ticket) => total + _ticketPrice(ticket),
        ) *
        _passengerCount;
    if (total <= 0) return widget.price;

    final currency = tickets.first['currency']?.toString() ?? r'$';
    final totalText =
        total % 1 == 0 ? total.toInt().toString() : total.toStringAsFixed(2);
    return currency.isEmpty ? totalText : '$currency $totalText';
  }

  List<Map<String, dynamic>> get _resolvedTransportTickets {
    final tickets = widget.transportTickets;
    if (tickets != null && tickets.isNotEmpty) return tickets;
    if (!_isTransport) return const [];

    return [
      {
        'id': widget.id,
        'title': widget.title,
        'origin': widget.origin,
        'destination': widget.destination,
        'price': _firstNumber(widget.price) ?? 0,
        'currency': widget.price.contains(r'$') ? r'$' : '',
        'priceText': widget.price,
        'remainingCapacity': widget.remainingCapacity,
        'description': widget.description,
      },
    ];
  }

  DateTime? get _returnTicketDate {
    if (!_isRoundTrip) return null;
    final tickets = _resolvedTransportTickets;
    if (tickets.length < 2) return null;
    return _dateFromTicket(tickets[1]);
  }

  double _ticketPrice(Map<String, dynamic> ticket) {
    final price = ticket['price'];
    if (price is num) return price.toDouble();
    return _firstNumber(ticket['priceText']?.toString() ?? '') ?? 0;
  }

  DateTime? _dateFromTicket(Map<String, dynamic> ticket) {
    final value = ticket['departAt'];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  String _roomPriceText(Map<String, dynamic> room) {
    final price = room['pricePerNight'];
    final currency = room['currency']?.toString() ?? r'$';
    return '$currency $price / night';
  }

  double? _firstNumber(String value) {
    final match = RegExp(r'\d+([.,]\d+)?').firstMatch(value);
    if (match == null) return null;
    return double.tryParse(match.group(0)!.replaceAll(',', '.'));
  }
}

class _TransportTicketSummary extends StatelessWidget {
  const _TransportTicketSummary({required this.ticket});

  final Map<String, dynamic> ticket;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final origin = ticket['origin']?.toString() ?? '';
    final destination = ticket['destination']?.toString() ?? '';
    final title = ticket['title']?.toString() ?? 'Transport';
    final transportNumber =
        ticket['flightNumber']?.toString().isNotEmpty == true
            ? ticket['flightNumber'].toString()
            : ticket['trainNumber']?.toString();
    final priceText =
        ticket['priceText']?.toString() ??
        '${ticket['currency'] ?? r'$'} ${ticket['price'] ?? ''}';
    final departAt = _dateFromTicket(ticket);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.confirmation_number_rounded, color: AppColors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                if (origin.isNotEmpty || destination.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$origin -> $destination',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
                if ((transportNumber ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'No: $transportNumber',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.86),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  departAt == null
                      ? priceText
                      : '$priceText - ${_formatDate(departAt)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _dateFromTicket(Map<String, dynamic> ticket) {
    final value = ticket['departAt'];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

class _SpecItem {
  const _SpecItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedAttractionsSection extends StatelessWidget {
  const _RelatedAttractionsSection({
    required this.destinationId,
    required this.accent,
  });

  final String destinationId;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final repo = FirestoreRepo();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attractions in this destination',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: repo.streamAttractions(destinationId: destinationId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final items =
                  (snapshot.data ?? const [])
                      .map((m) => Attraction.fromMap(m['id'] as String, m))
                      .toList();

              if (items.isEmpty) {
                return const SizedBox.shrink();
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final attraction = items[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  AttractionDetailsPage(attraction: attraction),
                        ),
                      );
                    },
                    child: Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22),
                            ),
                            child: Image.asset(
                              attraction.images.isNotEmpty
                                  ? attraction.images.first.toString()
                                  : 'images/pic12.jpg',
                              height: 118,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attraction.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppColors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  attraction.category,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                              ],
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
        ),
      ],
    );
  }
}

class _DetailsVisuals {
  const _DetailsVisuals({
    required this.pageTitle,
    required this.imagePath,
    required this.gradient,
    required this.accent,
    required this.appBarColor,
  });

  final String pageTitle;
  final String imagePath;
  final LinearGradient gradient;
  final Color accent;
  final Color appBarColor;
}

_DetailsVisuals _visualsFor(String type) {
  if (type == 'accommodation') {
    return const _DetailsVisuals(
      pageTitle: 'Accommodation Details',
      imagePath: 'images/pic10.jpg',
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF7C785), Color(0xFFE49A64), Color(0xFFD26C5B)],
      ),
      accent: Color(0xFFE1A75A),
      appBarColor: Color(0xFFD98B56),
    );
  }
  if (type == 'transport') {
    return const _DetailsVisuals(
      pageTitle: 'Transport Details',
      imagePath: 'images/pic6.jpg',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7ED3E6), Color(0xFF6F9EE8), Color(0xFF4F6DAA)],
      ),
      accent: Color(0xFF76AFC7),
      appBarColor: Color(0xFF567FC8),
    );
  }
  return const _DetailsVisuals(
    pageTitle: 'Tour Details',
    imagePath: 'images/pic11.webp',
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8CDDB8), Color(0xFF5FAF9B), Color(0xFF376B75)],
    ),
    accent: Color(0xFF69BF8F),
    appBarColor: Color(0xFF4F927E),
  );
}
