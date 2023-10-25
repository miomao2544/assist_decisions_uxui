import 'dart:convert';
import 'dart:io';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ChoiceController{
  Choice? choices;
  Future addChoice(String choiceName,String choiceImages,String postId)async{
    Map data = {
      "choiceName" : choiceName,
      "choiceImage" : choiceImages,
      "postId" : postId,
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

    Future editChoice(String status,String choiceId,String choiceName,String choiceImages,String postId)async{
   
    Map data = {
      "status":status,
      "choiceId": choiceId,
      "choiceName" : choiceName,
      "choiceImage" : choiceImages,
      "postId" : postId,
    };

   var body = json.encode(data);
    var url = Uri.parse(baseURL + '/choices/update');

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

    Future upload(File file) async {
    if (file == false) return;
//null
    var uri = Uri.parse(baseURL + "/choices/uploadimg");
    var length = await file.length();
    print(length);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    return response.body;
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