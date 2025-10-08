import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirestoreRepo {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // ---------------- Config ----------------
  Stream<Map<String, dynamic>?> streamFilterOptions() =>
      _db.collection('system').doc('config').snapshots().map((s) => s.data());

  // ---------------- Accommodations ----------------
  Stream<List<Map<String, dynamic>>> streamAccommodations({
    String? destinationName,
    String? destinationId,
    List<String>? types,
    DateTime? startDate, // NEW
    DateTime? endDate,
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

      if (startDate == null) return docs;

      // فقط-تاریخ به‌صورت لوکال (بدون UTC)
      final sel = DateUtils.dateOnly(startDate);

      return docs.where((item) {
        final av = item['availability'];
        if (av is! List || av.isEmpty) return false;

        return av.any((slot) {
          if (slot is! Map) return false;

          final tsFrom = slot['from'] as Timestamp?;
          final tsTo = slot['to'] as Timestamp?;
          if (tsFrom == null || tsTo == null) return false;

          final f = DateUtils.dateOnly(tsFrom.toDate());
          final t = DateUtils.dateOnly(tsTo.toDate());

          final ok = !sel.isBefore(f) && !sel.isAfter(t);

          // --- دیباگ موقت، اگر خواستی ببینی چرا رد می‌شود:
          //print('[$sel] in [$f .. $t] => $ok');

          return ok;
        });
      }).toList();
    });
  }

  // ---------------- Transports ----------------
  Stream<List<Map<String, dynamic>>> streamTransports({
    String? fromCode,
    String? toCode, // ← اختیاری
    List<String>? modes, // flight | train | bus | boat
    DateTime? startDate, // NEW
    DateTime? endDate,
    String? sortBy, // 'price' | 'duration'
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
      q = q.where('schedule.departAt', isGreaterThanOrEqualTo: startDate);
    }
    // if (endDate != null) {
    //   q = q.where('schedule.arriveAt', isLessThanOrEqualTo: endDate);
    // }

    // برای MVP: قیمت؛ اگر duration می‌خواهی، یا فیلد duration ذخیره کن یا کلاینت سورت کند.
    if (sortBy == 'date') {
      q = q.orderBy('schedule.departAt');
    } else {
      q = q.orderBy('basePrice');
    }

    return q.snapshots().map(
      (s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList(),
    );
  }

  // ---------------- Tours ----------------
  Stream<List<Map<String, dynamic>>> streamTours({
    String? destinationId,
    String? originId,
    List<String>? types, // nature | city | ...
    DateTime? startDate, // NEW
    DateTime? endDate,
    String? sortBy, // 'price' | 'rating'
  }) {
    Query<Map<String, dynamic>> q = _db.collection('tours');

    if (destinationId != null && destinationId.isNotEmpty) {
      q = q.where('destination.id', isEqualTo: destinationId);
    }
    if (originId != null && originId.isNotEmpty) {
      q = q.where('origin.id', isEqualTo: originId);
    }
    if (types != null && types.isNotEmpty) {
      q = q.where('type', whereIn: types);
    }
    if (startDate != null) {
      q = q.where('dates.startDate', isGreaterThanOrEqualTo: startDate);
    }
    // if (endDate != null) {
    //   q = q.where('dates.endDate', isLessThanOrEqualTo: endDate);
    // }
    if (sortBy == 'date') {
      q = q.orderBy('dates.startDate');
    } else {
      q = q.orderBy('price');
    }

    return q.snapshots().map(
      (s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList(),
    );
  }

  // ---------------- Attractions ----------------
  Stream<List<Map<String, dynamic>>> streamAttractions({
    String? destinationId,
    String? category, // museum | nature | food ...
  }) {
    Query<Map<String, dynamic>> q = _db.collection('attractions');

    if (destinationId != null && destinationId.isNotEmpty) {
      q = q.where('destinationId', isEqualTo: destinationId);
    }
    if (category != null && category.isNotEmpty) {
      q = q.where('category', isEqualTo: category);
    }

    q = q.orderBy('ratingAvg', descending: true);

    return q.snapshots().map(
      (s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList(),
    );
  }

  // ---------------- dDestinations ----------------
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
