import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/data/firestore_repo.dart';
import 'package:tourism_app/models/attraction_model.dart';
import 'package:tourism_app/screens/attraction_details.dart';
import 'package:tourism_app/theme/app_theme.dart';
import 'package:tourism_app/widgets/user_reviews_section.dart';

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
    this.relatedDestinationId,
    this.maxGuests,
    this.bedrooms,
    this.beds,
    this.bathrooms,
    this.amenities,
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
  final int? maxGuests;
  final int? bedrooms;
  final int? beds;
  final int? bathrooms;
  final List<dynamic>? amenities;

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
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                        _accommodationSpecsCard(context),
                      if (_showAccommodationSpecs) const SizedBox(height: 16),
                      if ((description ?? '').isNotEmpty)
                        _descriptionCard(context),
                      if ((description ?? '').isNotEmpty)
                        const SizedBox(height: 16),
                      _ctaRow(context),
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
                          color: Colors.white.withOpacity(0.14),
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

  Widget _heroCard(BuildContext context, _DetailsVisuals visual) {
    final textTheme = Theme.of(context).textTheme;
    final routeText = [
      if ((origin ?? '').isNotEmpty) origin,
      if ((destination ?? '').isNotEmpty) destination,
    ].join(type == 'transport' ? ' -> ' : '\n');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
            child: Image.asset(
              visual.imagePath,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
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
          if (ratingAvg != null)
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < ratingAvg!.round()
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  ratingAvg!.toStringAsFixed(1),
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.white),
                ),
              ],
            ),
          if (ratingAvg != null) const SizedBox(height: 10),
          if (routeText.trim().isNotEmpty)
            Text(
              routeText,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _descriptionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
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
              color: AppColors.white.withOpacity(0.92),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Price: $price',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please log in first')),
              );
              return;
            }
            final docId = '${user.uid}_${type}_$id';
            await FirebaseFirestore.instance
                .collection('my_reservations')
                .doc(docId)
                .set({
                  'userId': user.uid,
                  'targetId': id,
                  'targetType': type,
                  'title': title,
                  'price': price,
                  'origin': origin,
                  'destination': destination,
                  'description': description,
                  'ratingAvg': ratingAvg,
                  'relatedDestinationId': relatedDestinationId,
                  'maxGuests': maxGuests,
                  'bedrooms': bedrooms,
                  'beds': beds,
                  'bathrooms': bathrooms,
                  'amenities': amenities,
                  'createdAt': FieldValue.serverTimestamp(),
                }, SetOptions(merge: true));

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to My Reservations!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primary,
          ),
          child: const Text('Book Now'),
        ),
      ],
    );
  }

  Widget _accommodationSpecsCard(BuildContext context) {
    final info = [
      _SpecItem(
        label: 'Max guests',
        value: (maxGuests ?? 0) > 0 ? '${maxGuests!}' : '-',
        icon: Icons.groups_rounded,
      ),
      _SpecItem(
        label: 'Bedrooms',
        value: (bedrooms ?? 0) > 0 ? '${bedrooms!}' : '-',
        icon: Icons.bedroom_parent_rounded,
      ),
      _SpecItem(
        label: 'Beds',
        value: (beds ?? 0) > 0 ? '${beds!}' : '-',
        icon: Icons.bed_rounded,
      ),
      _SpecItem(
        label: 'Bathrooms',
        value: (bathrooms ?? 0) > 0 ? '${bathrooms!}' : '-',
        icon: Icons.bathtub_rounded,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.white),
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
                  color: Colors.white.withOpacity(0.14),
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.white.withOpacity(0.78),
                            ),
                          ),
                          Text(
                            item.value,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if ((amenities ?? const []).isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Amenities',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  (amenities ?? const [])
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
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
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: accent.withOpacity(0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22),
                            ),
                            child: Image.asset(
                              'images/pic12.jpg',
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
                                    color: AppColors.white.withOpacity(0.8),
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
  });

  final String pageTitle;
  final String imagePath;
  final LinearGradient gradient;
  final Color accent;
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
  );
}
