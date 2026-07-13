import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreRepo {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // ---------------- Accommodations ----------------
  Stream<List<Map<String, dynamic>>> streamAccommodations({
    // String? destinationName,
    String? destinationId,
    List<String>? types,
    DateTime? startDate, // NEW
    // DateTime? endDate,
    String? sortBy, // 'price' | 'rating'
  }) {
    Query<Map<String, dynamic>> q = _db.collection('accommodations');

    if (destinationId != null && destinationId.isNotEmpty) {
      q = q.where('destination.id', isEqualTo: destinationId);
    }
    if (types != null && types.isNotEmpty) {
      q = q.where('type', whereIn: types);
    }
    // if (startDate != null) {
    //   //q = q.where('availableDates.startDate', isLessThan: startDate);
    //   q = q.where('availability.to', isGreaterThanOrEqualTo: startDate);
    // }
    if (sortBy == 'date') {
      q = q.orderBy('createdAt', descending: true);
    } else {
      q = q.orderBy('pricePerNight');
    }

    return q.snapshots().map((s) {
      final docs = s.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      return docs;

      // // فقط-تاریخ به‌صورت لوکال (بدون UTC)
      // final sel = DateUtils.dateOnly(startDate);

      // return docs.where((item) {
      //   final av = item['availability'];
      //   if (av is! List || av.isEmpty) return false;

      //   return av.any((slot) {
      //     if (slot is! Map) return false;

      //     final tsFrom = slot['from'] as Timestamp?;
      //     final tsTo = slot['to'] as Timestamp?;
      //     if (tsFrom == null || tsTo == null) return false;

      //     final f = DateUtils.dateOnly(tsFrom.toDate());
      //     final t = DateUtils.dateOnly(tsTo.toDate());

      //     final ok = !sel.isBefore(f) && !sel.isAfter(t);

      //     // --- دیباگ موقت، اگر خواستی ببینی چرا رد می‌شود:
      //     //print('[$sel] in [$f .. $t] => $ok');

      //     return ok;
      //   });
      // }).toList();
    });
  }

  // ---------------- Transports ----------------
  Stream<List<Map<String, dynamic>>> streamTransports({
    String? fromCode,
    String? toCode, // ← اختیاری
    List<String>? modes, // flight | train | bus | ship
    DateTime? startDate, // NEW
    // DateTime? endDate,
    String? sortBy, // 'price' | 'date'
  }) {
    Query<Map<String, dynamic>> q = _db.collection('transports');

    if (fromCode != null && fromCode.isNotEmpty) {
      q = q.where('from.code', isEqualTo: fromCode);
    }
    if (toCode != null && toCode.isNotEmpty) {
      q = q.where('to.code', isEqualTo: toCode);
    }
    if (modes != null && modes.isNotEmpty) {
      q = q.where('mode', whereIn: modes);
    }
    if (startDate != null) {
      final startOfDay = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );

      final endOfDay = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        23,
        59,
        59,
      );

      q = q
          .where('schedule.departAt', isGreaterThanOrEqualTo: startOfDay)
          .where('schedule.departAt', isLessThanOrEqualTo: endOfDay);
    }

    // برای MVP: قیمت؛ اگر duration می‌خواهی، یا فیلد duration ذخیره کن یا کلاینت سورت کند.
    if (sortBy == 'basePrice') {
      if (startDate != null) {
        q = q.orderBy('schedule.departAt');
      }
    } else {
      q = q.orderBy('schedule.departAt');
    }

    return q.snapshots().map((s) {
      final docs = s.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      if (sortBy == 'basePrice') {
        docs.sort((a, b) {
          final aPrice = (a['basePrice'] as num?)?.toDouble() ?? 0;
          final bPrice = (b['basePrice'] as num?)?.toDouble() ?? 0;
          return aPrice.compareTo(bPrice);
        });
      }
      return docs;
    });
  }

  // ---------------- Tours ----------------
  Stream<List<Map<String, dynamic>>> streamTours({
    String? destinationId,
    String? originId,
    List<String>? types, // nature | city | ...
    DateTime? startDate, // NEW
    // DateTime? endDate,
    String? sortBy, // 'price' | 'date'
  }) {
    Query<Map<String, dynamic>> q = _db.collection('tours');

    if (destinationId != null && destinationId.isNotEmpty) {
      q = q.where('destination.id', isEqualTo: destinationId);
    }

    if (originId != null && originId.isNotEmpty) {
      q = q.where('origin.id', isEqualTo: originId);
    }

    if (startDate != null) {
      final startOfDay = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );

      final endOfDay = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        23,
        59,
        59,
      );

      q = q
          .where('dates.startDate', isGreaterThanOrEqualTo: startOfDay)
          .where('dates.startDate', isLessThanOrEqualTo: endOfDay);
    }

    if (sortBy == 'price') {
      if (startDate != null) {
        q = q.orderBy('dates.startDate');
      }
    } else {
      q = q.orderBy('dates.startDate');
    }

    return q.snapshots().map((s) {
      final docs = s.docs.map((d) => {'id': d.id, ...d.data()}).toList();
      if (sortBy == 'price') {
        docs.sort((a, b) {
          final aPrice = (a['price'] as num?)?.toDouble() ?? 0;
          final bPrice = (b['price'] as num?)?.toDouble() ?? 0;
          return aPrice.compareTo(bPrice);
        });
      }
      return types == null || types.isEmpty
          ? docs
          : docs.where((item) => _tourMatchesAnyType(item, types)).toList();
    });
  }

  bool _tourMatchesAnyType(Map<String, dynamic> tour, List<String> filters) {
    final normalizedFilters = filters.map(_normalizeFilterValue).toSet();
    final tourTypes = _tourTypeValues(tour).map(_normalizeFilterValue).toSet();
    return tourTypes.any(normalizedFilters.contains);
  }

  List<String> _tourTypeValues(Map<String, dynamic> tour) {
    final value = tour['types'];
    if (value is List) {
      return value
          .map((item) => item?.toString() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }

    final fallback = tour['type']?.toString() ?? '';
    return fallback.isEmpty ? const [] : [fallback];
  }

  String _normalizeFilterValue(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[\s_]+'), '-');
  }

  // ---------------- Attractions ----------------
  Stream<List<Map<String, dynamic>>> streamAttractions({
    String? destinationId,
    String? category, // museum | nature | food ...
  }) {
    Query<Map<String, dynamic>> q = _db.collection('attractions');

    if (destinationId != null && destinationId.isNotEmpty) {
      q = q.where('destination.id', isEqualTo: destinationId);
    }
    if (category != null && category.isNotEmpty) {
      q = q.where('category', isEqualTo: category);
    }

    q = q.orderBy('ratingAvg', descending: true);

    return q.snapshots().map(
      (s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList(),
    );
  }

  // ---------------- Destinations ----------------
  Stream<List<Map<String, dynamic>>> streamDestinations({
    String? destinationName,
  }) {
    Query<Map<String, dynamic>> q = _db.collection('destinations');

    if (destinationName != null && destinationName.isNotEmpty) {
      q = q.where('name', isEqualTo: destinationName);
    }
    return q.snapshots().map(
      (s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList(),
    );
  }

  // ---------------- Reviews ----------------
  Stream<List<Map<String, dynamic>>> streamReviews({
    required String targetType,
    required String targetId,
  }) => _db
      .collection('reviews')
      .where('targetType', isEqualTo: targetType)
      .where('targetId', isEqualTo: targetId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());

  Stream<ReviewStats> streamReviewStats({
    required String targetType,
    required String targetId,
  }) {
    return streamReviews(targetType: targetType, targetId: targetId).map((
      reviews,
    ) {
      final ratings =
          reviews
              .map((review) => review['rating'])
              .whereType<num>()
              .map((rating) => rating.toDouble())
              .where((rating) => rating > 0)
              .toList();

      if (ratings.isEmpty) return const ReviewStats(average: 0, count: 0);

      final total = ratings.fold<double>(0, (total, rating) => total + rating);
      return ReviewStats(
        average: total / ratings.length,
        count: ratings.length,
      );
    });
  }

  Future<void> addReview({
    required String targetType,
    required String targetId,
    required String userUid,
    required String userName,
    required int rating,
    required String text,
  }) async {
    final reviewRef = _db
        .collection('reviews')
        .doc('${targetType}_${targetId}_$userUid');

    await reviewRef.set({
      'targetType': targetType,
      'targetId': targetId,
      'userUid': userUid,
      'userId': userName,
      'rating': rating,
      'text': text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _updateTargetRating(targetType: targetType, targetId: targetId);
  }

  Future<void> _updateTargetRating({
    required String targetType,
    required String targetId,
  }) async {
    String? collection;
    if (targetType == 'tour') {
      collection = 'tours';
    } else if (targetType == 'accommodation') {
      collection = 'accommodations';
    } else if (targetType == 'attraction') {
      collection = 'attractions';
    } else if (targetType == 'transport') {
      collection = 'transports';
    }
    if (collection == null) return;

    final snapshot =
        await _db
            .collection('reviews')
            .where('targetType', isEqualTo: targetType)
            .where('targetId', isEqualTo: targetId)
            .get();

    final ratings =
        snapshot.docs
            .map((doc) => doc.data()['rating'])
            .whereType<num>()
            .map((rating) => rating.toDouble())
            .where((rating) => rating > 0)
            .toList();

    if (ratings.isEmpty) {
      await _db.collection(collection).doc(targetId).set({
        'ratingAvg': 0,
        'ratingCount': 0,
      }, SetOptions(merge: true));
      return;
    }

    final total = ratings.fold<double>(0, (total, rating) => total + rating);
    await _db.collection(collection).doc(targetId).set({
      'ratingAvg': total / ratings.length,
      'ratingCount': ratings.length,
    }, SetOptions(merge: true));
  }

  // Storage URL
  Future<String> getDownloadUrl(String path) async =>
      await _storage.ref(path).getDownloadURL();

  // FirestoreRepo — اضافه‌ها

  // 4 ترنسپورت آخر (جدیدترین‌ها)
  Stream<List<Map<String, dynamic>>> streamLatestTransports({int limit = 4}) {
    return _db
        .collection('transports')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  // 4 اقامتگاه آخر
  Stream<List<Map<String, dynamic>>> streamLatestAccommodations({
    int limit = 4,
  }) {
    return _db
        .collection('accommodations')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  // 4 تور آخر
  Stream<List<Map<String, dynamic>>> streamLatestTours({int limit = 4}) {
    return _db
        .collection('tours')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }
}

class ReviewStats {
  const ReviewStats({required this.average, required this.count});

  final double average;
  final int count;
}
