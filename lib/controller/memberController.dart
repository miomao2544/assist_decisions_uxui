import 'dart:convert';
import 'dart:io';
import '../model/interest.dart';
import '../model/member.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class MemberController {
  Member? member;

  Future<bool> checkUsernameExists(String username) async {
    var url = Uri.parse(baseURL + '/members/uq/$username');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: null,
    );
    print(response.body);
    if (response.body.toLowerCase() == 'true') {
      return true;
    } else {
      return false;
    }
  }



Future updateMember(
      String username,
      String password,
      String nickname,
      String gender,
      String firstname,
      String lastname,
      String email,
      String tel,
      String point,
      String status,
      String imageName,
      String interestId) async {
    Map<String, String> data = {
    "username" : username,
    "adminstatus" : "false",
    "email" : email,
    "firstname" : firstname,
    "gender" : gender,
    "image" : imageName,
    "lastname" : lastname,
    "nickname" : nickname,
    "password" : password,
    "point" : point,
    "status" : status,
    "tel" : tel,
    "interests" : interestId
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/members/update');
    print("----------------Resister add------------");
    http.Response response = await http.post(url, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  Future upload(File file) async {
    if (file == false) return;
    var uri = Uri.parse(baseURL + "/members/uploadimg");
    var length = await file.length();
    print(length);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    return response.body;
  }


  Future doLoginAdmin(String username,String password) async {
    var url = Uri.parse(baseURL + "/members/loginmember/${username}/${password}");
     http.Response response = await http.post(url, headers: headers, body: null);
    return response.body;
  }

  Future<Member?> getMemberById(String username) async {
    try {
      var url = Uri.parse(baseURL + '/members/getProfile/$username');

      http.Response response =
          await http.post(url, headers: headers, body: null);

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonMap = json.decode(utf8Body);
        Member? member = Member.fromJsonToMember(jsonMap);

        if (member.interests != null) {
          print("Interests:");
          for (Interest interest in member.interests!) {
            print(interest.interestName);
          }
        } else {
          print("ไม่พบข้อมูล Interest สำหรับสมาชิกนี้");
        }

        return member;
      } else {
        print("ไม่สามารถดึงข้อมูลสมาชิกได้: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("เกิดข้อผิดพลาดในการเชื่อมต่อ: $error");
      return null;
    }
  }


    Future doUpdatePoint(String username,String point) async {
    var url = Uri.parse(baseURL + '/members/updatepoint/${username}/${point}');
    http.Response response = await http.post(url, headers: headers, body: null);
    final utf8body = utf8.decode(response.bodyBytes);
    print("-------------------------------${utf8body}-----------------");
  }

    Future doUpdatePointVote(String username,String point) async {
    var url = Uri.parse(baseURL + '/members/pointvote/${username}/${point}');
    http.Response response = await http.post(url, headers: headers, body: null);
    final utf8body = utf8.decode(response.bodyBytes);
    print("-------------------------------${utf8body}-----------------");
  }

Future<List<String>> getUsernameVotePost(String postId) async {
  var url = Uri.parse(baseURL + '/members/usernamevotepost/${postId}');

  http.Response response = await http.post(url, headers: headers, body: null);
  final utf8body = utf8.decode(response.bodyBytes);
  List<dynamic> jsonList = json.decode(utf8body);
  print("object--------------------${jsonList.cast<String>()}-------------");
  return jsonList.cast<String>();
}

}
