import 'dart:convert';
import 'package:assist_decisions_app/model/post.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class PreviewPostController{

  
  Future getPreviewPost() async {
    var url = Uri.parse(baseURL + '/posts/list');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;
    print(response.body);
    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    print("--------------------------${list[0].postId}----------------------------------");
    return list;
  }
}