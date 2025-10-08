import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/details_frame.dart';
import '../data/firestore_repo.dart';
import '../components/home_section_carousel.dart';
import 'reservation.dart';
// import '../components/hover_searchBar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _repo = FirestoreRepo();

  // رنگ‌های پیشنهادی برای سه بخش
  // static const _transportColor = Color(0xFF51AEF0);
  // static const _accommodationColor = Color(0xFFF0BE51);
  // static const _tourColor = Color(0xFF7ED957);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 260.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // image: DecorationImage(
                //   image: AssetImage("images/pic1.png"),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset("images/pic1.png", fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 42,
                    left: MediaQuery.of(context).size.width * 0.08,
                    child: Text(
                      "Plan\nyour\ntravel",
                      style: GoogleFonts.dancingScript(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        //fontFamily: 'DancingScript',
                      ),
                    ),
                  ),
                  // Hover Effect Applied Here
                  //HoverableSearchBar(hint_text: "Enter your destination"),
                ],
              ),
            ),
          ),
          // ---------- Recommended Transport Tickets ----------
          HomeSectionCarousel(
            index: 0,
            title: "Recommended Transports",
            onMore: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          ReservePage(accomodations: false, transport: false),
                ),
              );
            },
            stream: _repo.streamLatestTransports(limit: 4),
            itemBuilder: (m) {
              final type = (m['mode'] ?? '').toString();
              final name = "$type \n ${m['from']['city']} → ${m['to']['city']}";
              final price = (m['basePrice'] ?? 0).toString();
              final currency =
                  (m['currency'] == "USD" ? '\$' : '\$').toString();
              final schedule = m['schedule'] as Map<String, dynamic>? ?? {};
              String dateText = '';
              if (schedule.isNotEmpty) {
                final start = (schedule["departAt"] ).toDate();
                dateText = "${start.day} ${_mon(start)}";
                // یا اگر بازه خواستی:
                // final last = (dates.last as Timestamp).toDate();
                // dateText = "${first.day}-${last.day} ${_mon(first)}";
              }

              // final List imgs = (m['images'] as List?) ?? [];
              // final firstImg =
              //     imgs.isNotEmpty
              //         ? imgs.first.toString()
              //         : 'images/common/placeholder.jpg';
              return DetailsFrame(
                imagePath: "images/pic3.jpg",
                title: name,
                price: "$price $currency - $dateText",
                color: const Color.fromARGB(255, 81, 174, 240),
              );
            },
          ),

          // ---------- Recommended Accommodations ----------
          HomeSectionCarousel(
            index: 1,
            title: "Recommended Accommodations",
            onMore: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ReservePage(accomodations: true, transport: false),
                ),
              );
            },
            stream: _repo.streamLatestAccommodations(limit: 4),
            itemBuilder: (m) {
              final name = (m['name'] ?? '').toString();
              final price = (m['pricePerNight'] ?? 0).toString();
              final currency =
                  (m['currency'] == "USD" ? '\$' : '\$').toString();
              //final List imgs = (m['images'] as List?) ?? [];
              //final firstImg = imgs.isNotEmpty ? imgs.first.toString() : null;
              return DetailsFrame(
                imagePath: "images/pic3.jpg",
                title: name,
                price: "$price $currency - per night",
                color: const Color.fromARGB(255, 240, 190, 81),
              );
            },
          ),

          // ---------- Recommended Tours ----------
          HomeSectionCarousel(
            index: 2,
            title: "Recommended Tours",
            onMore: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          ReservePage(accomodations: false, transport: false),
                ),
              );
            },
            stream: _repo.streamLatestTours(limit: 4),
            itemBuilder: (m) {
              final name = (m['name'] ?? '').toString();
              final price = (m['price'] ?? 0).toString();
              final currency =
                  (m['currency'] == "USD" ? '\$' : '\$').toString();
              // final List imgs = (m['images'] as List?) ?? [];
              //final firstImg = imgs.isNotEmpty ? imgs.first.toString() : null;
              String dateText = '';
              final dates = m['dates'] as Map<String, dynamic>? ?? {};
              if (dates.isNotEmpty) {
                final start = (dates["startDate"]).toDate();
                dateText = "${start.month}${_mon(start)} ${start.year}";
              }
              return DetailsFrame(
                imagePath: "images/pic3.jpg",
                title: name,
                price: "$price $currency - $dateText",
                color: Colors.greenAccent,
              );
            },
          ),
        ],
      ),
    );
  }
}

String _mon(DateTime d) {
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return m[d.month - 1];
}
