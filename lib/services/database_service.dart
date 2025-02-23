import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTestResult({
    required String userId,
    required double sugarLevel,
    required DateTime timestamp,
  }) async {
    await _db.collection('test_results').add({
      'userId': userId,
      'sugarLevel': sugarLevel,
      'timestamp': timestamp.toIso8601String(),
    });
  }

  Stream<QuerySnapshot> getTestResults(String userId) {
    return _db
        .collection('test_results')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}