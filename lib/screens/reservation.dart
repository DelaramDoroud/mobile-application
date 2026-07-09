import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tourism_app/components/date_fields.dart';
import 'package:tourism_app/components/details_frame.dart';
import 'package:tourism_app/components/popUp_menu.dart';
import 'package:tourism_app/data/firestore_repo.dart';
import 'package:tourism_app/models/destination_model.dart';
import 'package:tourism_app/models/tour_model.dart';
import 'package:tourism_app/models/transportation_model.dart';
import 'package:tourism_app/screens/details_page.dart';

import '../models/accommodation_model.dart';
import '../theme/app_theme.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({
    super.key,
    required this.accomodations,
    required this.transport,
  });

  final bool accomodations;
  final bool transport;

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  final _repo = FirestoreRepo();
  final _menuKey = GlobalKey<PopupMenuButtonState<String>>();

  static const String _initialSort = 'Sort by';

  String? _selectedDestinationId;
  String? _selectedOriginId;
  DateTime? _departureDate;
  DateTime? _returnDate;
  bool _roundTrip = false;
  Transport? _selectedOutboundTransport;
  Transport? _selectedReturnTransport;
  late final List<bool> _selectedChips;
  final List<String> _selectedType = [];

  final List<IconData> _vehicles = [
    Icons.directions_bus,
    Icons.train,
    Icons.flight,
    Icons.local_taxi,
  ];
  final List<String> _accomodations = [
    'Hotel',
    'Guesthouse',
    'Apartment',
    'Eco Lodge',
  ];
  final List<String> _tours = [
    'Nature',
    'City',
    'Culture',
    'History',
    'Adventure',
  ];
  final List<String> _sortOptions = ['Price', 'Date'];

  late bool _isAccomodation;
  late bool _isTransport;
  late Stream<List<Accommodation>> _accItems$;
  late Stream<List<Transport>> _trItems$;
  late Stream<List<Transport>> _returnTrItems$;
  late Stream<List<Tour>> _tourItems$;
  late Stream<List<Destination>> _destItems$;
  late String _currentSort;

  @override
  void initState() {
    super.initState();
    _isAccomodation = widget.accomodations;
    _isTransport = widget.transport;
    _selectedChips = List<bool>.filled(_activeFilterCount, false);
    _currentSort = _initialSort;

    _destItems$ = _repo.streamDestinations().map(
      (list) =>
          list.map((m) => Destination.fromMap(m['id'] as String, m)).toList(),
    );
    _accItems$ = _repo
        .streamAccommodations(sortBy: 'price')
        .map(
          (list) =>
              list
                  .map((m) => Accommodation.fromMap(m['id'] as String, m))
                  .toList(),
        );
    _trItems$ = _repo.streamTransports().map(
      (list) =>
          list.map((m) => Transport.fromMap(m['id'] as String, m)).toList(),
    );
    _returnTrItems$ = _repo.streamTransports().map(
      (list) =>
          list.map((m) => Transport.fromMap(m['id'] as String, m)).toList(),
    );
    _tourItems$ = _repo.streamTours().map(
      (list) => list.map((m) => Tour.fromMap(m['id'] as String, m)).toList(),
    );
  }

  void _openMenu() {
    _menuKey.currentState?.showButtonMenu();
  }

  Future<void> onSearch() async {
    final destId = _selectedDestinationId;
    final fromId = _selectedOriginId;
    final types = _selectedType;
    final startDate = _departureDate;
    final returnDate = _returnDate;

    setState(() {
      _selectedOutboundTransport = null;
      _selectedReturnTransport = null;

      _accItems$ = _repo
          .streamAccommodations(
            destinationId: destId,
            types: _isAccomodation && types.isNotEmpty ? types : null,
            startDate: startDate,
            sortBy: 'price',
          )
          .map(
            (list) =>
                list
                    .map((m) => Accommodation.fromMap(m['id'] as String, m))
                    .toList(),
          );

      _trItems$ = _repo
          .streamTransports(
            fromCode: fromId,
            toCode: destId,
            modes: _isTransport && types.isNotEmpty ? types : null,
            startDate: startDate,
            sortBy: _currentSort == 'Price' ? 'basePrice' : 'date',
          )
          .map(
            (list) =>
                list
                    .map((m) => Transport.fromMap(m['id'] as String, m))
                    .toList(),
          );

      _returnTrItems$ = _repo
          .streamTransports(
            fromCode: destId,
            toCode: fromId,
            modes: _isTransport && types.isNotEmpty ? types : null,
            startDate: returnDate,
            sortBy: _currentSort == 'Price' ? 'basePrice' : 'date',
          )
          .map(
            (list) =>
                list
                    .map((m) => Transport.fromMap(m['id'] as String, m))
                    .toList(),
          );

      _tourItems$ = _repo
          .streamTours(
            destinationId: destId,
            originId: fromId,
            types:
                (!_isAccomodation && !_isTransport && types.isNotEmpty)
                    ? types
                    : null,
            startDate: startDate,
            sortBy: _currentSort == 'Date' ? 'date' : 'price',
          )
          .map(
            (list) =>
                list.map((m) => Tour.fromMap(m['id'] as String, m)).toList(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = _pageVisuals;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [mode.pageTint, AppColors.surface],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(mode)),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildFilterPanel(mode),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _resultSortBar(context, mode),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
              _resultsSliver(context),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  _ReservationVisuals get _pageVisuals {
    if (_isAccomodation) {
      return const _ReservationVisuals(
        title: 'Accommodation',
        subtitle: 'Find stays that feel warm, clean, and easy to compare.',
        imagePath: 'images/pic8.jpg',
        accent: Color(0xFFE1A75A),
        darkAccent: Color(0xFF915D24),
        pageTint: Color(0xFFFFF4E7),
      );
    }
    if (_isTransport) {
      return const _ReservationVisuals(
        title: 'Transportation',
        subtitle: 'Compare routes and travel times with simpler filters.',
        imagePath: 'images/pic6.jpg',
        accent: Color(0xFF76AFC7),
        darkAccent: Color(0xFF1F5D78),
        pageTint: Color(0xFFEFF7FB),
      );
    }
    return const _ReservationVisuals(
      title: 'Different Tours',
      subtitle: 'Browse themed experiences with clearer categories.',
      imagePath: 'images/pic11.webp',
      accent: Color(0xFF69BF8F),
      darkAccent: Color(0xFF226B42),
      pageTint: Color(0xFFEFF8F1),
    );
  }

  Widget _buildHero(_ReservationVisuals mode) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: Image.asset(mode.imagePath, fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  mode.darkAccent.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  mode.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 330,
                  child: Text(
                    mode.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(_ReservationVisuals mode) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: mode.accent.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _filterPanelTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            _filterPanelSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_activeFilterCount, (index) {
              final selected = _selectedChips[index];
              final label = _filterLabel(index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedChips[index] = !_selectedChips[index];
                    final type = _filterValue(index);
                    if (_selectedChips[index]) {
                      if (!_selectedType.contains(type)) {
                        _selectedType.add(type);
                      }
                    } else {
                      _selectedType.remove(type);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        selected
                            ? mode.accent.withValues(alpha: 0.18)
                            : AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color:
                          selected
                              ? mode.darkAccent.withValues(alpha: 0.35)
                              : AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                  child:
                      _isTransport
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _vehicles[index],
                                size: 18,
                                color:
                                    selected
                                        ? mode.darkAccent
                                        : AppColors.muted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                label,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color:
                                      selected
                                          ? mode.darkAccent
                                          : AppColors.ink,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            label,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: selected ? mode.darkAccent : AppColors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              if (_isTransport)
                Expanded(
                  child: PopupMenu(
                    destinations: _destItems$,
                    title: 'Select origin',
                    currentDestId: _selectedOriginId,
                    borderRadius: BorderRadius.circular(18),
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
                ),
              if (_isTransport) const SizedBox(width: 12),
              Expanded(
                child: PopupMenu(
                  destinations: _destItems$,
                  title: _isAccomodation ? 'Choose destination' : 'Select City',
                  currentDestId: _selectedDestinationId,
                  borderRadius: BorderRadius.circular(18),
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          _isAccomodation
              ? const SizedBox.shrink()
              : Column(
                children: [
                  DateFields(
                    hint_text: 'Departure date',
                    onDateSelected: (d) => setState(() => _departureDate = d),
                    onCleared: () => setState(() => _departureDate = null),
                  ),
                  if (_isTransport) ...[
                    const SizedBox(height: 12),
                    _RoundTripSelector(
                      enabled: _roundTrip,
                      accent: mode.accent,
                      darkAccent: mode.darkAccent,
                      returnDate: _returnDate,
                      onEnabledChanged: (value) {
                        setState(() {
                          _roundTrip = value;
                          _selectedOutboundTransport = null;
                          _selectedReturnTransport = null;
                          if (!value) _returnDate = null;
                        });
                        onSearch();
                      },
                      onReturnDateSelected: (date) {
                        setState(() => _returnDate = date);
                        onSearch();
                      },
                      onReturnDateCleared: () {
                        setState(() => _returnDate = null);
                        onSearch();
                      },
                    ),
                  ],
                ],
              ),
        ],
      ),
    );
  }

  int get _activeFilterCount {
    if (_isAccomodation) return _accomodations.length;
    if (_isTransport) return _vehicles.length;
    return _tours.length;
  }

  String get _filterPanelTitle {
    if (_isAccomodation) return 'Stay type';
    if (_isTransport) return 'Travel mode';
    return 'Tour type';
  }

  String get _filterPanelSubtitle {
    if (_isAccomodation) {
      return 'Select the kind of place you want to stay in.';
    }
    if (_isTransport) {
      return 'Choose how you want to travel between cities.';
    }
    return 'Narrow the experience by travel style.';
  }

  String get _searchButtonLabel {
    if (_isAccomodation) return 'Search stays';
    if (_isTransport) return 'Search routes';
    return 'Search tours';
  }

  String _filterLabel(int index) {
    if (_isAccomodation) return _accomodations[index];
    if (_isTransport) return _vehicleName(index);
    return _tours[index];
  }

  String _filterValue(int index) {
    final label = _filterLabel(index).toLowerCase();
    return label.replaceAll(' ', '-');
  }

  Widget _resultSortBar(BuildContext context, _ReservationVisuals mode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onSearch,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: mode.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded, color: mode.darkAccent),
                    const SizedBox(width: 8),
                    Text(
                      _searchButtonLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: mode.darkAccent),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!_isAccomodation) ...[
            const SizedBox(width: 10),
            PopupMenuButton<String>(
              key: _menuKey,
              onSelected: (val) {
                setState(() => _currentSort = val);
                onSearch();
              },
              color: AppColors.white,
              surfaceTintColor: AppColors.white,
              itemBuilder: (context) {
                return _sortOptions
                    .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
                    .toList();
              },
              child: InkWell(
                onTap: _openMenu,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: mode.accent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentSort,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: mode.darkAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: mode.darkAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _resultsSliver(BuildContext context) {
    if (_isAccomodation) {
      return GenericGridView<Accommodation>(
        crossAxisCount: 1,
        stream: _accItems$,
        childAspectRatio: 1.5,
        itemBuilder: (a) {
          final priceText =
              '${a.currency == 'USD' ? '\$' : '\$'} ${a.pricePerNight}';
          return DetailsFrame(
            id: a.id,
            imagePath: a.images.isNotEmpty ? a.images[0] : 'images/pic8.jpg',
            title: a.name,
            type: 'accommodation',
            relatedDestinationId: a.destinationId,
            maxGuests: a.maxGuests,
            bedrooms: a.bedrooms,
            beds: a.beds,
            bathrooms: a.bathrooms,
            amenities: a.amenities,
            roomOptions: a.roomOptions,
            images: a.images,
            address: a.address,
            latitude: a.latitude,
            longitude: a.longitude,
            ratingAvg: a.ratingAvg,
            itemTypeLabel: _displayType(a.type),
            destination: a.destinationName,
            price: '$priceText - per night',
            description: a.description,
            color: const Color(0xFFF4D6A4),
          );
        },
      ).buildSliver(context);
    }

    if (_isTransport) {
      if (_roundTrip) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _RoundTripTransportResults(
              outboundStream: _trItems$,
              returnStream: _returnTrItems$,
              selectedOutbound: _selectedOutboundTransport,
              onOutboundSelected:
                  (transport) =>
                      setState(() => _selectedOutboundTransport = transport),
              onReturnSelected: (transport) {
                _selectedReturnTransport = transport;
                _openRoundTripDetails();
              },
            ),
          ),
        );
      }

      return GenericGridView<Transport>(
        stream: _trItems$,
        childAspectRatio: 0.7,
        itemBuilder: (t) {
          final title = t.mode.toUpperCase();
          final price = "${t.currency == "USD" ? '\$' : '\$'} ${t.basePrice}";
          final date = DateFormat(
            'd MMM',
          ).format(t.schedule['departAt'].toDate());
          final transportNumber = _transportNumberLabel(t);
          return DetailsFrame(
            id: t.id,
            imagePath: t.images.isNotEmpty ? t.images[0] : 'images/pic6.jpg',
            title: title,
            type: 'transport',
            relatedDestinationId: t.to['code'],
            origin: t.from['city'],
            destination: t.to['city'],
            description:
                '${_vehicleDisplayName(t.mode)} ticket operated by ${t.company.isEmpty ? 'local partner' : t.company}.',
            images: t.images,
            remainingCapacity: t.remainingCapacity,
            itemTypeLabel: transportNumber,
            transportTickets: [_transportTicketMap(t)],
            price: '$price - $date',
            roundTrip: _roundTrip,
            returnDate: _returnDate,
            color: const Color(0xFFC8E4F2),
          );
        },
      ).buildSliver(context);
    }

    return GenericGridView<Tour>(
      crossAxisCount: 1,
      stream: _tourItems$,
      childAspectRatio: 1.4,
      itemBuilder: (tour) {
        final priceText =
            '${tour.currency == "USD" ? '\$' : '\$'} ${tour.price}';
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
              tour.images.isNotEmpty ? tour.images[0] : 'images/pic11.webp',
          title: tour.name,
          type: 'tour',
          origin: tour.origin['name'],
          destination: tour.destination['name'],
          description: description,
          itemTypeLabel: _displayTypes(tour.types, fallback: tour.type),
          tripScope: tour.tripScope,
          tourDurationDays: tour.durationDays,
          remainingCapacity: tour.remainingCapacity,
          gearSuggestions: tour.gearSuggestions,
          images: tour.images,
          price: '$priceText - $date',
          ratingAvg: tour.ratingAvg,
          color: const Color(0xFFCBE7D4),
        );
      },
    ).buildSliver(context);
  }

  void _openRoundTripDetails() {
    final outbound = _selectedOutboundTransport;
    final returning = _selectedReturnTransport;
    if (outbound == null || returning == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both tickets first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => DetailsPage(
              id: '${outbound.id}_${returning.id}',
              title: 'Round Trip Tickets',
              type: 'transport',
              relatedDestinationId: outbound.to['code']?.toString(),
              origin: outbound.from['city']?.toString(),
              destination: outbound.to['city']?.toString(),
              description:
                  'Selected outbound and return transportation tickets.',
              images: _combinedTransportImages(outbound, returning),
              price: _transportTotalPriceText(outbound, returning),
              remainingCapacity:
                  outbound.remainingCapacity < returning.remainingCapacity
                      ? outbound.remainingCapacity
                      : returning.remainingCapacity,
              roundTrip: true,
              returnDate: _transportDate(returning),
              transportTickets: [
                _transportTicketMap(outbound),
                _transportTicketMap(returning),
              ],
            ),
      ),
    );
  }

  List<dynamic> _combinedTransportImages(
    Transport outbound,
    Transport returning,
  ) {
    final images = <dynamic>[...outbound.images, ...returning.images];
    return images.isEmpty ? const ['images/pic6.jpg'] : images;
  }

  Map<String, dynamic> _transportTicketMap(Transport transport) {
    final date = _transportDate(transport);
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
      'currency': transport.currency == 'USD' ? r'$' : transport.currency,
      'priceText':
          '${transport.currency == 'USD' ? r'$' : transport.currency} ${transport.basePrice}',
      'departAt': date == null ? null : Timestamp.fromDate(date),
      'remainingCapacity': transport.remainingCapacity,
      'description':
          '${_vehicleDisplayName(transport.mode)} ticket operated by ${transport.company.isEmpty ? 'local partner' : transport.company}.',
      'images': transport.images,
    };
  }

  String _transportTotalPriceText(Transport outbound, Transport returning) {
    final total = outbound.basePrice + returning.basePrice;
    final currency = outbound.currency == 'USD' ? r'$' : outbound.currency;
    return '$currency $total';
  }

  String _transportNumberLabel(Transport transport) {
    if ((transport.flightNumber ?? '').isNotEmpty) {
      return transport.flightNumber!;
    }
    if ((transport.trainNumber ?? '').isNotEmpty) {
      return transport.trainNumber!;
    }
    return '';
  }

  DateTime? _transportDate(Transport transport) {
    final value = transport.schedule['departAt'];
    if (value == null) return null;
    if (value is DateTime) return value;
    return value.toDate();
  }
}

String _vehicleName(int i) {
  const v = ['Bus', 'Train', 'Flight', 'Taxi'];
  return v[i];
}

class _RoundTripTransportResults extends StatelessWidget {
  const _RoundTripTransportResults({
    required this.outboundStream,
    required this.returnStream,
    required this.selectedOutbound,
    required this.onOutboundSelected,
    required this.onReturnSelected,
  });

  final Stream<List<Transport>> outboundStream;
  final Stream<List<Transport>> returnStream;
  final Transport? selectedOutbound;
  final ValueChanged<Transport> onOutboundSelected;
  final ValueChanged<Transport> onReturnSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedOutbound == null)
          _TransportSelectionSection(
            title: 'Outbound ticket',
            subtitle:
                'Choose the first ticket, then select your return ticket.',
            stream: outboundStream,
            onSelected: onOutboundSelected,
          )
        else ...[
          _SelectedOutboundBanner(transport: selectedOutbound!),
          const SizedBox(height: 18),
          _TransportSelectionSection(
            title: 'Return ticket',
            subtitle:
                'Choose the second ticket to continue to the details page.',
            stream: returnStream,
            onSelected: onReturnSelected,
          ),
        ],
      ],
    );
  }
}

