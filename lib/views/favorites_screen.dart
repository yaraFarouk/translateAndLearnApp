import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _removeFavorite(BuildContext context, String docId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('favorites');

    await favoritesRef.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favoriteDocs = snapshot.data!.docs;

          if (favoriteDocs.isEmpty) {
            return const Center(
              child: Text(
                'No favorites added yet!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteDocs.length,
            itemBuilder: (context, index) {
              final favorite = favoriteDocs[index];

              return Card(
                color: kTranslationCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'From: ${favorite['languageFrom']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.solidStar,
                                color: kAppBarColor),
                            onPressed: () =>
                                _removeFavorite(context, favorite.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ' ${favorite['text']}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'To: ${favorite['languageTo']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ' ${favorite['translation']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
