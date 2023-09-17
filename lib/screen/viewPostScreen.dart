import 'package:assist_decisions_app/controller/choice_controller.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constant/constant_value.dart';
import '../model/post.dart';
import '../widgets/PostInfoWidget.dart';
import '../widgets/divider_box.dart';

class ViewPostScreen extends StatefulWidget {
  final Post? post;
  const ViewPostScreen({required this.post});

  @override
  State<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  List<Choice>? choices;
  int? selectedChoiceIndex = 0;
  final ChoiceController choiceController = ChoiceController();

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
    }
    return '';
  }

  Future<void> fetchChoice() async {
    choices =
        await choiceController.listAllChoicesById(widget.post?.postID ?? "");
  }

  Future<void> _refreshChoices() async {
    await fetchChoice();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchChoice();
  }


  @override
  Widget build(BuildContext context) {
    _refreshChoices();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${formatDate(widget.post?.dateStart)} - ${formatDate(widget.post?.dateStop)}"),
        actions: [
          IconButton(
            onPressed: () {
              // Handle report button action
            },
            icon: Icon(Icons.report),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshChoices,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${widget.post?.title ?? ""}',
                      style: TextStyle(fontSize: 30)),
                  SizedBox(
                    height: 20,
                  ),
                  Image.network(
                    baseURL + '/posts/downloadimg/${widget.post?.postImage}',
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(' ${widget.post?.description ?? ""}'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      PostInfoWidget(
                        title: "คะแนน",
                        value: "${widget.post?.postPoint?.toInt()}",
                      ),
                      PostInfoWidget(
                        title: "จำนวนต่ำสุด",
                        value: "${widget.post?.qtyMin}",
                      ),
                      PostInfoWidget(
                        title: "จำนวนสูงสุด",
                        value: "${widget.post?.qtyMax}",
                      ),
                      PostInfoWidget(
                        title: "จำนวนผู้โหวต",
                        value: "20",
                      ),
                    ],
                  ),
                  DividerBoxBlack(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: choices?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        shape: Border.all(
                          color: selectedChoiceIndex == index
                              ? Colors.green
                              : Colors.transparent,
                          width: 2,
                        ),
                        child: RadioListTile<int>(
                          value: index,
                          groupValue: selectedChoiceIndex,
                          onChanged: (int? value) {
                            setState(() {
                              selectedChoiceIndex = value;
                            });
                          },
                          activeColor: Colors.green,
                          title: Text(choices![index].choiceName ?? ""),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("ยืนยันคำตอบ"),
                            content: Text(
                                "คุณแน่ใจหรือไม่ที่ต้องการยืนยันคำตอบนี้?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // ปิด Alert Dialog
                                },
                                child: Text("ยกเลิก"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // ทำสิ่งที่ต้องการเมื่อกดยืนยัน
                                  Navigator.of(context)
                                      .pop(); // ปิด Alert Dialog
                                },
                                child: Text("ยืนยัน"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("ยืนยันคำตอบ"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
