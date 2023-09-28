import 'package:assist_decisions_app/model/banType.dart';

import '../model/interest.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';
class BanTypeController{
  BanType? banTypes;

    Future listAllBanTypes() async{
    var url = Uri.parse(baseURL + '/bantypes/list');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );
    print(response.body);
    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    List<BanType> list = jsonList.map((e) => BanType.fromJsonToBanType(e)).toList();
    return list;
    }
}