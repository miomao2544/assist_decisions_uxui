import 'package:assist_decisions_app/controller/choiceController.dart';
import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/controller/voteController.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/screen/vote/commentScreen.dart';
import 'package:assist_decisions_app/screen/admin/reportPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constant/constant_value.dart';
import '../../model/post.dart';
import '../../widgets/PostInfoWidget.dart';
import '../../widgets/divider_box.dart';

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
  VoteController voteController = VoteController();
  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
  }

  int counts = 0;
  String ifvote = "";
  List<String> usernames = [];
  Future<void> fetchPost() async {
    Post? postRequired;
    List<Choice> choiceRequired;
    Member? memberRequired;
    List<String> username = [];
    postRequired = await postController.getPostById(widget.postId);
    choiceRequired = await choiceController.listAllChoicesById(widget.postId);
    memberRequired = await memberController.getMemberById(widget.username);
    counts = await postController.getListCountMember(widget.postId);
    ifvote =
        await voteController.getIFVoteChoice(widget.username, widget.postId);
    print(
        "---------------${widget.postId.toString()}--------------${ifvote}----------------");
    username = await memberController.getUsernameVotePost(widget.postId);
    setState(() {
      post = postRequired;
      choices = choiceRequired;
      member = memberRequired;
      usernames = List<String>.from(username);
      calculateScorepoint();
      isDataLoaded = true;
    });
  }

  Future calculateScorepoint() async {
    if ((post!.qtyMax == counts ||
            (post!.dateStop != null &&
                DateTime.parse(post!.dateStop!).isBefore(DateTime.now()))) &&
        post!.result == "r") {
      double score = double.parse(post!.postPoint.toString());
      int qtyMax = counts;
      if (score % 1 == 0) {
        int scorepoint = (score / qtyMax).toInt();
        print("----------point--${scorepoint}-------");
        for (int i = 0; i < usernames.length; i++) {
          print(
              "---------------${usernames[i].toString()}-------Vote<<<-------------");
          await memberController.doUpdatePointVote(
              usernames[i].toString(), scorepoint.toString());
        }
        await postController.doUpdateResult("1", post!.postId.toString());
      }
    }
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
          backgroundColor: MainColor,
          title: Text(
              "สิ้นสุดการโหวตวันที่ ${formatDate(post?.dateStop)}",style: TextStyle(fontFamily: 'Light')),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomeScreen(
                      username: widget.username,
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ReportPostScreen(
                      postId: post!.postId.toString(),
                      username: widget.username.toString());
                }));
              },
              icon: Icon(
                Icons.report,
                size: 35,
              ),
            ),
          ],
        ),
        body: isDataLoaded == true
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text('${post?.title ?? ""}',
                                  style: TextStyle(fontSize: 24,color: MainColor,fontWeight: FontWeight.bold,fontFamily: 'Light')),
                              SizedBox(
                                height: 25,
                              ),
                                                          ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  15), // แก้ไขค่าตรงนี้เพื่อปรับรูปแบบการโค้งตามที่คุณต้องการ
                              child:
                              Image.network(
                                baseURL + '/posts/downloadimg/${post?.postImage}',
                                fit: BoxFit.cover,
                                width: 250,
                                height: 250,
                              )),
                              SizedBox(
                                height: 15,
                              ),
                              Text(' ${post?.description ?? ""}',style: TextStyle(fontFamily: 'Light'),),
                              SizedBox(
                                height: 15,
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
                                    value: counts.toString(),
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
                                          ? SecondColor
                                          : Color.fromARGB(255, 255, 249, 196),
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
                                      activeColor: SecondColor,
                                      title: Row(
                                        children: [
                                          choices![index].choiceImage != ""
                                              ? Image.network(
                                                  baseURL +
                                                      '/choices/downloadimg/${choices![index].choiceImage}',
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                )
                                              : SizedBox(width: 2, height: 50),
                                          Text(choices![index].choiceName ?? "",style: TextStyle(fontFamily: 'Light'),),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ifvote == "0"
                                  ? Container(
                                      width: 120,
                                      height: 45,
                                      child: ElevatedButton(
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
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop(); // ปิด Alert Dialog
                                                    },
                                                    child: Text("ยกเลิก"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await voteController.doVotePost(
                                                          widget.username
                                                              .toString(),
                                                          choices![
                                                                  selectedChoiceIndex!]
                                                              .choiceId
                                                              .toString());
                                                      await voteController
                                                          .getIFVoteChoice(
                                                              widget.username,
                                                              widget.postId);
                                                      Navigator.of(context).pop();
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (context) {
                                                        return ViewPostScreen(
                                                          username:
                                                              widget.username,
                                                          postId: post!.postId
                                                              .toString(),
                                                        );
                                                      }));
                                                    },
                                                    child: Text("ยืนยัน",style: TextStyle(fontFamily: 'Light'),),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              MainColor, // Change this to your desired color
                                        ),
                                        child: Text("ยืนยันคำตอบ",style: TextStyle(fontFamily: 'Light'),),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 10,
                                    ),
                              SizedBox(height: 16.0),
                              CommentScreen(
                                member: member,
                                postId: post!.postId.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
