import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourism_app/components/date_fields.dart';
import 'package:tourism_app/components/details_frame.dart';
import 'package:tourism_app/components/popUp_menu.dart';
import 'package:tourism_app/data/firestore_repo.dart';
import 'package:tourism_app/models/destination_model.dart';
import 'package:tourism_app/models/tour_model.dart';
import 'package:tourism_app/models/transportation_model.dart';
import '../models/accommodation_model.dart';
import 'package:intl/intl.dart';

class ReservePage extends StatefulWidget {
  final bool accomodations;
  final bool transport;

  ReservePage({
    super.key,
    required this.accomodations,
    required this.transport,
  });
  @override
  _ReservePageState createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  final _repo = FirestoreRepo();
  bool _isLoading = false;
  final String initialSort = "Sort by";
  final _menuKey = GlobalKey<PopupMenuButtonState<String>>();
  String? _selectedDestinationId;
  String? _selectedOriginId;
  // DateTime? _arrivalDate;
  DateTime? _departureDate;
  final List<String> _selectedType = [];
  int passengerCount = 1;
  List<bool> is_selected = [false, false, false, false, false];
  final List<IconData> vehicles = [
    // Icons.directions_car,
    Icons.directions_bus,
    Icons.train,
    Icons.flight,
    Icons.directions_boat,
  ];
  final List<String> accomodations = [
    "Villa",
    "Apartment",
    "Hotel",
    "Eco-Lodges",
  ];
  final List<String> tours = ["Nature", "Culture", "History", "Adventure"];
  final List<String> sortOptions = ["Price", "Date"];
  final List<String> destinations = [
    "Bali",
    "Yogyakarta",
    "Jakarta",
    "Lombok",
    "Komodo",
    "Bandung",
  ];

  late bool _isAccomodation;
  late bool _isTransport;
  // late bool _isTour;

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
    _currentSort = initialSort;
    _destItems$ = _repo.streamDestinations().map(
      (list) =>
          list.map(((m) => Destination.fromMap(m['id'] as String, m))).toList(),
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
    // _isTour = widget.tour;
  }

  void _openMenu() {
    _menuKey.currentState?.showButtonMenu(); // PopupMenuButtonState method
  }

