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
  String? _neededRoom;

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
              AppColors.surfaceStrong.withValues(alpha: 0.78),
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
            color: AppColors.primary.withValues(alpha: 0.14),
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
                    Colors.black.withValues(alpha: 0.14),
                    AppColors.ink.withValues(alpha: 0.84),
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
                      color: AppColors.white.withValues(alpha: 0.9),
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
            color: Colors.black.withValues(alpha: 0.06),
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
                  decoration: _smartNumberFieldDecoration('Budget (\$)'),
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
                  decoration: _smartNumberFieldDecoration('Days'),
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
                  decoration: _smartNumberFieldDecoration('People'),
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
            AppColors.primary.withValues(alpha: 0.92),
            AppColors.secondary.withValues(alpha: 0.88),
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
              color: AppColors.white.withValues(alpha: 0.9),
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
                final transport =
                    transports.isEmpty ? null : _pickTransport(transports);
                final topAttractions = attractions.take(3).toList();
                final totalCost = _estimateTotalCost(
                  transport: transport,
                  accommodation: accommodation,
                  attractions: topAttractions,
                  durationDays: _durationDays,
                  travelers: _travelers,
                );
                final transportPriceText =
                    transport == null
                        ? null
                        : '${transport.currency == 'USD' ? r'$' : transport.currency} ${transport.basePrice}';
                final accommodationPriceText =
                    accommodation == null
                        ? null
                        : '${accommodation.currency == 'USD' ? r'$' : accommodation.currency} ${accommodation.pricePerNight}';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended plan',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 14),
                    _RecommendationCard(
                      label: 'Best transportation',
                      title:
                          transport == null
                              ? 'No transport found'
                              : '${transport.mode.toUpperCase()} to ${transport.to['city']}',
                      subtitle:
                          transport == null
                              ? 'No transport found for this destination.'
                              : '${transport.from['city']} to ${transport.to['city']} with ${transport.company.isEmpty ? 'local partner' : transport.company}',
                      meta:
                          transport == null ? null : _transportDate(transport),
                      price: transportPriceText,
                      imagePath: _firstImage(
                        transport?.images,
                        'images/pic6.jpg',
                      ),
                      actionText: 'View details and book',
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
                                              '$transportPriceText - ${_transportDate(transport)}',
                                          origin:
                                              transport.from['city']
                                                  ?.toString(),
                                          destination:
                                              transport.to['city']?.toString(),
                                          relatedDestinationId:
                                              transport.to['code']?.toString(),
                                          remainingCapacity:
                                              transport.remainingCapacity,
                                          description:
                                              '${_vehicleDisplayName(transport.mode)} ticket operated by ${transport.company.isEmpty ? 'local partner' : transport.company}.',
                                          images: transport.images,
                                          transportTickets: [
                                            _transportTicketMap(transport),
                                          ],
                                        ),
                                  ),
                                );
                              },
                    ),
                    const SizedBox(height: 12),
                    _RecommendationCard(
                      label: 'Best accommodation',
                      title:
                          accommodation == null
                              ? 'No accommodation found'
                              : accommodation.name,
                      subtitle:
                          accommodation == null
                              ? 'No accommodation found for this destination.'
                              : '${_displayType(accommodation.type)} in ${accommodation.destinationName} - up to ${accommodation.maxGuests} guests',
                      meta:
                          accommodation == null
                              ? null
                              : '${accommodation.ratingAvg.toStringAsFixed(1)} rating',
                      price:
                          accommodationPriceText == null
                              ? null
                              : '$accommodationPriceText / night',
                      imagePath: _firstImage(
                        accommodation?.images,
                        'images/pic8.jpg',
                      ),
                      actionText: 'View details and book',
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
                                              '$accommodationPriceText - per night',
                                          destination:
                                              accommodation.destinationName,
                                          description:
                                              accommodation.description,
                                          ratingAvg: accommodation.ratingAvg,
                                          itemTypeLabel: _displayType(
                                            accommodation.type,
                                          ),
                                          relatedDestinationId:
                                              accommodation.destinationId,
                                          maxGuests: accommodation.maxGuests,
                                          bedrooms: accommodation.bedrooms,
                                          beds: accommodation.beds,
                                          bathrooms: accommodation.bathrooms,
                                          amenities: accommodation.amenities,
                                          roomOptions:
                                              accommodation.roomOptions,
                                          images: accommodation.images,
                                          address: accommodation.address,
                                          latitude: accommodation.latitude,
                                          longitude: accommodation.longitude,
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
                            color: Colors.black.withValues(alpha: 0.05),
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
                                      color: AppColors.surfaceStrong.withValues(
                                        alpha: 0.7,
                                      ),
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
                      accommodationUnits: _accommodationUnits(
                        accommodation,
                        _travelers,
                      ),
                      accommodationCost: _estimateAccommodationCost(
                        accommodation,
                        _durationDays,
                        _travelers,
                      ),
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
    final accommodationBudget = _budget == null ? null : _budget! * 0.45;
    final nightlyBudget =
        accommodationBudget == null
            ? null
            : (accommodationBudget / _stayNights(_durationDays));
    // final rooms = accommodations
    final suitableForGuests =
        accommodations
            .where(
              (a) =>
                  a.type.toLowerCase() == 'hotel'
                      ? a.roomOptions.any(
                        (room) => room['maxGuests'] >= _travelers,
                      )
                      : a.maxGuests >= _travelers,
            )
            .toList();
    final candidatePool =
        suitableForGuests.isNotEmpty ? suitableForGuests : accommodations;

    final withinBudget =
        nightlyBudget == null
            ? candidatePool
            : candidatePool
                .where(
                  (a) =>
                      a.pricePerNight * _accommodationUnits(a, _travelers) <=
                      nightlyBudget,
                )
                .toList();

    final source = withinBudget.isNotEmpty ? withinBudget : candidatePool;
    source.sort((a, b) {
      final aScore = a.ratingAvg / (a.pricePerNight == 0 ? 1 : a.pricePerNight);
      final bScore = b.ratingAvg / (b.pricePerNight == 0 ? 1 : b.pricePerNight);
      return bScore.compareTo(aScore);
    });
    return source.first;
  }

  Transport? _pickTransport(List<Transport> transports) {
    final transportBudget = _budget == null ? null : _budget! * 0.25;
    final suitableForTravelers =
        transports.where((t) => t.remainingCapacity >= _travelers).toList();
    final candidatePool =
        suitableForTravelers.isNotEmpty ? suitableForTravelers : transports;
    final withinBudget =
        transportBudget == null
            ? candidatePool
            : candidatePool
                .where((t) => t.basePrice * _travelers <= transportBudget)
                .toList();
    final source = withinBudget.isNotEmpty ? withinBudget : candidatePool;
    source.sort((a, b) {
      final aScore = a.basePrice == 0 ? 1 : a.basePrice;
      final bScore = b.basePrice == 0 ? 1 : b.basePrice;
      return bScore.compareTo(aScore);
    });
    return source.first;
  }

  int _stayNights(int days) => days <= 1 ? 1 : days - 1;

  InputDecoration _smartNumberFieldDecoration(String label) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.12)),
    );

    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: GoogleFonts.manrope(
        color: AppColors.muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      floatingLabelStyle: GoogleFonts.manrope(
        color: AppColors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
      filled: true,
      fillColor: AppColors.surfaceStrong.withValues(alpha: 0.72),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }

  int _accommodationUnits(Accommodation? accommodation, int travelers) {
    if (accommodation == null) return 0;
    if (accommodation.type.toLowerCase() == 'hotel') {
      final bestRoom = _bestRoomOptionFor(accommodation, travelers);
      if (bestRoom != null) {
        return bestRoom['neededRooms'] as int;
      }
    }
    final capacity = accommodation.maxGuests < 1 ? 1 : accommodation.maxGuests;
    return (travelers / capacity).ceil();
  }

  Map<String, dynamic>? _bestRoomOptionFor(
    Accommodation accommodation,
    int travelers,
  ) {
    if (accommodation.roomOptions.isEmpty) return null;

    final candidates =
        accommodation.roomOptions
            .map((room) {
              final maxGuests = (room['maxGuests'] as num?)?.toInt() ?? 0;
              final rooms = (room['rooms'] as num?)?.toInt() ?? 0;
              final price = (room['pricePerNight'] as num?)?.toDouble() ?? 0;

              if (maxGuests < 1 || rooms < 1) return null;

              final neededRooms = (travelers / maxGuests).ceil();
              if (neededRooms > rooms) return null;

              return {
                'room': room,
                'neededRooms': neededRooms,
                'totalNightlyPrice': neededRooms * price,
              };
            })
            .whereType<Map<String, dynamic>>()
            .toList();

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final aPrice = a['totalNightlyPrice'] as double;
      final bPrice = b['totalNightlyPrice'] as double;
      return aPrice.compareTo(bPrice);
    });
    _neededRoom = candidates.first['room']['pricePerNight']?.toString();
    return candidates.first;
  }

  double _estimateAccommodationCost(
    Accommodation? accommodation,
    int durationDays,
    int travelers,
  ) {
    if (accommodation == null) return 0;
    return accommodation.type.toLowerCase() == 'hotel'
        ? (double.tryParse(_neededRoom ?? '0') ?? 0)
        : accommodation.pricePerNight.toDouble() *
            _stayNights(durationDays) *
            _accommodationUnits(accommodation, travelers);
  }

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
    final stay = _estimateAccommodationCost(
      accommodation,
      durationDays,
      travelers,
    );
    final route = (transport?.basePrice.toDouble() ?? 0) * travelers;

    return route + stay + ticketTotal + food + localTransport;
  }

  String _transportDate(Transport transport) {
    final departAt = transport.schedule['departAt'];
    if (departAt == null) return 'Flexible';
    if (departAt is DateTime) return DateFormat('d MMM').format(departAt);
    return DateFormat('d MMM').format(departAt.toDate());
  }

  DateTime? _transportDateTime(Transport transport) {
    final departAt = transport.schedule['departAt'];
    if (departAt == null) return null;
    if (departAt is DateTime) return departAt;
    return departAt.toDate();
  }

  Map<String, dynamic> _transportTicketMap(Transport transport) {
    final date = _transportDateTime(transport);
    final currency = transport.currency == 'USD' ? r'$' : transport.currency;
    return {
      'id': transport.id,
      'title': transport.mode.toUpperCase(),
      'mode': transport.mode,
      'company': transport.company,
      'flightNumber': transport.flightNumber,
      'trainNumber': transport.trainNumber,
      'origin': transport.from['city']?.toString(),
      'destination': transport.to['city']?.toString(),
      'relatedDestinationId': transport.to['code']?.toString(),
      'price': transport.basePrice,
      'currency': currency,
      'priceText': '$currency ${transport.basePrice}',
      'departAt': date,
      'remainingCapacity': transport.remainingCapacity,
      'description':
          '${_vehicleDisplayName(transport.mode)} ticket operated by ${transport.company.isEmpty ? 'local partner' : transport.company}.',
      'images': transport.images,
    };
  }

  String _vehicleDisplayName(String mode) {
    switch (mode.toLowerCase()) {
      case 'flight':
        return 'Flight';
      case 'train':
        return 'Train';
      case 'bus':
        return 'Bus';
      case 'ship':
      case 'ferry':
        return 'Ferry';
      default:
        return _displayType(mode.isEmpty ? 'transport' : mode);
    }
  }
}

