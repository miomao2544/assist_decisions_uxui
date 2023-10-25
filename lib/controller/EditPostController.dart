

import 'dart:convert';

import 'package:assist_decisions_app/model/post.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';
class EditPostController{
  
      Future<Post?> doPostDetail(String postId) async {
    try {
      var url = Uri.parse(baseURL + '/posts/view/$postId');
      http.Response response =
          await http.post(url, headers: headers, body: null);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonMap = json.decode(utf8Body);
        Post? post = Post.fromJsonToPost(jsonMap);
        return post;
      } else {
        print("ไม่สามารถดึงข้อมูลโพสต์ได้: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("เกิดข้อผิดพลาดในการเชื่อมต่อ: $error");
      return null;
    }
  }


   Future doEditPost(String postId,
      String title,
      String image,
      String description,
      String postPoint,
      String dateStart,
      String dateStop,
      String qtyMin,
      String qtyMax,
      String username,
      String interestId) async {
    Map data = {
      "postId":postId,
      "postImage": image,
      "title": title,
      "description": description,
      "postPoint": postPoint,
      "dateStart": dateStart,
      "dateStop": dateStop,
      "qtyMax": qtyMax,
      "qtyMin": qtyMin,
      "username": username,
      "interestId": interestId,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/posts/update');

    http.Response response = await http.post(url, headers: headers, body: body);
    // print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return jsonResponse;
  }
}