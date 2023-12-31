import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class CommentPostController{
    Future doCommentPost(String comment, String username, String postId) async {
    Map data = {
      "comment": comment,
      "username": username,
      "postId": postId,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/comments/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}