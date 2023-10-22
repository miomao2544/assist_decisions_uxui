import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/controller/voteController.dart';
import 'package:assist_decisions_app/screen/post/chackDeletePostScreen.dart';
import 'package:assist_decisions_app/screen/post/editPostScreen.dart';
import 'package:assist_decisions_app/screen/post/listCommentScreen.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/member.dart';
import '../../constant/constant_value.dart';
import '../../controller/choiceController.dart';
import '../../model/post.dart';
import 'package:intl/intl.dart';

import '../../widgets/PostInfoWidget.dart';
import '../../widgets/divider_box.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final String username;
  const PostDetailScreen({required this.postId, required this.username});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? post;
  List<Choice>? choices = [];
  int counts = 0;
  List<String> votes = [];
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

  Future<void> fetchPost() async {
    Post? postRequired;
    List<Choice> choiceRequired;
    Member? memberRequired;
    int count;
    List<String> vote = [];
    postRequired = await postController.getPostById(widget.postId);
    choiceRequired = await choiceController.listAllChoicesById(widget.postId);
    memberRequired = await memberController.getMemberById(widget.username);
    count = await postController.getListCountMember(widget.postId);
    vote = List<String>.filled(choiceRequired.length, "");
    for (int i = 0; i < choiceRequired.length; i++) {
      vote[i] = await voteController
          .getVoteByChoice(choiceRequired[i].choiceId.toString());
    }

    setState(() {
      post = postRequired;
      choices = choiceRequired;
      member = memberRequired;
      counts = count;
      votes = vote;
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
        backgroundColor: MainColor,
        title: Text(
          "สิ้นสุดการโหวตวันที่ ${formatDate(post?.dateStop)}",
          style: TextStyle(fontFamily: 'Light'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
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
        ),
      ),
      body: isDataLoaded == true
          ? Container(
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${post?.title ?? ""}',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Light',
                                    color: MainColor,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  15), // แก้ไขค่าตรงนี้เพื่อปรับรูปแบบการโค้งตามที่คุณต้องการ
                              child: Image.network(
                                baseURL +
                                    '/posts/downloadimg/${post?.postImage}',
                                fit: BoxFit.cover,
                                width: 250,
                                height: 250,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              ' ${post?.description ?? ""}',
                              style: TextStyle(fontFamily: 'Light'),
                            ),
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
                              ],
                            ),
                            DividerBoxBlack(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: choices?.length ?? 0,
                              itemBuilder: (context, index) {
                                // หาตัวเลือกที่มีคะแนนสูงสุด
                                final List<int> intVotes = votes
                                    .map((vote) => int.parse(vote))
                                    .toList();

                                int maxVotes = intVotes.reduce(
                                    (max, vote) => vote > max ? vote : max);

                                // ตรวจสอบว่าตัวปัจจุบันมีคะแนนเท่ากับคะแนนสูงสุดหรือไม่
                                bool isSelected =
                                    int.parse(votes[index]) == maxVotes;

                                // กำหนดสีของ Border ของ Card
                                Color borderColor = isSelected
                                    ? Colors.white
                                    : Color.fromARGB(255, 255, 240, 197);

                                return Card(
                                  elevation: 2,
                                  shape: Border.all(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  child: InkWell(
                                    child: ListTile(
                                      title: Container(
                                        width: 150,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 30,
                                                child: Text(
                                                  "${index + 1}",
                                                  style: TextStyle(
                                                      color: MainColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                              width: 350,
                                              child: Row(
                                                children: [
                                                  choices![index].choiceImage !=
                                                          ""
                                                      ? Image.network(
                                                          baseURL +
                                                              '/choices/downloadimg/${choices![index].choiceImage}',
                                                          fit: BoxFit.cover,
                                                          width: 50,
                                                          height: 50,
                                                        )
                                                      : SizedBox(height: 50),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        choices![index]
                                                                .choiceName ??
                                                            "",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Light'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Text("${votes[index]}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: MainColor)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            Text(
                              "จำนวนผู้โหวต : ${counts} ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Light',
                                  color: MainColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditPostScreen(
                                                      username: widget.username,
                                                      postId: post!.postId
                                                          .toString(),
                                                    )),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: MainColor,
                                        ),
                                        child: Text(
                                          "แก้ไข",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: 'Light'),
                                        ),
                                      ),
                                    ),
                                    counts == 0
                                        ? SizedBox(width: 20)
                                        : SizedBox(),
                                    counts == 0
                                        ? ChackDeletePostScreen(
                                            postId: post!.postId.toString(),
                                            username: widget.username,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              "ความคิดเห็น",
                              style:
                                  TextStyle(fontSize: 18, fontFamily: 'Light'),
                            ),
                            ListCommentScreen(postId: post!.postId.toString()),
                            SizedBox(
                              height: 100,
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
    ));
  }
}
