import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class LoginMemberController{

  Future doLoginMember(String username,String password) async {
    var url = Uri.parse(baseURL + "/members/loginmember/${username}/${password}");
     http.Response response = await http.post(url, headers: headers, body: null);
    return response.body;
  }

}