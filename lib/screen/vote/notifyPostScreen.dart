import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/controller/voteController.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/vote/viewPostScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import '../../constant/constant_value.dart';
import 'package:intl/intl.dart';

class NotifyPostScreen extends StatefulWidget {
  final String username;
  const NotifyPostScreen({required this.username});

  @override
  State<NotifyPostScreen> createState() => _NotifyPostScreenState();
}

class _NotifyPostScreenState extends State<NotifyPostScreen> {
  List<Post>? posts;
  bool? isDataLoaded = false;
  final PostController postController = PostController();
  VoteController voteController = VoteController();
 List<String> ifvotes = [];

  void fetchPost() async {
  posts = await postController.listPostsInterest(widget.username.toString());
  print(posts?[0].member?.username);
  int i = 0;
  while (i < posts!.length) {
    String ifvote = await voteController.getIFVoteChoice(widget.username, posts![i].postId.toString());
    if (ifvote != "0") {
      posts!.removeAt(i);
    } else {
      i++;
    }
  }
  setState(() {
    isDataLoaded = true;
  });
}

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
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
        body: isDataLoaded == true? posts != null && posts!.isNotEmpty
                ? Container(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: posts?.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (posts == null || posts!.isEmpty) {
                return Center(child: Text("ไม่มีโพสต์ของคุณ"));
              } else {
                return Container(
                  height: 115,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      leading: Container(
                        width: 100,
                        // height: double.infinity,
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
                                      '/members/downloadimg/${posts?[index].member?.image}',
                                  fit: BoxFit.cover,
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                            ),
                            Text(
                              "${posts?[index].member?.nickname}",
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${posts?[index].title}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Itim',
                                fontSize: 20,
                                color: MainColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "คะแนน : ${posts?[index].postPoint?.toInt()}",
                            style: TextStyle(
                                fontFamily: 'Itim',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${posts?[index].description}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontFamily: 'Itim', fontSize: 16),
                          ),
                          Text(
                            "สิ้นสุด : ${formatDate(posts?[index].dateStop)}",
                            style: const TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(Icons.chevron_right_sharp,size: 30,color: MainColor,),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewPostScreen(
                              postId: posts![index].postId.toString(),
                              username: widget.username.toString());
                        }));
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ):Center(child: Text("ไม่มีโพสต์ตามความสนใจของคุณ")):Center(child: CircularProgressIndicator())
      ),
    );
  }
}
