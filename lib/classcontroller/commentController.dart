import 'dart:convert';
import 'package:assist_decisions_app/model/comment.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class CommentController {
  
  Future findCommentById(String postId) async{
    var url = Uri.parse(baseURL + '/comments/getCommentById/${postId}');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );  
    List<Comment>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Comment.fromJsonToComment(e)).toList();    
    return list;
    }
}
