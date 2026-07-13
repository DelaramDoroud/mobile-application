import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/models/attraction_model.dart';
import 'package:tourism_app/theme/app_theme.dart';
import 'package:tourism_app/widgets/image_slideshow.dart';
import 'package:tourism_app/widgets/user_reviews_section.dart';
import 'package:tourism_app/utils/directions_launcher.dart';

class AttractionDetailsPage extends StatelessWidget {
  const AttractionDetailsPage({super.key, required this.attraction});

  final Attraction attraction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 92, 142, 130),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppColors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color.fromARGB(255, 92, 142, 130),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                start: 18,
                bottom: 86,
                end: 18,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ImageSlideshow(
                    imagePaths: attraction.images,
                    fallbackImagePath: 'images/pic12.jpg',
                    height: 280,
                    borderRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attraction.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(label: attraction.destinationName),
                      _InfoChip(label: attraction.category.toUpperCase()),
                      _InfoChip(label: '\$ ${attraction.ticketPrice} ticket'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          attraction.address.isEmpty
                              ? attraction.destinationName
                              : attraction.address,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        attraction.openHours.isEmpty
                            ? 'Hours not available'
                            : attraction.openHours,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About this attraction',
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          attraction.description,
                          style: textTheme.bodyLarge?.copyWith(height: 1.55),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _MapDirectionsCard(attraction: attraction),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.92),
                          AppColors.secondary.withValues(alpha: 0.85),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Visitor rating',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white.withValues(
                                    alpha: 0.86,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                attraction.ratingAvg.toStringAsFixed(1),
                                style: textTheme.headlineMedium?.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < attraction.ratingAvg.floor()
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: UserReviewsSection(
                      targetId: attraction.id,
                      targetType: 'attraction',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapDirectionsCard extends StatelessWidget {
  const _MapDirectionsCard({required this.attraction});

  final Attraction attraction;

  @override
  Widget build(BuildContext context) {
    final lat = attraction.latitude;
    final lng = attraction.longitude;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: textTheme.titleLarge),
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
                  attraction.address.isEmpty
                      ? attraction.destinationName
                      : attraction.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
