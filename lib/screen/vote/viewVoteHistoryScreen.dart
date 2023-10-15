import 'package:assist_decisions_app/controller/choiceController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/vote/viewProfileScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/constant_value.dart';

class ViewPostHistoryScreen extends StatefulWidget {
  final String username;
  const ViewPostHistoryScreen({required this.username});

  @override
  State<ViewPostHistoryScreen> createState() => _ViewPostHistoryState();
}

class _ViewPostHistoryState extends State<ViewPostHistoryScreen> {
  List<Post>? posts;
  List<Choice>? choices;
  bool? isDataLoaded = false;
  final PostController postController = PostController();
  final ChoiceController choiceController = ChoiceController();
  Future fetchPost() async {
    posts = await postController.ViewPostHistory(widget.username.toString());
    choices =
        await choiceController.ViewPostHistory(widget.username.toString());
    setState(() {
      isDataLoaded = true;
    });
  }

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: MainColor,
          title: Text('ประวัติการโหวต'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ViewProfileScreen(
                      username: widget.username,
                    );
                  },
                ),
              );
            },
          ),
        ),
        body: isDataLoaded == true
            ? posts != null && posts!.isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: posts!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10.0),
                            // ตรงนี้คือส่วนที่แสดงข้อมูลของโพสต์
                            leading: Container(
                              width: 100,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: SecondColor, // สีเส้นขอบแดง
                                        width: 2.0, // ความหนาของเส้นขอบ 2
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        baseURL +
                                            '/posts/downloadimg/${posts![index].postImage}',
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            title: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${posts![index].title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontSize: 20,
                                      color: MainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "คำตอบ : ${choices![index].choiceName}",
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            trailing:  Text(
                                  "${posts![index].avgPoint!.toInt()}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 16),
                                ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: Text("คุณยังไม่มีประวัติการโหวต"))
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
