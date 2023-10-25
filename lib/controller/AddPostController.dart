
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class AddPostController{
    Future doAddPost(
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
    var url = Uri.parse(baseURL + '/posts/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    // print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    return jsonResponse;
  }
}