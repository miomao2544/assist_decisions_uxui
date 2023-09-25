import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/viewPostScreen.dart';
import 'package:flutter/material.dart';
import '../constant/constant_value.dart';
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

  void fetchPost() async {
    posts = await postController.listPostsInterest(widget.username.toString());
    print(posts?[0].member?.username);

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
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: posts?.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (posts == null || posts!.isEmpty) {
                return Center(child: Text("ไม่มีโพสต์ของคุณ"));
              } else {
                return Card(
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
                          ClipOval(
                            child: Image.network(
                              baseURL +
                                  '/members/downloadimg/${posts?[index].member?.image}',
                              fit: BoxFit.cover,
                              width: 36,
                              height: 36,
                            ),
                          ),
                          const SizedBox(height: 5),
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
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 20),
                        ),
                        Text(
                          "คะแนน : ${posts?[index].postPoint?.toInt()}",
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 16),
                        ),
                        Text(
                          "${posts?[index].description}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(fontFamily: 'Itim', fontSize: 16),
                        ),
                        Text(
                          "สิ้นสุดการโหวต ${formatDate(posts?[index].dateStop)}",
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
                        const Icon(Icons.chevron_right_sharp),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewPostScreen(
                            postId: posts![index].postId.toString(),username: widget.username.toString());
                      }));
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
