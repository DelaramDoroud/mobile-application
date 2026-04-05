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
  late final List<bool> _selectedChips;
  final List<String> _selectedType = [];

  final List<IconData> _vehicles = [
    Icons.directions_bus,
    Icons.train,
    Icons.flight,
    Icons.directions_boat,
  ];
  final List<String> _accomodations = [
    'Villa',
    'Apartment',
    'Hotel',
    'Eco-Lodges',
  ];
  final List<String> _tours = ['Nature', 'Culture', 'History', 'Adventure'];
  final List<String> _sortOptions = ['Price', 'Date'];

  late bool _isAccomodation;
  late bool _isTransport;
  late Stream<List<Accommodation>> _accItems$;
  late Stream<List<Transport>> _trItems$;
  late Stream<List<Tour>> _tourItems$;
  late Stream<List<Destination>> _destItems$;
  late String _currentSort;

  @override
  void initState() {
    super.initState();
    _isAccomodation = widget.accomodations;
    _isTransport = widget.transport;
    _selectedChips = List<bool>.filled(5, false);
    _currentSort = _initialSort;

    _destItems$ = _repo.streamDestinations().map(
      (list) =>
          list.map((m) => Destination.fromMap(m['id'] as String, m)).toList(),
    );
    _accItems$ = _repo.streamAccommodations().map(
      (list) =>
          list.map((m) => Accommodation.fromMap(m['id'] as String, m)).toList(),
    );
    _trItems$ = _repo.streamTransports().map(
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

    setState(() {
      _accItems$ = _repo
          .streamAccommodations(
            destinationId: destId,
            types: _isAccomodation && types.isNotEmpty ? types : null,
            startDate: startDate,
            sortBy: _currentSort == 'Date' ? 'date' : 'price',
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
            sortBy: _currentSort == 'Date' ? 'date' : 'price',
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
                  Colors.black.withOpacity(0.12),
                  mode.darkAccent.withOpacity(0.82),
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
                      color: AppColors.white.withOpacity(0.9),
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
            color: mode.accent.withOpacity(0.16),
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
                      if (!_selectedType.contains(type))
                        _selectedType.add(type);
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
                            ? mode.accent.withOpacity(0.18)
                            : AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color:
                          selected
                              ? mode.darkAccent.withOpacity(0.35)
                              : AppColors.primary.withOpacity(0.08),
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
              if (!_isAccomodation)
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
              if (!_isAccomodation) const SizedBox(width: 12),
              Expanded(
                child: PopupMenu(
                  destinations: _destItems$,
                  title:
                      _isAccomodation
                          ? 'Choose destination'
                          : 'Select destination',
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
          DateFields(
            hint_text: _isAccomodation ? 'Check-in date' : 'Departure date',
            onDateSelected: (d) => setState(() => _departureDate = d),
            onCleared: () => setState(() => _departureDate = null),
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

  String _filterValue(int index) => _filterLabel(index).toLowerCase();

  Widget _resultSortBar(BuildContext context, _ReservationVisuals mode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
                  color: mode.accent.withOpacity(0.15),
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
                  border: Border.all(color: mode.accent.withOpacity(0.25)),
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
      ),
    );
  }

  Widget _resultsSliver(BuildContext context) {
    if (_isAccomodation) {
      return GenericGridView<Accommodation>(
        stream: _accItems$,
        childAspectRatio: 0.72,
        itemBuilder: (a) {
          final priceText =
              '${a.currency == 'USD' ? '\$' : '\$'} ${a.pricePerNight}';
          return DetailsFrame(
            id: a.id,
            imagePath: 'images/pic10.jpg',
            title: a.name,
            type: 'accommodation',
            relatedDestinationId: a.destinationId,
            maxGuests: a.maxGuests,
            bedrooms: a.bedrooms,
            beds: a.beds,
            bathrooms: a.bathrooms,
            amenities: a.amenities,
            ratingAvg: a.ratingAvg,
            destination: a.destinationName,
            price: '$priceText - per night',
            description: a.description,
            color: const Color(0xFFF4D6A4),
          );
        },
      ).buildSliver(context);
    }

    if (_isTransport) {
      return GenericGridView<Transport>(
        stream: _trItems$,
        childAspectRatio: 0.68,
        itemBuilder: (t) {
          final title = t.mode.toUpperCase();
          final price = "${t.currency == "USD" ? '\$' : '\$'} ${t.basePrice}";
          final date = DateFormat(
            'd MMM',
          ).format(t.schedule['departAt'].toDate());
          return DetailsFrame(
            id: t.id,
            imagePath: 'images/pic6.jpg',
            title: title,
            type: 'transport',
            relatedDestinationId: t.to['code'],
            origin: t.from['city'],
            destination: t.to['city'],
            price: '$price - $date',
            color: const Color(0xFFC8E4F2),
          );
        },
      ).buildSliver(context);
    }

    return GenericGridView<Tour>(
      stream: _tourItems$,
      childAspectRatio: 0.62,
      itemBuilder: (tour) {
        final priceText =
            '${tour.currency == "USD" ? '\$' : '\$'} ${tour.price}';
        final date = DateFormat(
          'd MMM',
        ).format(tour.dates['startDate'].toDate());
        return DetailsFrame(
          id: tour.id,
          imagePath: 'images/pic11.webp',
          title: tour.name,
          type: 'tour',
          origin: tour.origin['name'],
          destination: tour.destination['name'],
          description: tour.description,
          price: '$priceText - $date',
          ratingAvg: tour.ratingAvg,
          color: const Color(0xFFCBE7D4),
        );
      },
    ).buildSliver(context);
  }
}

String _vehicleName(int i) {
  const v = ['Bus', 'Train', 'Flight', 'Boat'];
  return v[i];
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
