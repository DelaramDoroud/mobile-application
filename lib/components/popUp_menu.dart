import 'package:flutter/material.dart';
import 'package:tourism_app/models/destination_model.dart';

class PopupMenu extends StatelessWidget {
  final Stream<List<Destination>> destinations;
  final String title;
  final String? currentDestId;
  final BorderRadius? borderRadius;
  final Color hintCoolor;
  final double fontSize;
  final ValueChanged<String>? onChanged;

  final TextStyle Function({
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    required TextDecoration decoration,
  })?
  googleFont;
  const PopupMenu({
    super.key,
    required this.destinations,
    required this.title,
    this.currentDestId,
    required this.onChanged,
    this.borderRadius,
    required this.hintCoolor,
    required this.fontSize,
    this.googleFont,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<List<Destination>>(
      stream: destinations,
      builder: (context, snap) {
        final list = snap.data ?? const <Destination>[];
        final currentName = () {
          if (currentDestId == null) return title;
          final i = list.indexWhere((d) => d.id == currentDestId);
          return i == -1 ? title : list[i].city;
        }();
        final isLoading = snap.connectionState == ConnectionState.waiting;
        return PopupMenuButton<String>(
          onSelected: (val) {
            onChanged?.call(val);
          },
          itemBuilder:
              (context) =>
                  list
                      .map(
                        (d) => PopupMenuItem<String>(
                          value: d.id,
                          child: Text(
                            d.city,
                            style:
                                googleFont?.call(
                                  fontSize: fontSize,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ) ??
                                TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                      )
                      .toList(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: EdgeInsets.only(top: screenHeight * 0.01),
            height: screenHeight * 0.058,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              //border: Border.all(color: widget.hintCoolor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // widget.currentDest.isEmpty
                  //     ? "Select Destination"
                  //     :
                  currentName,
                  style:
                      googleFont?.call(
                        fontSize: fontSize,
                        color: hintCoolor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ) ??
                      TextStyle(fontSize: fontSize, color: hintCoolor),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
