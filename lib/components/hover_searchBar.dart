import 'package:flutter/material.dart';

class HoverableSearchBar extends StatelessWidget {
  final hint_text;

  const HoverableSearchBar({
    super.key,
    this.hint_text,
  });

  @override
  Widget build(BuildContext context) {
     final ValueNotifier<bool> isHovered = ValueNotifier(false);
    return Positioned(
      bottom: 10,
      left: 30,
      right: 30,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: ValueListenableBuilder<bool>(
          valueListenable: isHovered,
          builder: (context, hovered, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color:
                    hovered
                        ? Colors.green.withOpacity(0.9) // Darker on hover
                        : Colors.greenAccent.withOpacity(
                          0.6,
                        ), // Lighter normally
                borderRadius: BorderRadius.circular(15.0),
                boxShadow:
                    hovered
                        ? [BoxShadow(color: Colors.black26, blurRadius: 10)]
                        : [],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: hint_text,
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
