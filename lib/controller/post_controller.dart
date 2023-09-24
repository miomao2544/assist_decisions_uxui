import 'dart:convert';
import 'dart:io';
import 'package:assist_decisions_app/model/post.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class PostController {
  Post? posts;

  Future addPost(
      String title,
      File image,
      String description,
      String postPoint,
      String dateStart,
      String dateStop,
      String qtyMax,
      String qtyMin,
      String username,
      String interestId) async {
    var imageName = await upload(image);

    Map data = {
      "postImage": imageName.toString(),
      "title": title,
      "description": description,
      "postPoint": postPoint,
      "result": "1",
      "dateStart": dateStart,
      "dateStop": dateStop,
      "qtyMax": qtyMax,
      "qtyMin": qtyMin,
      "username": username,
      "interestId": interestId,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/posts/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    // print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return jsonResponse;
  }

  Future updatePost(
      String postID,
      String title,
      String image,
      String description,
      String postPoint,
      String dateStart,
      String dateStop,
      String qtyMax,
      String qtyMin,
      String username,
      String interestId) async {
    // var imageName = await upload(image);
    print(postID +
        title +
        image +
        description +
        postPoint +
        dateStart +
        dateStop +
        qtyMax +
        qtyMin +
        username +
        interestId);
    Map data = {
      "postId": postID,
      "postImage": image,
      "title": title,
      "description": description,
      "postPoint": postPoint,
      "result": "1",
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
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return jsonResponse;
  }

  Future listAllPosts() async {
    var url = Uri.parse(baseURL + '/posts/list');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    return list;
  }

    Future listSearchPostsAll(String title,String interests,String point,String daterequest)async {
    var url = Uri.parse(baseURL + '/posts/search?title=$title&interests=$interests&point=$point&daterequest=$daterequest');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    print("-------------------------------Search post-----------------");
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
    var url = Uri.parse(baseURL + '/posts/list/${username}');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Post>? list;

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Post.fromJsonToPost(e)).toList();
    print("-------------------------------post-----------------");
    return list;
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
