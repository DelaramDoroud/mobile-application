import 'package:flutter/material.dart';
import 'package:tourism_app/screens/details_page.dart';

import '../theme/app_theme.dart';

class DetailsFrame extends StatelessWidget {
  const DetailsFrame({
    super.key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.type,
    this.relatedDestinationId,
    this.maxGuests,
    this.bedrooms,
    this.beds,
    this.bathrooms,
    this.amenities,
    this.roomOptions,
    this.origin,
    this.destination,
    this.description,
    this.ratingAvg,
    this.itemTypeLabel,
    this.tripScope,
    this.tourDurationDays,
    this.remainingCapacity,
    this.gearSuggestions,
    this.images,
    this.address,
    this.latitude,
    this.longitude,
    this.roundTrip = false,
    this.returnDate,
    this.onTap,
    required this.price,
    required this.color,
  });

  final String id;
  final String imagePath;
  final String title;
  final String type;
  final String? relatedDestinationId;
  final int? maxGuests;
  final int? bedrooms;
  final int? beds;
  final int? bathrooms;
  final List<dynamic>? amenities;
  final List<Map<String, dynamic>>? roomOptions;
  final String? origin;
  final String? destination;
  final String? description;
  final double? ratingAvg;
  final String? itemTypeLabel;
  final String? tripScope;
  final int? tourDurationDays;
  final int? remainingCapacity;
  final List<dynamic>? gearSuggestions;
  final List<dynamic>? images;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool roundTrip;
  final DateTime? returnDate;
  final VoidCallback? onTap;
  final String price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final detailImages =
        (images ?? const []).isNotEmpty ? images : <dynamic>[imagePath];
    final routeText = [
      if ((origin ?? '').isNotEmpty) origin,
      if ((destination ?? '').isNotEmpty) destination,
    ].whereType<String>().join(' -> ');

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            constraints.hasBoundedWidth
                ? double.infinity
                : MediaQuery.of(context).size.width * 0.8;

        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (onTap != null) {
              onTap!();
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DetailsPage(
                      id: id,
                      title: title,
                      type: type,
                      relatedDestinationId: relatedDestinationId,
                      maxGuests: maxGuests,
                      bedrooms: bedrooms,
                      beds: beds,
                      bathrooms: bathrooms,
                      amenities: amenities,
                      roomOptions: roomOptions,
                      origin: origin,
                      destination: destination,
                      description: description,
                      itemTypeLabel: itemTypeLabel,
                      tripScope: tripScope,
                      tourDurationDays: tourDurationDays,
                      remainingCapacity: remainingCapacity,
                      gearSuggestions: gearSuggestions,
                      images: detailImages,
                      address: address,
                      latitude: latitude,
                      longitude: longitude,
                      roundTrip: roundTrip,
                      returnDate: returnDate,
                      price: price,
                      ratingAvg: ratingAvg,
                    ),
              ),
            );
          },
          child: Container(
            width: cardWidth,
            // height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.94),
                  color.withValues(alpha: 0.74),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: AssetImage(imagePath),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: AppColors.ink,
                            ),
                          ),

                          if (routeText.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              routeText,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.ink.withValues(alpha: 0.78),
                              ),
                            ),
                          ],
                          const Spacer(),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 9,
                                  ),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    price,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              if ((itemTypeLabel ?? '').isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Flexible(
                                  child: _TypeBadge(label: itemTypeLabel!),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
