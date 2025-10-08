import 'package:flutter/material.dart';
import '../data/firestore_repo.dart';

class FsImage extends StatelessWidget {
  final String storagePath;
  final double? height;
  final double? width;
  final BoxFit fit;

  const FsImage({
    super.key,
    required this.storagePath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final repo = FirestoreRepo();

    return FutureBuilder<String>(
      future: repo.getDownloadUrl(storagePath),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (snap.hasError) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: Icon(Icons.broken_image)),
          );
        }
        return Image.network(
          snap.data!,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
