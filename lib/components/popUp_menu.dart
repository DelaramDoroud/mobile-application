import 'package:flutter/material.dart';
import 'package:tourism_app/models/destination_model.dart';

import '../theme/app_theme.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({
    super.key,
    required this.destinations,
    required this.title,
    this.currentDestId,
    required this.onChanged,
    this.onCleared,
    this.borderRadius,
    required this.hintCoolor,
    required this.fontSize,
    this.googleFont,
  });

  final Stream<List<Destination>> destinations;
  final String title;
  final String? currentDestId;
  final BorderRadius? borderRadius;
  final Color hintCoolor;
  final double fontSize;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCleared;
  final TextStyle Function({
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    required TextDecoration decoration,
  })?
  googleFont;

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  final GlobalKey<PopupMenuButtonState<String>> _menuKey =
      GlobalKey<PopupMenuButtonState<String>>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Destination>>(
      stream: widget.destinations,
      builder: (context, snap) {
        final list = snap.data ?? const <Destination>[];
        final currentName = () {
          if (widget.currentDestId == null) return widget.title;
          final i = list.indexWhere((d) => d.id == widget.currentDestId);
          return i == -1 ? widget.title : list[i].city;
        }();

        return PopupMenuButton<String>(
          key: _menuKey,
          onSelected: (val) => widget.onChanged?.call(val),
          position: PopupMenuPosition.under,
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          itemBuilder: (context) {
            return list
                .map(
                  (d) => PopupMenuItem<String>(
                    value: d.id,
                    child: Text(
                      d.city,
                      style:
                          widget.googleFont?.call(
                            fontSize: widget.fontSize,
                            color: AppColors.ink,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ) ??
                          TextStyle(
                            fontSize: widget.fontSize,
                            color: AppColors.ink,
                          ),
                    ),
                  ),
                )
                .toList();
          },
          child: InkWell(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(18),
            onTap: () => _menuKey.currentState?.showButtonMenu(),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withOpacity(0.10)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentName,
                      overflow: TextOverflow.ellipsis,
                      style:
                          widget.googleFont?.call(
                            fontSize: widget.fontSize,
                            color: widget.hintCoolor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ) ??
                          TextStyle(
                            fontSize: widget.fontSize,
                            color: widget.hintCoolor,
                          ),
                    ),
                  ),
                  if (widget.currentDestId != null)
                    GestureDetector(
                      onTap: widget.onCleared,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.muted,
                          size: 18,
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.muted,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