class _SelectedOutboundBanner extends StatelessWidget {
  const _SelectedOutboundBanner({required this.transport});

  final Transport transport;

  @override
  Widget build(BuildContext context) {
    final currency = transport.currency == 'USD' ? r'$' : transport.currency;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFC8E4F2).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1F5D78).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF1F5D78)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Outbound selected: ${transport.mode.toUpperCase()} - $currency ${transport.basePrice}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransportSelectionSection extends StatelessWidget {
  const _TransportSelectionSection({
    required this.title,
    required this.subtitle,
    required this.stream,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final Stream<List<Transport>> stream;
  final ValueChanged<Transport> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<Transport>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final items = snapshot.data ?? const [];
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'No tickets found',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              final width = MediaQuery.of(context).size.width;
              final crossAxisCount = width > 900 ? 3 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final transport = items[index];
                  final title = transport.mode.toUpperCase();
                  final price =
                      '${transport.currency == 'USD' ? r'$' : transport.currency} ${transport.basePrice}';
                  final date = _transportDateText(transport);

                  return DetailsFrame(
                    id: transport.id,
                    imagePath:
                        transport.images.isNotEmpty
                            ? transport.images[0]
                            : 'images/pic6.jpg',
                    title: title,
                    type: 'transport',
                    relatedDestinationId: transport.to['code'],
                    origin: transport.from['city'],
                    destination: transport.to['city'],
                    description:
                        '${_vehicleDisplayName(transport.mode)} ticket operated by ${transport.company.isEmpty ? 'local partner' : transport.company}.',
                    images: transport.images,
                    price: date.isEmpty ? price : '$price - $date',
                    color: const Color(0xFFC8E4F2),
                    onTap: () => onSelected(transport),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

String _transportDateText(Transport transport) {
  final value = transport.schedule['departAt'];
  if (value == null) return '';
  final date = value is DateTime ? value : value.toDate();
  return DateFormat('d MMM yyyy').format(date);
}

String _vehicleDisplayName(String mode) {
  if (mode == 'ship') return 'Ship';
  return mode.isEmpty ? 'Transport' : mode[0].toUpperCase() + mode.substring(1);
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

class GenericGridView<T> extends StatelessWidget {
  const GenericGridView({
    super.key,
    required this.stream,
    required this.itemBuilder,
    this.crossAxisCount,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 10,
    this.childAspectRatio = 0.8,
  });

  final Stream<List<T>> stream;
  final Widget Function(T item) itemBuilder;
  final int? crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  Widget buildSliver(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final resolvedCrossAxisCount = crossAxisCount ?? (width > 900 ? 3 : 2);

    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No items found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, i) => itemBuilder(items[i]),
              childCount: items.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: resolvedCrossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [buildSliver(context)]);
  }
}

class _ReservationVisuals {
  const _ReservationVisuals({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.accent,
    required this.darkAccent,
    required this.pageTint,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final Color accent;
  final Color darkAccent;
  final Color pageTint;
}

class _RoundTripSelector extends StatelessWidget {
  const _RoundTripSelector({
    required this.enabled,
    required this.accent,
    required this.darkAccent,
    required this.returnDate,
    required this.onEnabledChanged,
    required this.onReturnDateSelected,
    required this.onReturnDateCleared,
  });

  final bool enabled;
  final Color accent;
  final Color darkAccent;
  final DateTime? returnDate;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<DateTime> onReturnDateSelected;
  final VoidCallback onReturnDateCleared;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: enabled ? accent.withValues(alpha: 0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              enabled ? darkAccent.withValues(alpha: 0.28) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.sync_alt_rounded, color: darkAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Round-trip ticket',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Switch(
                value: enabled,
                activeColor: darkAccent,
                onChanged: onEnabledChanged,
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 10),
            DateFields(
              hint_text: 'Return date',
              onDateSelected: onReturnDateSelected,
              onCleared: onReturnDateCleared,
            ),
            if (returnDate != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selected return: ${returnDate!.day}/${returnDate!.month}/${returnDate!.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
