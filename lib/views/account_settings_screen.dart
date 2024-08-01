import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../cubit/register/Register_Cubit.dart';
import 'language_selection_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  UserData? userModel;
  bool hiddenPass = true;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    String UID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(UID)
        .get()
        .then((onValue) {
      userModel = UserData.fromFire(onValue.data()!);
    });

    setState(() {
      // userModel = UserData.fromFire(documentSnapshot.data());
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: kAppBarColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Account Settings',
          style: TextStyle(color: kAppBarColor),
        ),
      ),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                    // Name
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.grey[300],
                        style: ListTileStyle.list,
                        contentPadding: EdgeInsetsDirectional.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: Icon(Icons.person_outline_rounded),
                        title: Text(
                          userModel!.name.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Navigate to change password screen
                        },
                      ),
                    ),
                    // Email
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.grey[300],
                        style: ListTileStyle.list,
                        contentPadding: EdgeInsetsDirectional.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: Icon(Icons.alternate_email_rounded),
                        title: Text(
                          userModel!.email.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Navigate to change password screen
                        },
                      ),
                    ),
                    // Password
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.grey[300],
                        style: ListTileStyle.list,
                        contentPadding: EdgeInsetsDirectional.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: Icon(Icons.key_outlined),
                        trailing: IconButton(
                          onPressed: ()
                          {
                            setState(() {
                              hiddenPass = !hiddenPass;
                            });
                          },
                          icon: Icon(Icons.remove_red_eye_outlined),
                        ),
                        title: Text(
                          hiddenPass ? "******" : userModel!.password.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Navigate to change password screen
                        },
                      ),
                    ),
                    // Sign Out
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        tileColor: Colors.red[400],
                        style: ListTileStyle.list,
                        contentPadding: EdgeInsetsDirectional.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading:
                            Icon(Icons.logout_rounded, color: Colors.white),
                        title: Text(
                          "Sign Out",
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          FirebaseAuth.instance.signOut().then((onValue) async {
                            print("user logged out successfully");
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('hasSeenWelcome', false);

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LanguageSelectionPage()),
                                (Route<dynamic> route) => false);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
