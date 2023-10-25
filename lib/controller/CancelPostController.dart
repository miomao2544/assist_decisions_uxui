
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class CancelPostController{

    Future doDeletePost(String postId) async {
    var url = Uri.parse(baseURL + '/posts/delete/${postId}');

    http.Response response = await http.post(url, headers: headers, body: null);
    final utf8body = utf8.decode(response.bodyBytes);
    print("-------------------------------${utf8body}-----------------");
  }

}