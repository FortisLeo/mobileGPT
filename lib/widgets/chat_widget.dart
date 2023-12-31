import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatz_gpt_mobile/constants/colors.dart';
import 'package:chatz_gpt_mobile/screens/chat_screen.dart';
import 'package:chatz_gpt_mobile/services/assets_manager.dart';
import 'package:chatz_gpt_mobile/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key, required this.msg, required this.chatIndex}) : super(key: key);

  final String msg;
  final int chatIndex;


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Material(
          color: chatIndex==0? scaffoldBackgroundColor: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex==0? AssetsManager.userImage:AssetsManager.botImage,
                  height: 30,
                  width: 30,),
                SizedBox(width: 8,),
                Expanded(child: chatIndex == 0? TextWidget(label: msg):DefaultTextStyle(style:TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),child: AnimatedTextKit(animatedTexts: [TyperAnimatedText(msg.trim())],isRepeatingAnimation: false,repeatForever: false,displayFullTextOnTap: true,totalRepeatCount: 1, )),),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    :  Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              _copyToClipboard(msg.trim());
                              }
                            ,child: Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          // Icon(
                          //   Icons.thumb_down_alt_outlined,
                          //   color: Colors.white,
                          // )
                        ],
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

}
