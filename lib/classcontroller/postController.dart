import 'dart:convert';
import 'dart:io';
import 'package:assist_decisions_app/model/post.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class PostController {
  Post? posts;

  Future listAllPosts() async {
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


  Future listPosts(String username) async {
    var url = Uri.parse(baseURL + '/posts/listpost/${username}');
    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;
    print(response.body);
    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    print("--------------------------${list[0].postId}----------------------------------");
    return list;
  }

  Future listPostsAfter() async {
    var url = Uri.parse(baseURL + '/posts/listpreview');

    http.Response response = await http.post(url, headers: headers, body: null);
    // print(response.body);

    List<Post>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    return list;
  }

  Future listPostsInterest(String username) async {
    var url = Uri.parse(baseURL + '/posts/notify/${username}');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    print("-------------------------------post-----------------");
    return list;
  }





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

  Future listPostsMember(String username) async {
    var url = Uri.parse(baseURL + '/posts/listpost/${username}');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    print("-------------------------------post-----------------");
    return list;
  }



    Future doUpdateResult(String result,String postId) async {
    var url = Uri.parse(baseURL + '/posts/updateresult/${result}/${postId}');
    http.Response response = await http.post(url, headers: headers, body: null);
    final utf8body = utf8.decode(response.bodyBytes);
    print("-------------------------------${utf8body}-----------------");
  }

  Future getListCountMember(String? postId) async {
    var url = Uri.parse(baseURL + '/posts/count/$postId');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: null,
    );

    final utf8body = utf8.decode(response.bodyBytes);

    // ทำการแปลงค่าจาก String เป็น Int
    int countInt = int.tryParse(utf8body) ?? 0;
    print("----------count $countInt -----------");
    return countInt;
  }

  Future upload(File file) async {
    if (file == false) return;
//null
    var uri = Uri.parse(baseURL + "/posts/uploadimg");
    var length = await file.length();
    //print(length);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        // replace file with your field name exampe: image
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    //var jsonResponse = jsonDecode(response.body);
    return response.body;
  }
}
