import 'dart:convert';
import 'package:assist_decisions_app/model/interest.dart';

import '../model/member.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ViewProfileController{
    Future<Member?> getProfile(String username) async {
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