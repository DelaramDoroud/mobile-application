import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/components/popUp_menu.dart';
import 'package:tourism_app/data/firestore_repo.dart';
import 'package:tourism_app/models/attraction_model.dart';
import 'package:tourism_app/models/destination_model.dart';
import 'package:tourism_app/screens/attraction_details.dart';
import 'package:tourism_app/theme/app_theme.dart';

class Attractions extends StatefulWidget {
  const Attractions({super.key});

  @override
  State<Attractions> createState() => _AttractionsState();
}

class _AttractionsState extends State<Attractions> {
  final FirestoreRepo _repo = FirestoreRepo();

  String? _selectedDestinationId;
  String? _selectedCategory;
  late Stream<List<Attraction>> _attractions$;
  late Stream<List<Destination>> _destinations$;

  final List<String> _categories = ['nature', 'culture', 'history'];

  @override
  void initState() {
    super.initState();
    _destinations$ = _repo.streamDestinations().map(
      (list) =>
          list.map((m) => Destination.fromMap(m['id'] as String, m)).toList(),
    );
    _refreshAttractions();
  }

  void _refreshAttractions() {
    _attractions$ = _repo
        .streamAttractions(
          destinationId: _selectedDestinationId,
          category: _selectedCategory,
        )
        .map(
          (list) =>
              list.map((m) => Attraction.fromMap(m['id'] as String, m)).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tourist Attractions')),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface, AppColors.surfaceStrong.withOpacity(0.75)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.94),
                      AppColors.secondary.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore by destination',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Every attraction shown here belongs to one of the app destinations.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.88),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PopupMenu(
                  destinations: _destinations$,
                  title: 'Choose destination',
                  currentDestId: _selectedDestinationId,
                  borderRadius: BorderRadius.circular(20),
                  hintCoolor: AppColors.muted,
                  fontSize: 14,
                  googleFont: GoogleFonts.manrope,
                  onChanged: (id) {
                    setState(() {
                      _selectedDestinationId = id;
                      _refreshAttractions();
                    });
                  },
                  onCleared: () {
                    setState(() {
                      _selectedDestinationId = null;
                      _refreshAttractions();
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 46,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                      label: 'Any type',
                      selected: _selectedCategory == null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = null;
                          _refreshAttractions();
                        });
                      },
                    ),
                    ..._categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _FilterChip(
                          label: category,
                          selected: _selectedCategory == category,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                              _refreshAttractions();
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<List<Attraction>>(
                  stream: _attractions$,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final attractions = snapshot.data ?? const <Attraction>[];
                    if (attractions.isEmpty) {
                      return Center(
                        child: Text(
                          'No attractions found',
                          style: textTheme.titleMedium,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      itemCount: attractions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final attraction = attractions[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AttractionDetailsPage(attraction: attraction),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                  child: Image.asset(
                                    'images/pic12.jpg',
                                    height: 170,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _MiniTag(label: attraction.destinationName),
                                          _MiniTag(label: attraction.category),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        attraction.name,
                                        style: textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        attraction.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.muted,
                                          height: 1.45,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: AppColors.accent,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${attraction.ratingAvg.toStringAsFixed(1)} (${attraction.ratingCount})',
                                            style: textTheme.bodyMedium,
                                          ),
                                          const Spacer(),
                                          Text(
                                            '\$ ${attraction.ticketPrice}',
                                            style: textTheme.titleMedium?.copyWith(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
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
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color:
                selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.08),
          ),
        ),
        child: Center(
          child: Text(
            label[0].toUpperCase() + label.substring(1),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selected ? AppColors.white : AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
