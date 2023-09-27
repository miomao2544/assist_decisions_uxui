import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/report_controller.dart';
import 'package:assist_decisions_app/model/report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChangeBannedStatusScreen extends StatefulWidget {
  final String reportId;
  final String username;
  const ChangeBannedStatusScreen(
      {required this.reportId, required this.username});

  @override
  State<ChangeBannedStatusScreen> createState() =>
      _ChangeBannedStatusScreenState();
}

class _ChangeBannedStatusScreenState extends State<ChangeBannedStatusScreen> {
  bool isDataLoaded = false;
  Report? reports;
  String? banComment;
  ReportController reportController = ReportController();
  String? point = "1";
  List<String> numbers = ["1", "2", "3", "4"];

  TextEditingController banCommentController = TextEditingController();
  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
    }
    return '';
  }

  void updatePoint(String newValue) {
    setState(() {
      point = newValue;
    });
  }

  Future fetchReport() async {
    Report? report;
    report =
        await reportController.doViewReportDetail(widget.reportId.toString());
    print(
        "object-----------------${report!.reportDate.toString()}---------------------");
    setState(() {
      reports = report;
      banComment  = reports!.reportComment;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReport();
    banCommentController.text = banComment?? "";
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                        Text(reports!.post!.description
                                            .toString()),
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
                                    ClipOval(
                                      child: Image.network(
                                        baseURL +
                                            '/members/downloadimg/${reports!.post!.member!.image}',
                                        fit: BoxFit.cover,
                                        width: 36,
                                        height: 36,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(reports!.post!.member!.nickname
                                        .toString()),
                                    Center(
                                      child: Row(
                                        children: [
                                          Text("ระดับการสั่งห้าม"),
                                          DropdownButton<String>(
                                            value: point, // ค่าที่ถูกเลือก
                                            onChanged: (String? newValue) {
                                              updatePoint(newValue!);
                                            },
                                            items: numbers
                                                .map<DropdownMenuItem<String>>(
                                                    (String numbers) {
                                              return DropdownMenuItem<String>(
                                                value: numbers,
                                                child: Text(numbers),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text("เหตุผลที่รายงาน"),
                                        TextField(
                                           controller: banCommentController,
                                          onChanged: (value) {
                                            setState(() {
                                              banComment = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: "เหตุผลที่รายงาน",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                        )
                                      ],
                                    )
                                  ],

                                ),
                                Row(children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: ElevatedButton.icon(
                                          icon: Icon(Icons.other_houses),
                                          label: Text(
                                            "ยืนยัน",
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
                                            //              Navigator.push(context,
                                            //     MaterialPageRoute(builder: (context) {
                                            //   return ChangeBannedStatusScreen(reportId:  reports!.reportId.toString(),username: widget.username,);
                                            // }));
                                          },
                                        ),
                                      ),
                                    ),
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
                                          
                                          },
                                        ),
                                      ),
                                    ),
                                ],)
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
