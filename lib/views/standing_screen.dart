import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';

class UserRankingsScreen extends StatefulWidget {
  @override
  _UserRankingsScreenState createState() => _UserRankingsScreenState();
}

class _UserRankingsScreenState extends State<UserRankingsScreen> {
  String _selectedLanguage = 'English';
  ScrollController _scrollController = ScrollController();
  bool _hasScrolled = false;
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = getSortedUsersByWordCount(_selectedLanguage);
  }

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

    List<String> languages = [
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
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('World Rankings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: languages.map((language) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ChoiceChip(
                      label: FutureBuilder<String>(
                          future: LocalizationService()
                              .fetchFromFirestore(language, language),
                          builder: (context, snapshot) {
                            return Text(snapshot.data ?? '');
                          }),
                      selected: _selectedLanguage == language,
                      onSelected: (selected) {
                        setState(() {
                          _selectedLanguage = language;
                          _usersFuture =
                              getSortedUsersByWordCount(_selectedLanguage);
                        });
                      },
                      checkmarkColor: Colors.white,
                      selectedColor: kAppBarColor,
                      backgroundColor: Colors.grey[300],
                      labelStyle: TextStyle(
                        color: _selectedLanguage == language
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: FutureBuilder<String>(
                        future: LocalizationService().fetchFromFirestore(
                          'No data available',
                          'No data available',
                        ),
                        builder: (context, snapshot) {
                          return Text(snapshot.data ?? '');
                        },
                      ),
                    );
                  } else {
                    List<Map<String, dynamic>> usersData = snapshot.data!;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (user != null) {
                        // _scrollToUser(user.uid, usersData);
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
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
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          child: Card(
                            elevation: 4,
                            color: isCurrentUser ? kGeminiColor : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: isCurrentUser
                                  ? BorderSide(color: kGeminiColor, width: 2.0)
                                  : BorderSide.none,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user1[
                                        'userPicture'] ??
                                    'https://via.placeholder.com/150'), // Default picture if none provided
                              ),
                              title: Text(
                                user1['userName'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: FutureBuilder<String>(
                                  future:
                                      LocalizationService().fetchFromFirestore(
                                    'learned Words',
                                    'learned Words',
                                  ),
                                  builder: (context, snapshot) {
                                    return Text(
                                        '${snapshot.data ?? ''}: ${user1['correctWordsCount']}');
                                  }),
                              trailing: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kGeminiColor,
                                  border: Border.all(
                                      color: Colors.white, width: 2.0),
                                ),
                                child: Center(
                                  child: Text(
                                    '${user1['rank']}',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
          ),
        ],
      ),
    );
  }
}
