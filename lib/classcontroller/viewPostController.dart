import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ViewPostController{
    Future addViewPost(String postId,String username)async{
    Map data = {
      "username" : username,
      "postId" : postId,
    };

   var body = json.encode(data);
    var url = Uri.parse(baseURL + '/viewposts/add');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body
    );
    var jsonResponse = jsonDecode(response.body);
    return  jsonResponse;
  }
}