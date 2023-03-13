import 'package:cached_network_image/cached_network_image.dart';
import 'package:can_we_chat/helper/dialogs.dart';
import 'package:can_we_chat/models/chat_user.dart';
import 'package:can_we_chat/screens/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/apis.dart';
import '../main.dart';

// profile screen -- to show signed in user info

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //App Bar
        appBar: AppBar(
          title: const Text('Profile Screen'),
        ),

        // floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              //for showing progress dialog
              Dialogs.showProgressBar(context);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  // For hiding progress dialog
                  Navigator.pop(context);
                  // for moving to home screen
                  Navigator.pop(context);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              // For Adding some Space
              SizedBox(width: mq.width, height: mq.height * .03),

              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {},
                      elevation: 1,
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
              // For Adding some Space
              SizedBox(height: mq.height * .03),
              // user email lable
              Text(widget.user.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 16)),

              // For Adding some Space
              SizedBox(height: mq.height * .05),

              // For Adding input feild
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(
                  prefix: const Icon(Icons.person, color: Colors.blue),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "eg. Honey Singh",
                  label: const Text('Name'),
                ),
              ),

              // For Adding some Space
              SizedBox(height: mq.height * .02),

              // About input feild
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                  prefix: const Icon(Icons.info_outline, color: Colors.blue),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "eg. Developer/Happy",
                  label: const Text('About'),
                ),
              ),

              // For Adding some Space
              SizedBox(height: mq.height * .05),

              //Update profile Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * .06)),
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 28),
                label: const Text('UPDATE', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ));
  }
}
