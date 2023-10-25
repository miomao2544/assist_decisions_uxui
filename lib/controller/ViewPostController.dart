import 'dart:convert';
import 'package:assist_decisions_app/model/post.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ViewPostController{
  
    Future<Post?> getPostById(String postId) async {
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
}