String _firstImage(List<dynamic>? images, String fallback) {
  final paths =
      (images ?? const [])
          .map((path) => path.toString())
          .where((path) => path.trim().isNotEmpty)
          .toList();
  return paths.isEmpty ? fallback : paths.first;
}

String _displayType(String value) {
  if (value.isEmpty) return '';
  return value
      .split(RegExp(r'[-_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imagePath,
    this.meta,
    this.price,
    this.actionText,
    this.onTap,
  });

  final String label;
  final String title;
  final String subtitle;
  final String? meta;
  final String? price;
  final String? actionText;
  final String imagePath;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  imagePath,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 170,
                        color: AppColors.surfaceStrong,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          color: AppColors.muted,
                        ),
                      ),
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ink.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 18, color: AppColors.white),
                        const SizedBox(width: 7),
                        Text(
                          label,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.78),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (price != null)
                        _RecommendationChip(
                          icon: Icons.payments_rounded,
                          label: price!,
                          strong: true,
                        ),
                      if (meta != null)
                        _RecommendationChip(
                          icon: Icons.event_available_rounded,
                          label: meta!,
                        ),
                    ],
                  ),
                  if (onTap != null && actionText != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            actionText!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                        ),
                      ],
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

class _RecommendationChip extends StatelessWidget {
  const _RecommendationChip({
    required this.icon,
    required this.label,
    this.strong = false,
  });

  final IconData icon;
  final String label;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color:
            strong
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: strong ? AppColors.primary : AppColors.muted,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: strong ? AppColors.primary : AppColors.ink,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ],
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
    required this.accommodationUnits,
    required this.accommodationCost,
    required this.attractionCost,
  });

  final int durationDays;
  final int travelers;
  final double totalCost;
  final num? budget;
  final double transportCost;
  final int accommodationUnits;
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
            AppColors.ink.withValues(alpha: 0.96),
            AppColors.primary.withValues(alpha: 0.9),
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
          if (accommodationUnits > 1)
            _costRow(
              'Accommodation units',
              accommodationUnits.toDouble(),
              valueAsCount: true,
            ),
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
                    color: AppColors.white.withValues(alpha: strong ? 1 : 0.88),
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
