import 'dart:convert';
import 'package:assist_decisions_app/model/report.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ViewReportPostDetailController{
    Future doViewReportDetail(String reportId) async {
    try {
      var url = Uri.parse(baseURL + '/reports/getReportById/$reportId');
      http.Response response =
          await http.post(url, headers: headers, body: null);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonMap = json.decode(utf8Body);
        Report? report = Report.fromJsonToReport(jsonMap);
        return report;
      }
    } catch (error) {
      print("เกิดข้อผิดพลาดในการเชื่อมต่อ: $error");
      return null;
    }
  }
}