  Future<void> onSearch() async {
    setState(() => _isLoading = true);

    final String? destId = _selectedDestinationId;
    final String? fromId = _selectedOriginId;
    final types = _selectedType;
    final DateTime? startDate = _departureDate;
    // final DateTime? endDate = _departureDate;

    setState(() {
      _accItems$ = _repo
          .streamAccommodations(
            destinationId: destId,
            types: _isAccomodation && types.isNotEmpty ? types : null,
            startDate: startDate,
            sortBy: _currentSort == "Date" ? "date" : "price",
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
            //endDate: endDate,
            sortBy: _currentSort == "Date" ? "date" : "price",
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
            //endDate: endDate,
            sortBy: _currentSort == "Date" ? "date" : "price",
          )
          .map(
            (list) =>
                list.map((m) => Tour.fromMap(m['id'] as String, m)).toList(),
          );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color:
              _isAccomodation
                  ? const Color.fromARGB(255, 237, 182, 99)
                  : (_isTransport
                      ? const Color.fromARGB(255, 102, 165, 189)
                      : const Color.fromARGB(220, 64, 224, 134)),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child:
                          _isAccomodation
                              ? Image.asset(
                                "images/pic8.jpg",
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                              : (_isTransport
                                  ? Image.asset(
                                    "images/pic6.jpg",
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.asset(
                                    "images/pic11.webp",
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )),
                    ),
                    Positioned(
                      top: _isAccomodation ? 60 : 150,
                      left: 20,
                      child:
                          _isAccomodation
                              ? Text(
                                "Accomodation",
                                style: GoogleFonts.dancingScript(
                                  fontSize: 38,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              )
                              : (_isTransport
                                  ? Text(
                                    "Transportation",
                                    style: GoogleFonts.dancingScript(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  )
                                  : Text(
                                    "Different Tours",
                                    style: GoogleFonts.dancingScript(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  )),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _isAccomodation
                      ? accomodations.length
                      : (_isTransport ? vehicles.length : tours.length),
                  (index) {
                    return GestureDetector(
                      onTap:
                          () => setState(() {
                            is_selected[index] = !is_selected[index];
                            final t =
                                _isAccomodation
                                    ? accomodations[index]
                                    : (_isTransport
                                        ? _vehicleName(index)
                                        : tours[index]);
                            if (is_selected[index]) {
                              if (!_selectedType.contains(t.toLowerCase()))
                                _selectedType.add(t.toLowerCase());
                            } else {
                              _selectedType.remove(t.toLowerCase());
                            }
                          }),
                      child: Container(
                        //margin: EdgeInsets.all(0),
                        //width: 50,
                        //height: 50,
                        //color: Colors.blue,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color:
                              is_selected[index]
                                  ? (_isAccomodation
                                      ? const Color.fromARGB(255, 118, 17, 17)
                                      : (_isTransport
                                          ? const Color.fromARGB(
                                            255,
                                            13,
                                            50,
                                            67,
                                          )
                                          : const Color.fromARGB(
                                            255,
                                            13,
                                            67,
                                            34,
                                          )))
                                  : Colors.transparent,
                          //borderRadius: BorderRadius.circular(15),
                          shape:
                              _isTransport
                                  ? BoxShape.circle
                                  : BoxShape.rectangle,
                          borderRadius:
                              !_isTransport ? BorderRadius.circular(15) : null,
                          // border: Border.all(color: Colors.white, width: 2),
                        ),
                        child:
                            _isAccomodation
                                ? Text(
                                  accomodations[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : (_isTransport
                                    ? Icon(
                                      vehicles[index],
                                      size: 30,
                                      color: Colors.white,
                                    )
                                    : Text(
                                      tours[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:
                      _isAccomodation
                          ? const Color.fromARGB(206, 217, 106, 106)
                          : (_isTransport
                              ? const Color.fromARGB(172, 196, 247, 190)
                              : const Color.fromARGB(136, 255, 252, 59)),
                ),
                child: Column(
                  spacing: 20,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.baseline,
                      spacing: 10,
                      children: [
                        if (!_isAccomodation)
                          Expanded(
                            child: PopupMenu(
                              destinations: _destItems$,
                              title: "Select origin",
                              currentDestId: _selectedOriginId,
                              //hint_text: "Destination",
                              borderRadius: BorderRadius.circular(15),
                              hintCoolor: const Color.fromARGB(255, 96, 96, 96),
                              fontSize: 14,
                              googleFont: GoogleFonts.davidLibre,
                              onChanged: (id) {
                                setState(() {
                                  _selectedOriginId = id;
                                });
                              },
                              // fillColor: Colors.transparent,
                              // borderSide: BorderSide(
                              //   color: Colors.white,
                              //   width: 2,
                              // ),
                            ),
                          ),
                        Expanded(
                          child: PopupMenu(
                            destinations: _destItems$,
                            title: "Select Destination",
                            currentDestId: _selectedDestinationId,
                            //hint_text: "Destination",
                            borderRadius: BorderRadius.circular(15),
                            hintCoolor: const Color.fromARGB(255, 96, 96, 96),
                            fontSize: 14,
                            googleFont: GoogleFonts.davidLibre,
                            onChanged: (id) {
                              setState(() {
                                _selectedDestinationId = id;
                              });
                            },
                          ),
                        ),
                        //Expanded(child: _numOfPassengers(context)),
                      ],
                    ),
                    DateFields(
                      hint_text: "Departure Date",
                      onDateSelected: (d) => setState(() => _departureDate = d),
                    ),
                  ],
                ),
              ),
              _resultSortBar(context),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _resultsGrid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _numOfPassengers(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               "number of passengers",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             //const SizedBox(height: 5),
  //             Container(
  //               height: 40,
  //               width: MediaQuery.of(context).size.width,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(18),
  //               ),
  //               padding: EdgeInsets.symmetric(horizontal: 28, vertical: 0),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   IconButton(
  //                     icon: const Icon(Icons.remove, size: 16),
  //                     onPressed: () {
  //                       setState(() {
  //                         if (passengerCount > 1) passengerCount--;
  //                       });
  //                     },
  //                   ),
  //                   Text(
  //                     '$passengerCount',
  //                     style: const TextStyle(fontSize: 14),
  //                   ),
  //                   IconButton(
  //                     icon: const Icon(Icons.add, size: 16),
  //                     onPressed: () {
  //                       setState(() {
  //                         passengerCount++;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  _resultSortBar(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),

      child: Container(
        padding: EdgeInsets.only(left: 20),
        width: screenWidth * 0.85,
        height: screenHeight * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              //offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Material(
                child: InkWell(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(28),
                  ),
                  //isLoading: _isLoading,
                  onTap: onSearch,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Show Results",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _isAccomodation
                                  ? const Color.fromARGB(255, 237, 182, 99)
                                  : (_isTransport
                                      ? Color.fromARGB(255, 102, 165, 189)
                                      : const Color.fromARGB(
                                        220,
                                        64,
                                        224,
                                        134,
                                      )),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color:
                            _isAccomodation
                                ? const Color.fromARGB(255, 237, 182, 99)
                                : (_isTransport
                                    ? Color.fromARGB(255, 102, 165, 189)
                                    : const Color.fromARGB(220, 64, 224, 134)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 28,
              color:
                  _isAccomodation
                      ? const Color.fromARGB(255, 237, 182, 99)
                      : (_isTransport
                          ? Color.fromARGB(255, 102, 165, 189)
                          : const Color.fromARGB(220, 64, 224, 134)),
            ),
            Expanded(
              flex: 2,
              child: PopupMenuButton<String>(
                key: _menuKey,
                onSelected: (val) {
                  setState(() => _currentSort = val);
                  onSearch();
                },
                itemBuilder:
                    (context) =>
                        sortOptions
                            .map(
                              (e) => PopupMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                offset: const Offset(0, 8),
                color:
                    _isAccomodation
                        ? const Color.fromARGB(255, 237, 182, 99)
                        : (_isTransport
                            ? Color.fromARGB(255, 102, 165, 189)
                            : const Color.fromARGB(220, 64, 224, 134)),
                // Use child so the whole right half is tappable
                child: InkWell(
                  onTap: _openMenu,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(28),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentSort,
                          style: TextStyle(
                            color:
                                _isAccomodation
                                    ? const Color.fromARGB(255, 237, 182, 99)
                                    : (_isTransport
                                        ? Color.fromARGB(255, 102, 165, 189)
                                        : const Color.fromARGB(
                                          220,
                                          64,
                                          224,
                                          134,
                                        )),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              _isAccomodation
                                  ? const Color.fromARGB(255, 237, 182, 99)
                                  : (_isTransport
                                      ? Color.fromARGB(255, 102, 165, 189)
                                      : const Color.fromARGB(
                                        220,
                                        64,
                                        224,
                                        134,
                                      )),
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

      // ),
    );
  }

  Widget _resultsGrid() {
    if (_isAccomodation) {
      return GenericGridView<Accommodation>(
        stream: _accItems$,
        itemBuilder: (a) {
          // final img =
          //     (a.images.isNotEmpty)
          //         ? a.images.first.toString()
          //         : 'images/pic10.jpg';
          final priceText =
              '${a.currency == 'USD' ? '\$' : '\$'} ${a.pricePerNight}';
          return DetailsFrame(
            imagePath: 'images/pic10.jpg',
            title: '${a.name} \n ${a.destinationName}',
            price: priceText + " - per night",
            color: const Color.fromARGB(166, 255, 255, 255),
          );
        },
      );
    }

    if (_isTransport) {
      return GenericGridView<Transport>(
        stream: _trItems$,
        itemBuilder: (t) {
          final title =
              "${t.mode.toUpperCase()} \n ${t.from['city']} → ${t.to['city']}";
          final price = "${t.currency == "USD" ? '\$' : '\$'} ${t.basePrice}";
          final date = DateFormat(
            'd MMM',
          ).format(t.schedule['departAt'].toDate());
          return DetailsFrame(
            imagePath: "images/pic6.jpg",
            title: title,
            price: price + " - " + date,
            color: const Color.fromARGB(166, 255, 255, 255),
          );
        },
      );
    }

    return GenericGridView<Tour>(
      stream: _tourItems$,
      itemBuilder: (tour) {
        // final img =
        //     (tour.images.isNotEmpty)
        //         ? tour.images.first.toString()
        //         : 'images/pic11.webp';
        final priceText =
            '${tour.currency == "USD" ? '\$' : '\$'} ${tour.price}';
        final date = DateFormat(
          'd MMM',
        ).format(tour.dates['startDate'].toDate());
        return DetailsFrame(
          imagePath: 'images/pic11.webp',
          title:
              '${tour.name} \n ${tour.origin['name']} → ${tour.destination['name']}',
          price: priceText + " - " + date,
          color: const Color.fromARGB(166, 255, 255, 255),
        );
      },
    );
  }
}

String _vehicleName(int i) {
  const v = ["bus", "train", "flight", "boat"];
  return v[i];
}

class GenericGridView<T> extends StatelessWidget {
  final Stream<List<T>> stream;
  final Widget Function(T item) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const GenericGridView({
    super.key,
    required this.stream,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 10,
    this.childAspectRatio = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const Center(child: Text("No items found"));
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => itemBuilder(items[i]),
        );
      },
    );
  }
}
