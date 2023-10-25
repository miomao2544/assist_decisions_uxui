import 'dart:convert';
import 'dart:io';
import 'package:assist_decisions_app/model/post.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class SearchPostController{

  Future doSearchPost(
      String title, String interests, String point, String daterequest) async {
    var url = Uri.parse(baseURL +
        '/posts/search?title=$title&interests=$interests&point=$point&daterequest=$daterequest');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    print("-------------------------------Search post-----------------");
    return list;
  }

}