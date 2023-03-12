import 'package:cached_network_image/cached_network_image.dart';
import 'package:can_we_chat/main.dart';
import 'package:can_we_chat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {


  @override
  Widget build(BuildContext context) {
    return Card(

      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child:   ListTile(
          //Use Profile
           
          // leading:const CircleAvatar(child: Icon(CupertinoIcons.person)),
          leading:CachedNetworkImage(
            width: mq.height * .055,
            height: mq.height * .055,
        imageUrl: widget.user.image,
        // placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person)),
     ),
          //User Name
          title: Text(widget.user.name),
          
          // Subtitles 
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          
          // Last message time
          trailing: const Text(
           '10:00 PM',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}