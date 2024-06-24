import 'package:cloud_firestore/cloud_firestore.dart';

class UsageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setUsageLimit(String userId, int minutes) async {
    await _db.collection('users').doc(userId).set({'usageLimit': minutes}, SetOptions(merge: true));
  }

  Future<int> getUsageLimit(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    return doc['usageLimit'] ?? 0;
  }

  Future<void> updateUsage(String userId, int minutesUsed) async {
    await _db.collection('users').doc(userId).update({'minutesUsed': FieldValue.increment(minutesUsed)});
  }

  Stream<DocumentSnapshot> usageStream(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }
}
