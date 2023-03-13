import 'dart:developer';
import 'package:can_we_chat/main.dart';
import 'package:can_we_chat/models/chat_user.dart';
import 'package:can_we_chat/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/apis.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // For storing all user
  List<ChatUser> _list = [];
  // For storing searched items.
  final List<ChatUser> _searchList =[];
  // For storing search status
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Hide keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }

        },
        child: Scaffold(
          //App Bar
          appBar: AppBar(
            leading:  const Icon(CupertinoIcons.home),
            title:_isSearching ?
             TextField(
              decoration: const InputDecoration(
                 border: InputBorder.none,hintText: 'Name,Email,...'
              ),autofocus: true,
              style: const TextStyle(fontSize: 17,letterSpacing: .5),
              onChanged: (val){
          
                //search Logic
                _searchList.clear();
                for (var i in _list){
                  if (i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())) {
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
              },
            )
            : const Text('Can We Chat?'),
            actions: [
              //Search user button
              IconButton(onPressed: () {
                setState(() {
                  _isSearching =!_isSearching;
                });
          
              }, icon: Icon(_isSearching ? CupertinoIcons.clear:Icons.search)),
          
              //more Feature Button
              IconButton(onPressed: () {
          
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: APIs.me)));
          
              }, icon: const Icon(Icons.more_vert))
            ],
          ),
          
          // floating button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // If data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
          
                // If some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
          
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount: _isSearching ? _searchList.length:_list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(user: _isSearching ? _searchList[index]:_list[index]);
                          // return Text('Name: ${list[index]}');
                        });
                  } else {
                    log('error $_list.data');
                    return const Center(child: Text('No Connections Found!',style: TextStyle(fontSize: 20)));
                    
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
