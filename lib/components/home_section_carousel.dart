import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeSectionCarousel extends StatelessWidget {
  const HomeSectionCarousel({
    super.key,
    required this.index,
    required this.title,
    required this.onMore,
    required this.stream,
    required this.itemBuilder,
  });

  final int index;
  final String title;
  final VoidCallback onMore;
  final Stream<List<Map<String, dynamic>>> stream;
  final Widget Function(Map<String, dynamic> m) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 30 : 18, bottom: 4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onMore,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withOpacity(0.22),
                    ),
                    backgroundColor: AppColors.white.withOpacity(0.72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('More'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.28,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (_, i) => itemBuilder(items[i]),
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
