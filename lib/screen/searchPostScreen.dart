import 'package:assist_decisions_app/controller/interest_controller.dart';
import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/model/interest.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/postDetailScreen.dart';
import 'package:assist_decisions_app/screen/viewPostScreen.dart';
import 'package:flutter/material.dart';
import '../constant/constant_value.dart';
import 'package:intl/intl.dart';

class SearchPostScreen extends StatefulWidget {
  final String username;
  const SearchPostScreen({required this.username});

  @override
  State<SearchPostScreen> createState() => _SearchPostScreenState();
}

class _SearchPostScreenState extends State<SearchPostScreen> {
  String? interestListSelect = "";
  List<Interest> interests = [];
  List<String?> interestSelect = [];
  List<bool> isSelected = [false, false, false];
  String? search = "";
  List<Post>? posts;
  bool? isDataLoaded = false;
  String? point = "0";
  List<String> numbers = ["0", "1000", "500", "200", "100", "50"];
  TextEditingController postDateStopController = TextEditingController();
  String? dateStops = "";
  final PostController postController = PostController();
  InterestController interestController = InterestController();

  Future fetchPost() async {
    List<Interest>? interest = await interestController
        .listInterestsByUser(widget.username.toString());
    List<String>? interestList = [];
    for (int i = 0; i < interest!.length; i++) {
      if (interest[i].interestId != null) {
        interestList.add(interest[i].interestId.toString());
      }
    }
    interestListSelect = interestList.where((item) => item != null).join(',');
    posts = await postController.listSearchPostsAll(search.toString(),
        interestListSelect.toString(), point.toString(), dateStops.toString());
    setState(() {
      
    });
  }
    Future loadInterests() async {
    List<Interest> interestList = await interestController.listAllInterests();
    setState(() {
      print("---------------------------interests-----is ${interestList[0].interestName}----------------------");
      interests = interestList;
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

  Future<void> _selectDateStop(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(Duration(days: 365)),
      lastDate: currentDate.add(Duration(days: 365)),
    );

    if (selectedDate != null && selectedDate != currentDate) {
      String formattedDate =
          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().padLeft(4, '0')}";
      postDateStopController.text = formattedDate;
      print(postDateStopController.text);
      String formattedDate2 =
          "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}:${selectedDate.second.toString().padLeft(2, '0')}";
      dateStops = formattedDate2;
    }
  }

  void updatePoint(String newValue) {
    setState(() {
      point = newValue;
    });
  }

  void _showSearchDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("ค้นหาโพสต์"),
        ),
        body: AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    search = value; // อัปเดตค่า search เมื่อผู้ใช้พิมพ์
                  },
                  decoration: InputDecoration(
                    labelText: "ค้นหา",
                    hintText: "ค้นหาโพสต์...",
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: 160,
                  child: TextFormField(
                    controller: postDateStopController,
                    readOnly: true,
                    onTap: () => _selectDateStop(context),
                    decoration: InputDecoration(
                      labelText: "วันที่",
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                      prefixIconColor: Colors.black,
                    ),
                    style: TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: point, // ค่าที่ถูกเลือก
                  onChanged: (String? newValue) {
                    updatePoint(newValue!);
                  },
                  items: numbers.map<DropdownMenuItem<String>>((String point) {
                    return DropdownMenuItem<String>(
                      value: point,
                      child: Text(point),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Text('ความสนใจ'),
                // Container(
                //   height: 30.0,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: interests.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       final interest = interests[index];
                //       final isSelected = interestSelect.contains(interest.interestId);

                //       return Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 8.0),
                //         child: ElevatedButton(
                //           onPressed: () {
                //             setState(() {
                //               if (isSelected) {
                //                 interestSelect.remove(interest.interestId);
                //               } else {
                //                 interestSelect.add(interest.interestId);
                //               }
                //               interestListSelect = interestSelect
                //                   .where((item) => item != null)
                //                   .join(',');
                //               print(
                //                   "interestSelect is ----------------- > = " +
                //                       interestListSelect.toString());
                //             });
                //           },
                //           style: ElevatedButton.styleFrom(
                //             primary: isSelected ? Color(0xFF479f76) : Color(0xFF1c174d),
                //           ),
                //           child: Text(interest.interestName ?? ""),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        fetchPost();
                      },
                      child: Text("ค้นหา"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("ยกเลิก"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  @override
  void initState() {
    super.initState();
    point = numbers[0];
    fetchPost();
    loadInterests();
    isSelected = List<bool>.filled(interests.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(25.0), // ปรับความสูงตามที่คุณต้องการ
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _showSearchDialog(context);
                    },
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: 200.0,
                      height: 50.0,
                      child: TextField(
                        onChanged: (value) {
                          search = value;
                        },
                        decoration: InputDecoration(
                          hintText: "ค้นหาโพสต์...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      fetchPost();
                    },
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 20),
                                ),
                                Text(
                                  "คะแนน : ${posts?[index].postPoint?.toInt()}",
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 16),
                                ),
                                Text(
                                  "${posts?[index].description}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 16),
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
                              widget.username == posts?[index].member?.username
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PostDetailScreen(
                                          post: posts?[index],
                                        ),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostScreen(
                                          post: posts?[index],
                                        ),
                                      ),
                                    );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: Text("ไม่มีโพสต์ที่ตรงกับความสนใจของคุณ"))
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
