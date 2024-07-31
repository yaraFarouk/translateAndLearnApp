import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/widgets/return_button.dart';

class UserRankingsScreen extends StatefulWidget {
  @override
  _UserRankingsScreenState createState() => _UserRankingsScreenState();
}

class _UserRankingsScreenState extends State<UserRankingsScreen> {
  String _selectedLanguage = 'English';
  ScrollController _scrollController = ScrollController();
  bool _hasScrolled = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchUsersWithWordCounts(
      String language) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final usersSnapshot = await usersCollection.get();

    List<Map<String, dynamic>> usersData = [];

    for (var userDoc in usersSnapshot.docs) {
      final userId = userDoc.id;
      final userName = userDoc['name'];
      // final userPicture = userDoc['picture']; // Assuming you have user picture URL

      final correctWordsSnapshot = await FirebaseFirestore.instance
          .collection('all_words')
          .doc(userId)
          .collection(language)
          .where('isCorrect', isEqualTo: true)
          .get();

      int correctWordsCount = correctWordsSnapshot.size;

      usersData.add({
        'userId': userId,
        'userName': userName,
        //'userPicture': userPicture,
        'correctWordsCount': correctWordsCount,
      });
    }

    return usersData;
  }

  Future<List<Map<String, dynamic>>> getSortedUsersByWordCount(
      String language) async {
    List<Map<String, dynamic>> usersData =
        await fetchUsersWithWordCounts(language);

    usersData.sort(
        (a, b) => b['correctWordsCount'].compareTo(a['correctWordsCount']));

    return usersData;
  }

  void _scrollToUser(String userId, List<Map<String, dynamic>> usersData) {
    int index = usersData.indexWhere((user) => user['userId'] == userId);
    if (index != -1 && !_hasScrolled) {
      _scrollController
          .animateTo(
        index * 100.0, // Adjust this value as needed
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      )
          .then((_) {
        setState(() {
          _hasScrolled = true; // Disable further scrolling
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: Image.asset(
                "assets/images/logo.png",
                height: 80.h,
              ),
            ),
          ),
          Container(
            width: 150.w,
            height: 40.h,
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: kAppBarColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                DropdownButton<String>(
                  borderRadius: BorderRadius.circular(8),
                  dropdownColor: kAppBarColor,
                  value: _selectedLanguage,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  underline: Container(
                    height: 2,
                    color: kAppBarColor, // No underline
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                  items: <String>[
                    'English',
                    'Spanish',
                    'French',
                    'German',
                    'Italian',
                    'Portuguese',
                    'Chinese',
                    'Japanese',
                    'Polish',
                    'Turkish',
                    'Russian',
                    'Dutch',
                    'Korean'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getSortedUsersByWordCount(_selectedLanguage),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<Map<String, dynamic>> usersData = snapshot.data!;

                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    if (user != null) {
                      _scrollToUser(user.uid, usersData);
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: usersData.length,
                    itemBuilder: (context, index) {
                      final user1 = usersData[index];
                      bool isCurrentUser = user1['userId'] == user?.uid;

                      // Calculate the rank, considering ties
                      int rank = 1;
                      if (index > 0 &&
                          usersData[index]['correctWordsCount'] ==
                              usersData[index - 1]['correctWordsCount']) {
                        rank = usersData[index - 1]['rank'];
                      } else {
                        rank = index + 1;
                      }
                      usersData[index]['rank'] = rank;

                      return Container(
                        height: 100.h, // Fixed height for the card
                        child: Card(
                          color: isCurrentUser ? Colors.white : kGeminiColor,
                          shape: isCurrentUser
                              ? RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: kGeminiColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                )
                              : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user1[
                                      'userPicture'] ??
                                  'https://via.placeholder.com/150'), // Default picture if none provided
                            ),
                            title: Text(user1['userName']),
                            subtitle: Text(
                                'learned Words: ${user1['correctWordsCount']}'),
                            trailing: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border:
                                    Border.all(color: kGeminiColor, width: 2.0),
                              ),
                              child: Center(
                                child: Text(
                                  '${user1['rank']}',
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const ReturnButton(),
        ],
      ),
    );
  }
}
