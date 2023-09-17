import 'dart:convert';
import 'dart:io';
import '../model/member.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';
class MemberController{
  Member? member;

  Future addMember(String username, String password, String nickname, String gender, String firstname, String lastname, String email, String tel, String imageName,String interestId) async{



    Map data = {
    "username" : username,
    "adminstatus" : "0",
    "email" : email,
    "firstname" : firstname,
    "gender" : gender,
    "image" : imageName,
    "lastname" : lastname,
    "nickname" : nickname,
    "password" : password,
    "tel" : tel,
    "interestId" : interestId
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/members/add');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body
    );
    var jsonResponse = jsonDecode(response.body);
    return  jsonResponse;
  }

  Future updateMember(String username, String password, String nickname, String gender, String firstname, String lastname, String email, String tel, String image,String adminstatus) async{

    // var imageName = await upload(image);

    Map data = {
    "username" : username,
    "adminstatus" : adminstatus,
    "email" : email,
    "firstname" : firstname,
    "gender" : gender,
    "image" : image,
    "lastname" : lastname,
    "nickname" : nickname,
    "password" : password,
    "point" : "2000",
    "status" : "active",
    "tel" : tel,
    "interestId" : "I00001"
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/members/update');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body
    );
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse); 
    return  jsonResponse;
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


    Future getMemberById(String username)async{
    var url = Uri.parse(baseURL + '/members/getMemberById/$username');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );
    print("ข้อมูลที่ได้คือ : "+ response.body);
      Map<String, dynamic> jsonMap = json.decode(response.body);
      Member? member = Member.fromJsonToMember(jsonMap);
      return member;
  
    }
}