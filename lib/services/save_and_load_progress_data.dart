import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void updateProgress(String language, int scoreChange) {
  final user = FirebaseAuth.instance.currentUser;
  final uid = user?.uid;

  if (uid != null) {
    final trackProgressRef = FirebaseFirestore.instance
        .collection('track_progress')
        .doc(uid)
        .collection(language);

    final now = DateTime.now();
    final date = '${now.year}-${now.month}-${now.day}';

    trackProgressRef.doc(date).get().then((doc) {
      if (doc.exists) {
        final currentScore = doc.data()?['score'] ?? 0;
        trackProgressRef
            .doc(date)
            .update({'score': currentScore + scoreChange});
      } else {
        trackProgressRef.doc(date).set({'score': scoreChange});
      }
    });
  }
}
