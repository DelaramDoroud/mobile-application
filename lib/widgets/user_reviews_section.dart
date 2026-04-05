import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/data/firestore_repo.dart';

class UserReviewsSection extends StatelessWidget {
  final String targetType;
  final String targetId;
  final _repo = FirestoreRepo();
  UserReviewsSection({
    Key? key,
    required this.targetType,
    required this.targetId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _repo.streamReviews(targetType: targetType, targetId: targetId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            'No reviews yet. Be the first to write one!',
            style: TextStyle(color: Colors.white70),
          );
        }
        final reviews = snapshot.data!;
        print("📡 targetType: $targetType, targetId: $targetId");
        print("📦 Snapshot data count: ${snapshot.data?.length}");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.white54, thickness: 1),
            const Text(
              'User Reviews',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // ساختن کارت برای هر review
            ...reviews.map((review) {
              return _buildReviewCard(review);
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['userId'] ?? 'Anonymous',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (review['createdAt'] as Timestamp)
                    .toDate()
                    .toLocal()
                    .toString()
                    .split(' ')[0],
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < (review['rating'] ?? 0)
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Colors.amberAccent,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            review['text'] ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
