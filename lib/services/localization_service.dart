import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  Future<String> getUserLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nativeLanguageCode = prefs.getString('nativeLanguageCode');
    return nativeLanguageCode!;
  }

  Future<String> fetchFromFirestore(String text, String temp) async {
    try {
      String languageCode = await getUserLanguageCode();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('localizations')
          .doc(languageCode) // Use the current language code
          .get();

      if (snapshot.exists) {
        return snapshot.get(text) ?? temp; // Fallback
      } else {
        return temp; // Default fallback
      }
    } catch (e) {
      print("Error fetching title: $e");
      return temp; // Error fallback
    }
  }
}
