import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/banTypeController.dart';
import 'package:assist_decisions_app/controller/historyController.dart';
import 'package:assist_decisions_app/controller/reportController.dart';
import 'package:assist_decisions_app/model/banType.dart';
import 'package:assist_decisions_app/model/report.dart';
import 'package:assist_decisions_app/screen/admin/listReportScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
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
  BanTypeController banTypeController = BanTypeController();
  HistoryBanController historyBanController = HistoryBanController();
  String? banTypeId = "";
  String? banTypesId = "BT0000000001";
  List<String?> banTypes = [];

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
      banTypeId = newValue;
      updateBanTypeId();
    });
  }

  void updateBanTypeId() async {
    List<BanType?> banType;
    banType = await banTypeController.listAllBanTypes();
    for (int i = 0; i < banTypes.length; i++) {
      if (banTypeId == banTypes[i]) {
        banTypesId = banType[i]!.banTypeId.toString();
      }
    }
    print("----------banTypesId--- ${banTypesId} --------------");
  }

  Future fetchReport() async {
    Report? report;
    report =
        await reportController.doViewReportDetail(widget.reportId.toString());
    List<BanType?> banType;
    banType = await banTypeController.listAllBanTypes();
    for (int i = 0; i < banType.length; i++) {
      banTypes.add(banType[i]!.numberOfDay.toString());
    }
    banTypeId = banType[0]!.numberOfDay.toString();
    print(
        "object-----------------${report!.reportDate.toString()}---------------------");
    setState(() {
      reports = report;
      banCommentController.text = "คุณถูกรายงานเนื่องจากโพสต์ ${report!.post!.title} ของคุณไม่เหมาะสม";
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
          backgroundColor: MainColor,
          title:     Image.asset(
                    "assets/images/logo.png",
                    width: 60,
                  ),
        ),
        body: isDataLoaded == true
            ? SingleChildScrollView(
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
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${formatDate(reports!.post!.dateStart.toString())} - ${formatDate(reports!.post!.dateStop.toString())}"),
                                      Text(
                                        "สั่งห้ามครั้งที่",
                                        style: TextStyle(
                                            color: MainColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "1",
                                        style: TextStyle(
                                            color: MainColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 250,
                                            child: Column(
                                              children: [
                                                Text(
                                                    reports!.post!.title
                                                        .toString(),
                                                    style: TextStyle(
                                                      overflow: TextOverflow
                                                                .ellipsis,
                                                        color: MainColor,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Image.network(
                                                  baseURL +
                                                      '/posts/downloadimg/${reports!.post!.postImage}',
                                                  fit: BoxFit.cover,
                                                  width: 180,
                                                  height: 180,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 250,
                                            child: Column(
                                              children: [
                                                Text(reports!.post!.description
                                                    .toString(),style: TextStyle(overflow: TextOverflow
                                                              .ellipsis),),
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("คะแนน",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            reports!
                                                                .post!.postPoint
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text("จำนวนต่ำสุด",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            reports!.post!.qtyMin
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text("จำนวนสูงสุด",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            reports!.post!.qtyMax
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: SecondColor,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                baseURL +
                                                    '/members/downloadimg/${reports!.post!.member!.image}',
                                                fit: BoxFit.cover,
                                                width: 36,
                                                height: 36,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                              "รายงานคุณ ${reports!.post!.member!.nickname
                                                  .toString()}",
                                              style: TextStyle(
                                                  color: MainColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Center(
                                            child: Row(
                                              children: [
                                                Text("ระดับการสั่งห้าม"),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                DropdownButton<String>(
                                                  value:
                                                      banTypeId, // ค่าที่ถูกเลือก
                                                  onChanged:
                                                      (String? newValue) {
                                                    updatePoint(newValue!);
                                                  },
                                                  items: banTypes.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String? numbers) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: numbers,
                                                      child: Text(
                                                          numbers.toString()),
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
                                                controller:
                                                    banCommentController,
                                                onChanged: (value) {
                                                  setState(() {
                                                    banCommentController.text =
                                                        value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "เหตุผลที่รายงาน",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )
                                            ],
                                          )
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
                                                icon: Icon(
                                                    Icons.confirmation_num),
                                                label: Text(
                                                  "ยืนยัน",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    MainColor,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  updateBanTypeId();
                                                  print(
                                                      "----------${banCommentController.text}------------");
                                                  print(
                                                      "----------${banTypesId}------------");
                                                  print(
                                                      "----------${reports!.member!.username}------------");
                                                  await historyBanController
                                                      .doBanStatus(
                                                          banCommentController
                                                              .text,
                                                          banTypesId ?? "",
                                                          reports!.member!
                                                                  .username ??
                                                              "");
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return ListReportScreen(
                                                      username: widget.username,
                                                    );
                                                  }));
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
                                                icon: Icon(Icons.cancel),
                                                label: Text(
                                                  "ยกเลิก",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    Colors.red,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return ListReportScreen(
                                                      username: widget.username,
                                                    );
                                                  }));
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  
                ),
                
              )
            : Center(child: CircularProgressIndicator()));
  }
}
