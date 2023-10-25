import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class RegisterController{
  Future doRegister(
      String username,
      String password,
      String nickname,
      String gender,
      String firstname,
      String lastname,
      String email,
      String tel,
      String imageName,
      String interestId) async {
    Map<String, String> data = {
      "username": username,
      "password": password,
      "nickname": nickname,
      "gender": gender,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "tel": tel,
      "image": imageName,
      "adminstatus": "false",
      "interests": interestId
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/members/add');
    print("----------------Resister add------------");
    http.Response response = await http.post(url, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

}