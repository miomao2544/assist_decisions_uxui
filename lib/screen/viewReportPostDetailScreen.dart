import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/reportController.dart';
import 'package:assist_decisions_app/model/report.dart';
import 'package:assist_decisions_app/screen/changeBannedStatusScreen.dart';
import 'package:assist_decisions_app/screen/listReportScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewReportPostDetail extends StatefulWidget {
  final String reportId;
  final String username;
  const ViewReportPostDetail({required this.reportId, required this.username});

  @override
  State<ViewReportPostDetail> createState() => _ViewReportPostDetailState();
}

class _ViewReportPostDetailState extends State<ViewReportPostDetail> {
  bool isDataLoaded = false;
  Report? reports;
  ReportController reportController = ReportController();

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
    }
    return '';
  }

  Future fetchReport() async {
    Report? report;
    report =
        await reportController.doViewReportDetail(widget.reportId.toString());
    print(
        "object-----------------${report!.reportDate.toString()}---------------------");
    setState(() {
      reports = report;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Logo ${widget.reportId}"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 600,
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Column
                          (
                             mainAxisAlignment:
                                                      MainAxisAlignment.center,
                            children: [
                            Text(
                                "${formatDate(reports!.post!.dateStart.toString())} - ${formatDate(reports!.post!.dateStop.toString())}"),
                            Text("สั่งห้ามครั้งที่"),
                            Text("1"),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(reports!.post!.title.toString()),
                                    Image.network(
                                      baseURL +
                                          '/posts/downloadimg/${reports!.post!.postImage}',
                                      fit: BoxFit.cover,
                                      width: 180,
                                      height: 180,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(reports!.post!.member!.nickname
                                            .toString()),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        ClipOval(
                                          child: Image.network(
                                            baseURL +
                                                '/members/downloadimg/${reports!.post!.member!.image}',
                                            fit: BoxFit.cover,
                                            width: 36,
                                            height: 36,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(reports!.post!.description.toString()),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text("คะแนน"),
                                            Text(reports!.post!.postPoint
                                                .toString()),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          children: [
                                            Text("จำนวนต่ำสุด"),
                                            Text(reports!.post!.qtyMin
                                                .toString()),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          children: [
                                            Text("จำนวนสูงสุด"),
                                            Text(reports!.post!.qtyMax
                                                .toString()),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        baseURL +
                                            '/members/downloadimg/${reports!.member!.image}',
                                        fit: BoxFit.cover,
                                        width: 36,
                                        height: 36,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(reports!.member!.nickname.toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("เหตุผลที่รายงาน"),
                                    Text(formatDate(
                                        reports!.reportDate.toString())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(reports!.reportComment.toString()),
                                  ],
                                ),
                                Row(
                                   mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: ElevatedButton.icon(
                                          icon: Icon(Icons.other_houses),
                                          label: Text(
                                            "สั่งห้าม",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color(0xFF479f76),
                                            ),
                                          ),
                                          onPressed: () {
                                                         Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                              return ChangeBannedStatusScreen(reportId:  reports!.reportId.toString(),username: widget.username,);
                                            }));
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: ElevatedButton.icon(
                                          icon: Icon(Icons.other_houses),
                                          label: Text(
                                            "ยกเลิก",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color(0xFF479f76),
                                            ),
                                          ),
                                          onPressed: () {
                                                         Navigator.push(context,
                                                MaterialPageRoute(builder: (context) {
                                              return ListReportScreen(username: widget.username,);
                                            }));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
