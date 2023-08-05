import 'dart:developer';

import 'package:chatz_gpt_mobile/constants/colors.dart';
import 'package:chatz_gpt_mobile/constants/constants.dart';
import 'package:chatz_gpt_mobile/providers/chat_provider.dart';
import 'package:chatz_gpt_mobile/services/api_services.dart';
import 'package:chatz_gpt_mobile/services/assets_manager.dart';
import 'package:chatz_gpt_mobile/services/services.dart';
import 'package:chatz_gpt_mobile/widgets/chat_widget.dart';
import 'package:chatz_gpt_mobile/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../providers/models_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
   bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    // TODO: implement initState
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {

    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("chatGPT"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                  itemCount: chatProvider.getChatList.length ,//chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatProvider.getChatList[index].msg, //chatList[index].msg,
                      chatIndex:chatProvider.getChatList[index].chatIndex,);  //[index].chatIndex);
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,),],
              SizedBox(height: 15,),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value)
                            async {await sendMessageFCT(modelsProvider: modelsProvider, chatProvider: chatProvider);},
                          decoration: InputDecoration.collapsed(
                              hintText: "how can i help you",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {await sendMessageFCT(modelsProvider: modelsProvider, chatProvider: chatProvider);},
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );


    }

  void scrollListToEnd(){
    _listScrollController.animateTo(_listScrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
  }
   Future<void> sendMessageFCT({required ModelsProvider modelsProvider, required ChatProvider chatProvider}) async{
     try{
       String msg = textEditingController.text;
       setState(() {
         _isTyping=true;
         // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
         chatProvider.addUserMessage(msg: msg);

         textEditingController.clear();
         focusNode.unfocus();
       });
       await chatProvider.sendMessageAndGetAnswers(msg: msg, chosenModelId: modelsProvider.getCurrentModel);

       // chatList.addAll(await ApiService.sendMessage(message: textEditingController.text, modelId: modelsProvider.getCurrentModel));

      setState(() {
      });

     } catch(error){
       print("error $error");
     } finally{
       scrollListToEnd();
       setState(() {
         _isTyping=false;
       });
     }
   }

   // void copy(){
   //   Clipboard.setData(ClipboardData(text: "hi"));
   // }
}
