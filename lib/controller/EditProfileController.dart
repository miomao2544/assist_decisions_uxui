
import 'dart:convert';
import 'package:assist_decisions_app/model/interest.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';
class EditProfileController{
  
Future doEditProfile(
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

  Future<Member?> doProfileDetail(String username) async {
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
}