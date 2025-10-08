import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSectionCarousel extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback onMore;
  final Stream<List<Map<String, dynamic>>> stream;
  final Widget Function(Map<String, dynamic> m) itemBuilder;

  const HomeSectionCarousel({
    super.key,
    required this.index,
    required this.title,
    required this.onMore,
    required this.stream,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: index == 0 ? 45.0 : 25.0,
                start: 5.0,
              ),
              child: Align(
                heightFactor: 0,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: GoogleFonts.arimo(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        blurRadius: 12,
                        color: const Color.fromARGB(150, 13, 181, 116),
                        offset: Offset(4.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: index == 0 ? 40 :30,
                bottom: 10,
                end: 10,
              ),
              child: ButtonTheme(
                height: 60,
                child: ElevatedButton(
                  onPressed: onMore,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      // vertical: 1,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(
                      color: const Color.fromARGB(143, 0, 150, 135),
                    ),
                    // shadowColor: Colors.green,
                  ),
                  child: Text(
                    "more",
                    style: GoogleFonts.arimo(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.22,
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: stream,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              }
              final items = snap.data ?? [];
              if (items.isEmpty) {
                return const Center(child: Text('No items yet.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (_, i) => itemBuilder(items[i]),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
              );
            },
          ),
        ),
      ],
    );

    // Column(
    //   children: [
    //     // Header row
    //     Padding(
    //       padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(title,
    //               style: const TextStyle(
    //                 fontSize: 18,
    //                 fontStyle: FontStyle.italic,
    //                 shadows: [Shadow(blurRadius: 8, color: Color(0x8800A687), offset: Offset(2, 1))],
    //               )),
    //           OutlinedButton(
    //             onPressed: onMore,
    //             child: const Text('more'),
    //           ),
    //         ],
    //       ),
    //     ),

    //     // Stream -> horizontal list
    //     SizedBox(
    //       height: 200,
    //       child: StreamBuilder<List<Map<String, dynamic>>>(
    //         stream: stream,
    //         builder: (context, snap) {
    //           if (snap.connectionState == ConnectionState.waiting) {
    //             return const Center(child: CircularProgressIndicator());
    //           }
    //           if (snap.hasError) {
    //             return Center(child: Text('Error: ${snap.error}'));
    //           }
    //           final items = snap.data ?? [];
    //           if (items.isEmpty) {
    //             return const Center(child: Text('No items yet.'));
    //           }

    //           return ListView.builder(
    //             padding: const EdgeInsets.symmetric(horizontal: 8),
    //             scrollDirection: Axis.horizontal,
    //             itemCount: items.length,
    //             itemBuilder: (_, i) => itemBuilder(items[i]),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
