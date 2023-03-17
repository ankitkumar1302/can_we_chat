// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // For Adding some Space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    Stack(
                      children: [
                        // Profile picture
                        _image != null
                            ? ClipRRect(
                                // Local image
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover
                                ))
                            :

                            // Image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
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
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // For Adding some Space
                    SizedBox(height: mq.height * .05),

                    // For Adding input feild
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required feild',
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
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required feild',
                      decoration: InputDecoration(
                        prefix:
                            const Icon(Icons.info_outline, color: Colors.blue),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile Updated Successfully!');
                          });
                        }
                      },
                      icon: const Icon(Icons.edit, size: 28),
                      label:
                          const Text('UPDATE', style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // Bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              // Pick profile picture lable
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              // For Adding some space
              SizedBox(
                height: mq.height * .02,
              ),

              //Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log('Image Path: ${image.path}-- Mime type ${image.mimeType}');

                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          //for hindind bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/gallery.png')),

                  // Take picture from camera buttom
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {

                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log('Image Path: ${image.path}');

                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // For hiding botton sheet
                          Navigator.pop(context);
                        }
                       
                      },
                      child: Image.asset('images/photo.png'))
                ],
              )
            ],
          );
        });
  }
}
