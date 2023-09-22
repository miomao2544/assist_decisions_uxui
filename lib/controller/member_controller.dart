import 'dart:convert';
import 'dart:io';
import '../model/interest.dart';
import '../model/member.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class MemberController {
  Member? member;

  Future addMember(
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
  Map<String, dynamic> data = {
    "username": username,
    "password": password,
    "nickname": nickname,
    "gender": gender,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "tel": tel,
    "image": imageName,
    "adminstatus": false,
    "interests": [interestId]
  };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/members/add');

    print("----------------body------------" + body);
    http.Response response = await http.post(url, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != null && jsonResponse['success'] == true) {
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
      String imageName,
      String interestId) async {
    Map data = {
      "username": username,
      "adminstatus": "0",
      "email": email,
      "firstname": firstname,
      "gender": gender,
      "image": imageName,
      "lastname": lastname,
      "nickname": nickname,
      "password": password,
      "tel": tel,
      "interestId": interestId
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/members/update');

    print("----------------body------------" + body);
    http.Response response = await http.post(url, headers: headers, body: body);
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse != null && jsonResponse['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future upload(File file) async {
    if (file == false) return;
//null
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

  // Future getMemberById(String username) async {
  //   var url = Uri.parse(baseURL + '/members/getProfile/$username');

  //   http.Response response = await http.post(url, headers: headers, body: null);
  //   print("ข้อมูลที่ได้คือ : " + response.body);
  //   final utf8Body = utf8.decode(response.bodyBytes);
  //   Map<String, dynamic> jsonMap = json.decode(utf8Body);
  //   Member? member = Member.fromJsonToMember(jsonMap);
  //   return member;
  // }
Future<Member?> getMemberById(String username) async {
  try {
    var url = Uri.parse(baseURL + '/members/getProfile/$username');

    http.Response response = await http.post(url, headers: headers, body: null);

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(utf8Body);
      Member? member = Member.fromJsonToMember(jsonMap);
      
      if (member.interests != null) {
        // เข้าถึงสมาชิก interests ได้เมื่อมีข้อมูล
        print("Interests:");
        for (Interest interest in member.interests!) {
          print(interest.interestName); 
        }
      } else {
        print("ไม่พบข้อมูล Interest สำหรับสมาชิกนี้");
      }
      
      return member;
    } else {
      // จัดการเมื่อรหัสสถานะไม่ใช่ 200 (ไม่พบข้อมูลหรือข้อผิดพลาดอื่น ๆ)
      print("ไม่สามารถดึงข้อมูลสมาชิกได้: ${response.statusCode}");
      return null;
    }
  } catch (error) {
    // จัดการเมื่อเกิดข้อผิดพลาดในการเชื่อมต่อ
    print("เกิดข้อผิดพลาดในการเชื่อมต่อ: $error");
    return null;
  }
}
}
