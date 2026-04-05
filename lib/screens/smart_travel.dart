import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tourism_app/components/click_button.dart';
import 'package:tourism_app/components/input_fields.dart';
import 'package:tourism_app/components/popUp_menu.dart';
import 'package:tourism_app/data/firestore_repo.dart';
import 'package:tourism_app/models/accommodation_model.dart';
import 'package:tourism_app/models/attraction_model.dart';
import 'package:tourism_app/models/destination_model.dart';
import 'package:tourism_app/models/transportation_model.dart';
import 'package:tourism_app/screens/attraction_details.dart';
import 'package:tourism_app/screens/details_page.dart';
import 'package:tourism_app/theme/app_theme.dart';

class SmartTravel extends StatefulWidget {
  const SmartTravel({super.key});

  @override
  State<SmartTravel> createState() => _SmartTravelState();
}

class _SmartTravelState extends State<SmartTravel> {
  final FirestoreRepo _repo = FirestoreRepo();
  final TextEditingController _budgetCtrl = TextEditingController();
  final TextEditingController _durationCtrl = TextEditingController(text: '4');
  final TextEditingController _travelersCtrl = TextEditingController(text: '1');

  String? _selectedOriginId;
  String? _selectedDestinationId;
  bool _showPlan = false;

  late final Stream<List<Map<String, dynamic>>> _destinationsRaw$;
  late final Stream<List<Destination>> _destinations$;

  @override
  void initState() {
    super.initState();
    _destinationsRaw$ = _repo.streamDestinations();
    _destinations$ = _destinationsRaw$.map(
      (list) =>
          list.map((m) => Destination.fromMap(m['id'] as String, m)).toList(),
    );
  }

  @override
  void dispose() {
    _budgetCtrl.dispose();
    _durationCtrl.dispose();
    _travelersCtrl.dispose();
    super.dispose();
  }

  int get _durationDays {
    final parsed = int.tryParse(_durationCtrl.text.trim()) ?? 4;
    return parsed < 1 ? 1 : parsed;
  }

  num? get _budget {
    final parsed = num.tryParse(_budgetCtrl.text.trim());
    return parsed == null || parsed <= 0 ? null : parsed;
  }

