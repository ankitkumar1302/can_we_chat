import 'package:cached_network_image/cached_network_image.dart';
import 'package:can_we_chat/main.dart';
import 'package:can_we_chat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

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
        onTap: () {
          // Navigate to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));

        },
        child: ListTile(
          //Use Profile
          // leading:const CircleAvatar(child: Icon(CupertinoIcons.person)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          //User Name
          title: Text(widget.user.name),

          // Subtitles
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          // Last message time
          trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(color: Colors.greenAccent.shade400,borderRadius: BorderRadius.circular(10)),

          )
          ),

          //  trailing: const Text(
          //   '10:00 PM',
          //   style: TextStyle(color: Colors.black54),
          // ),
       // ),
      ),
    );
  }
}
