import 'package:assist_decisions_app/controller/choice_controller.dart';
import 'package:assist_decisions_app/controller/member_controller.dart';
import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/screen/commentScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constant/constant_value.dart';
import '../model/post.dart';
import '../widgets/PostInfoWidget.dart';
import '../widgets/divider_box.dart';

class ViewPostScreen extends StatefulWidget {
  final String postId;
  final String username;
  const ViewPostScreen({required this.postId, required this.username});

  @override
  State<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  Post? post;
  List<Choice>? choices = [];
  Member? member;
  int? selectedChoiceIndex = 0;
  bool? isDataLoaded = false;
  ChoiceController choiceController = ChoiceController();
  PostController postController = PostController();
  MemberController memberController = MemberController();
  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
    }
    return '';
  }

  Future<void> fetchPost() async {
    Post? postRequired;
    List<Choice> choiceRequired;
    Member? memberRequired;
    postRequired = await postController.getPostById(widget.postId);
    choiceRequired = await choiceController.listAllChoicesById(widget.postId);
    memberRequired = await memberController.getMemberById(widget.username);
    setState(() {
      post = postRequired;
      choices = choiceRequired;
      member = memberRequired;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${formatDate(post?.dateStart)} - ${formatDate(post?.dateStop)}"),
          actions: [
            IconButton(
              onPressed: () {
                // Handle report button action
              },
              icon: Icon(Icons.report),
            ),
          ],
        ),
        body: isDataLoaded == true
            ? Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${post?.title ?? ""}',
                              style: TextStyle(fontSize: 30)),
                          SizedBox(
                            height: 20,
                          ),
                          Image.network(
                            baseURL + '/posts/downloadimg/${post?.postImage}',
                            fit: BoxFit.cover,
                            width: 250,
                            height: 250,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(' ${post?.description ?? ""}'),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              PostInfoWidget(
                                title: "คะแนน",
                                value: "${post?.postPoint?.toInt()}",
                              ),
                              PostInfoWidget(
                                title: "จำนวนต่ำสุด",
                                value: "${post?.qtyMin}",
                              ),
                              PostInfoWidget(
                                title: "จำนวนสูงสุด",
                                value: "${post?.qtyMax}",
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
                                  title: Row(
                                    children: [
                                      Image.network(
                                        baseURL +
                                            '/choices/downloadimg/${choices![index].choiceImage}',
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                                      Text(choices![index].choiceName ?? ""),
                                    ],
                                  ),
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
                          SizedBox(height: 16.0),
                          CommentScreen(member: member,),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