  int get _travelers {
    final parsed = int.tryParse(_travelersCtrl.text.trim()) ?? 1;
    return parsed < 1 ? 1 : parsed;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surface,
              AppColors.surfaceStrong.withOpacity(0.78),
            ],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _destinationsRaw$,
            builder: (context, destinationSnapshot) {
              final destinationMaps = destinationSnapshot.data ?? const [];
              Map<String, dynamic>? selectedDestination;
              for (final destination in destinationMaps) {
                if (destination['id'] == _selectedDestinationId) {
                  selectedDestination = destination;
                  break;
                }
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: _hero(textTheme),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _plannerCard(),
                    ),
                  ),
                  if (_showPlan &&
                      _selectedOriginId != null &&
                      _selectedDestinationId != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: _seasonCard(context, selectedDestination),
                      ),
                    ),
                  if (_showPlan &&
                      _selectedOriginId != null &&
                      _selectedDestinationId != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        child: _recommendationSection(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _hero(TextTheme textTheme) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.14),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('images/pic4.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.14),
                    AppColors.ink.withOpacity(0.84),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Smart Travel Planner',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Build a personalized trip with destination-aware timing, stay and transport recommendations, and a total cost estimate.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _plannerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan inputs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            'Choose origin, destination, trip duration, budget, and traveler count to get a recommended travel setup.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 18),
          PopupMenu(
            destinations: _destinations$,
            title: 'Choose origin',
            currentDestId: _selectedOriginId,
            borderRadius: BorderRadius.circular(20),
            hintCoolor: AppColors.muted,
            fontSize: 14,
            googleFont: GoogleFonts.manrope,
            onChanged: (id) {
              setState(() => _selectedOriginId = id);
            },
            onCleared: () {
              setState(() => _selectedOriginId = null);
            },
          ),
          const SizedBox(height: 12),
          PopupMenu(
            destinations: _destinations$,
            title: 'Choose destination',
            currentDestId: _selectedDestinationId,
            borderRadius: BorderRadius.circular(20),
            hintCoolor: AppColors.muted,
            fontSize: 14,
            googleFont: GoogleFonts.manrope,
            onChanged: (id) {
              setState(() => _selectedDestinationId = id);
            },
            onCleared: () {
              setState(() => _selectedDestinationId = null);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InputFields(
                  controller: _budgetCtrl,
                  hint_text: 'Budget (\$)',
                  borderRadius: BorderRadius.circular(20),
                  hintCoolor: AppColors.muted,
                  fontSize: 12,
                  fillColor: AppColors.surfaceStrong.withOpacity(0.72),
                  borderSide: BorderSide.none,
                  keyboardType: TextInputType.number,
                  //icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputFields(
                  controller: _durationCtrl,
                  hint_text: 'Days',
                  borderRadius: BorderRadius.circular(20),
                  hintCoolor: AppColors.muted,
                  fontSize: 14,
                  fillColor: AppColors.surfaceStrong.withOpacity(0.72),
                  borderSide: BorderSide.none,
                  keyboardType: TextInputType.number,
                  //icon: Icons.calendar_month_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputFields(
                  controller: _travelersCtrl,
                  hint_text: 'People',
                  borderRadius: BorderRadius.circular(20),
                  hintCoolor: AppColors.muted,
                  fontSize: 14,
                  fillColor: AppColors.surfaceStrong.withOpacity(0.72),
                  borderSide: BorderSide.none,
                  keyboardType: TextInputType.number,
                  //icon: Icons.groups_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 220,
              child: ClickButton(
                text: 'Generate smart plan',
                isLoading: false,
                onPressed: () {
                  setState(() {
                    _showPlan =
                        _selectedOriginId != null &&
                        _selectedDestinationId != null &&
                        _selectedOriginId != _selectedDestinationId;
                  });
                },
                backgroundColor: AppColors.primary,
              ),
            ),
          ),
          if (_selectedOriginId != null &&
              _selectedDestinationId != null &&
              _selectedOriginId == _selectedDestinationId) ...[
            const SizedBox(height: 10),
            Text(
              'Origin and destination must be different.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFFC85757)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _seasonCard(
    BuildContext context,
    Map<String, dynamic>? selectedDestination,
  ) {
    final seasons =
        ((selectedDestination?['bestSeasons'] ?? const []) as List)
            .map((e) => e.toString())
            .toList();
    final tags =
        ((selectedDestination?['tags'] ?? const []) as List)
            .map((e) => e.toString())
            .toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.92),
            AppColors.secondary.withOpacity(0.88),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best time to travel',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 10),
          Text(
            seasons.isEmpty
                ? 'No seasonal suggestion available for this destination yet.'
                : 'Recommended months: ${seasons.join(', ')}. These months usually fit ${tags.isEmpty ? 'general travel' : tags.join(', ')} experiences best.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationSection() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _repo.streamAccommodations(destinationId: _selectedDestinationId),
      builder: (context, accommodationSnapshot) {
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: _repo.streamTransports(
            fromCode: _selectedOriginId,
            toCode: _selectedDestinationId,
          ),
          builder: (context, transportSnapshot) {
            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: _repo.streamAttractions(
                destinationId: _selectedDestinationId,
              ),
              builder: (context, attractionSnapshot) {
                if (accommodationSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    transportSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    attractionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final accommodations =
                    (accommodationSnapshot.data ?? const [])
                        .map((m) => Accommodation.fromMap(m['id'] as String, m))
                        .toList();
                final transports =
                    (transportSnapshot.data ?? const [])
                        .map((m) => Transport.fromMap(m['id'] as String, m))
                        .toList();
                final attractions =
                    (attractionSnapshot.data ?? const [])
                        .map((m) => Attraction.fromMap(m['id'] as String, m))
                        .toList();

                final accommodation =
                    accommodations.isEmpty
                        ? null
                        : _pickAccommodation(accommodations);
                final transport = transports.isEmpty ? null : transports.first;
                final topAttractions = attractions.take(3).toList();
                final totalCost = _estimateTotalCost(
                  transport: transport,
                  accommodation: accommodation,
                  attractions: topAttractions,
                  durationDays: _durationDays,
                  travelers: _travelers,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended plan',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 14),
                    _RecommendationCard(
                      title: 'Best transportation',
                      subtitle:
                          transport == null
                              ? 'No transport found for this destination.'
                              : '${transport.mode.toUpperCase()} from ${transport.from['city']} to ${transport.to['city']}',
                      meta:
                          transport == null
                              ? null
                              : '\$ ${transport.basePrice} - ${_transportDate(transport)}',
                      icon: Icons.alt_route_rounded,
                      onTap:
                          transport == null
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailsPage(
                                          id: transport.id,
                                          title: transport.mode.toUpperCase(),
                                          type: 'transport',
                                          price:
                                              '\$ ${transport.basePrice} - ${_transportDate(transport)}',
                                          origin:
                                              transport.from['city']
                                                  ?.toString(),
                                          destination:
                                              transport.to['city']?.toString(),
                                          relatedDestinationId:
                                              transport.to['code']?.toString(),
                                        ),
                                  ),
                                );
                              },
                    ),
                    const SizedBox(height: 12),
                    _RecommendationCard(
                      title: 'Best accommodation',
                      subtitle:
                          accommodation == null
                              ? 'No accommodation found for this destination.'
                              : '${accommodation.name} in ${accommodation.destinationName}',
                      meta:
                          accommodation == null
                              ? null
                              : '\$ ${accommodation.pricePerNight} per night - ${accommodation.ratingAvg.toStringAsFixed(1)} rating',
                      icon: Icons.hotel_rounded,
                      onTap:
                          accommodation == null
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailsPage(
                                          id: accommodation.id,
                                          title: accommodation.name,
                                          type: 'accommodation',
                                          price:
                                              '\$ ${accommodation.pricePerNight} - per night',
                                          destination:
                                              accommodation.destinationName,
                                          description:
                                              accommodation.description,
                                          ratingAvg: accommodation.ratingAvg,
                                          relatedDestinationId:
                                              accommodation.destinationId,
                                          maxGuests: accommodation.maxGuests,
                                          bedrooms: accommodation.bedrooms,
                                          beds: accommodation.beds,
                                          bathrooms: accommodation.bathrooms,
                                          amenities: accommodation.amenities,
                                        ),
                                  ),
                                );
                              },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
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
                          Row(
                            children: [
                              const Icon(
                                Icons.place_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Top attractions',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          if (topAttractions.isEmpty)
                            Text(
                              'No attraction data found.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          else
                            ...topAttractions.map(
                              (attraction) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => AttractionDetailsPage(
                                              attraction: attraction,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceStrong
                                          .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                attraction.name,
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.titleMedium,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${attraction.category} - \$ ${attraction.ticketPrice}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.copyWith(
                                                  color: AppColors.muted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color: AppColors.muted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CostCard(
                      durationDays: _durationDays,
                      travelers: _travelers,
                      totalCost: totalCost,
                      budget: _budget,
                      transportCost:
                          (transport?.basePrice.toDouble() ?? 0) * _travelers,
                      accommodationCost:
                          (accommodation?.pricePerNight.toDouble() ?? 0) *
                          _stayNights(_durationDays) *
                          _travelers,
                      attractionCost: topAttractions.fold<double>(
                        0,
                        (sum, item) =>
                            sum + (item.ticketPrice.toDouble() * _travelers),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Accommodation _pickAccommodation(List<Accommodation> accommodations) {
    final nightlyBudget =
        _budget == null ? null : (_budget! / _stayNights(_durationDays));
    final suitableForGuests =
        accommodations.where((a) => a.maxGuests >= _travelers).toList();
    final candidatePool =
        suitableForGuests.isNotEmpty ? suitableForGuests : accommodations;

    final withinBudget =
        nightlyBudget == null
            ? candidatePool
            : candidatePool
                .where((a) => a.pricePerNight <= nightlyBudget)
                .toList();

    final source = withinBudget.isNotEmpty ? withinBudget : candidatePool;
    source.sort((a, b) {
      final aScore = a.ratingAvg / (a.pricePerNight == 0 ? 1 : a.pricePerNight);
      final bScore = b.ratingAvg / (b.pricePerNight == 0 ? 1 : b.pricePerNight);
      return bScore.compareTo(aScore);
    });
    return source.first;
  }

  int _stayNights(int days) => days <= 1 ? 1 : days - 1;

  double _estimateTotalCost({
    required Transport? transport,
    required Accommodation? accommodation,
    required List<Attraction> attractions,
    required int durationDays,
    required int travelers,
  }) {
    final food = durationDays * 25 * travelers;
    final localTransport = durationDays * 10 * travelers;
    final ticketTotal = attractions.fold<double>(
      0,
      (sum, item) => sum + (item.ticketPrice.toDouble() * travelers),
    );
    final stay =
        (accommodation?.pricePerNight.toDouble() ?? 0) *
        _stayNights(durationDays) *
        travelers;
    final route = (transport?.basePrice.toDouble() ?? 0) * travelers;

    return route + stay + ticketTotal + food + localTransport;
  }

  String _transportDate(Transport transport) {
    final departAt = transport.schedule['departAt'];
    if (departAt == null) return 'Flexible';
    return DateFormat('d MMM').format(departAt.toDate());
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.meta,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? meta;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceStrong,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.45),
                  ),
                  if (meta != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      meta!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostCard extends StatelessWidget {
  const _CostCard({
    required this.durationDays,
    required this.travelers,
    required this.totalCost,
    required this.budget,
    required this.transportCost,
    required this.accommodationCost,
    required this.attractionCost,
  });

  final int durationDays;
  final int travelers;
  final double totalCost;
  final num? budget;
  final double transportCost;
  final double accommodationCost;
  final double attractionCost;

  @override
  Widget build(BuildContext context) {
    final foodCost = durationDays * 25 * travelers;
    final localTransportCost = durationDays * 10 * travelers;
    final isOverBudget = budget != null && totalCost > budget!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.ink.withOpacity(0.96),
            AppColors.primary.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated total trip cost',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 12),
          _costRow('Travelers', travelers.toDouble(), valueAsCount: true),
          _costRow('Transportation', transportCost),
          _costRow('Accommodation', accommodationCost),
          _costRow('Attractions', attractionCost),
          _costRow('Food', foodCost.toDouble()),
          _costRow('Local transport', localTransportCost.toDouble()),
          const Divider(color: Color(0x55FFFFFF), height: 28),
          _costRow('Estimated total', totalCost, strong: true),
          if (budget != null) ...[
            const SizedBox(height: 10),
            Text(
              isOverBudget
                  ? 'This plan is about \$ ${(totalCost - budget!).toStringAsFixed(0)} over budget.'
                  : 'This plan stays within budget with about \$ ${(budget! - totalCost).toStringAsFixed(0)} remaining.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isOverBudget ? AppColors.accent : AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _costRow(
    String label,
    double value, {
    bool strong = false,
    bool valueAsCount = false,
  }) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withOpacity(strong ? 1 : 0.88),
                    fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Text(
                valueAsCount
                    ? value.toStringAsFixed(0)
                    : '\$ ${value.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: strong ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
