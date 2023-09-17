import 'dart:convert';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ChoiceController{
  Choice? choices;
  Future addChoice(String choiceName,String choiceImage,String postID)async{

    Map data = {
      "choiceName" : choiceName,
      "choiceImage" : choiceImage,
      "postID" : postID,
    };

   var body = json.encode(data);
    var url = Uri.parse(baseURL + '/choices/add');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body
    );
    // print(response.body);
    var jsonResponse = jsonDecode(response.body);
    // print(jsonResponse); 
    return  jsonResponse;
  }

    Future listAllChoicesById(String postId) async{
    var url = Uri.parse(baseURL + '/choices/getChoiceById/${postId}');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );  
    List<Choice>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Choice.fromJsonToChoice(e)).toList();    
    return list;
  
    }

}