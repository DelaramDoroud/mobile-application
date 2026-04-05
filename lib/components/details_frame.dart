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
    this.origin,
    this.destination,
    this.description,
    this.ratingAvg,
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
  final String? origin;
  final String? destination;
  final String? description;
  final double? ratingAvg;
  final String price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final routeText = [
      if ((origin ?? '').isNotEmpty) origin,
      if ((destination ?? '').isNotEmpty) destination,
    ].whereType<String>().join(' -> ');

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              id: id,
              title: title,
              type: type,
              relatedDestinationId: relatedDestinationId,
              maxGuests: maxGuests,
              bedrooms: bedrooms,
              beds: beds,
              bathrooms: bathrooms,
              amenities: amenities,
              origin: origin,
              destination: destination,
              description: description,
              price: price,
              ratingAvg: ratingAvg,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.94), color.withOpacity(0.74)],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.22),
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
                height: 110,
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
                            color: AppColors.ink.withOpacity(0.78),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.7),
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
}
