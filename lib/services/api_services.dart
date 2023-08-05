import 'dart:convert';
import 'dart:io';
import 'package:chatz_gpt_mobile/constants/api_constants.dart';
import 'package:chatz_gpt_mobile/models/chat_model.dart';
import 'package:chatz_gpt_mobile/models/models_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ApiService{
  static Future<List<ModelsModel>> getModels() async{
    try{
      var response = await http.get(Uri.parse("$BASE_URL/models"),
      headers: {'Authorization': 'Bearer $API_KEY'});
      Map jsonResponse = jsonDecode(response.body);

      if(jsonResponse['error']!=null){
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);

      }
      // print("json response $jsonResponse");
      List temp = [];
      for(var value in jsonResponse['data']){
        temp.add(value);
        log("temp ${value['id']}");
      }
      return ModelsModel.modelsFromSnapshot(temp);

    } catch(error){
      log("error $error");
      rethrow;
    }

  }

  static Future<List<ChatModel>> sendMessage({required String message, required String modelId}) async {
    try {
      var response = await http.post(Uri.parse("$BASE_URL/chat/completions"),
          headers: {'Authorization': 'Bearer $API_KEY',
                    'Content-Type': 'application/json'},
        body: jsonEncode({"model": "gpt-3.5-turbo" , "messages": [{"role" : "user", "content": message }]}));
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      // print("json response $jsonResponse");
      if(jsonResponse['choices'].length>0){
        chatList = List.generate(jsonResponse['choices'].length, (index) => ChatModel(msg: jsonResponse['choices'][0]['message']['content'], chatIndex: 1));
        // log("jsonREsponse[choices]text ${jsonResponse['choices'][0]['text']}");
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}