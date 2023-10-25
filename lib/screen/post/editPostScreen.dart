import 'dart:io';

import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/classcontroller/choiceController.dart';
import 'package:assist_decisions_app/classcontroller/memberController.dart';
import 'package:assist_decisions_app/classcontroller/postController.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classcontroller/interestController.dart';
import '../../model/choice.dart';
import '../../model/interest.dart';
import '../validators/validatorPost.dart';
import 'package:intl/intl.dart';

class EditPostScreen extends StatefulWidget {
  final String username;
  final String postId;
  const EditPostScreen({required this.username, required this.postId});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  String? title;
  String? image;
  String? description;
  String? point;
  String? min;
  String? max;
  String? avgPoint;
  String? selectedInterest;
  String? dateStart;
  String? dateStop;

  List<String>? images = [];
  ChoiceController choiceController = ChoiceController();
  PostController postController = PostController();
  MemberController memberController = MemberController();
  String? fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  bool isLoadingPicture = true;
  FilePickerResult? filePickerResult;
  List<String?> fileImageName = [];
  List<File?> fileImagesToDisplay = [];
  List<bool>? isLoadingImagePicture;

  void _pickFile() async {
    try {
      setState(() {
        isLoadingPicture = true;
      });
      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
      if (filePickerResult != null) {
        fileName = filePickerResult!.files.first.name;
        pickedFile = filePickerResult!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());
        image = fileName.toString();
        print("File is ${fileName}");
      }
      setState(() {
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _pickFileChoices(int index) async {
    try {
      setState(() {
        isLoadingPicture = true;
      });

      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      print("File is ${fileImageName[0]}");

      setState(() {
        if (filePickerResult != null) {
          fileImageName[index] = filePickerResult!.files.first.name;
          pickedFile = filePickerResult!.files.first;
          fileImagesToDisplay[index] = File(pickedFile!.path!);
          isLoadingImagePicture?.add(false);
        }
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _addNewChoice() {
    setState(() {
      choices.add(Choice(choiceName: "", choiceImage: ""));
      fileImagesToDisplay.add(null);
      fileImageName.add("");
      print("-------A--------- ${choices.length}");
      print("-------B--------- ${fileImagesToDisplay.length}");
      print("-------C--------- ${fileImageName.length}");
      isLoadingImagePicture?.add(true);
    });
  }

  void _removeChoice(int index) {
    setState(() {
      if (choices[index].choiceId != null && choices[index].choiceId != "") {
        choiceController.editChoice(
            "false",
            choices[index].choiceId ?? "",
            choices[index].choiceName ?? "",
            choices[index].choiceImage ?? "",
            posts!.postId ?? "");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditPostScreen(
                    username: widget.username,
                    postId: widget.postId.toString(),
                  )),
        );
      }
      if (index >= 0 && index < choices.length) {
        choices.removeAt(index);
      }
      if (index >= 0 && index < fileImagesToDisplay.length) {
        fileImagesToDisplay.removeAt(index);
      }
      if (index >= 0 && index < fileImageName.length) {
        fileImageName.removeAt(index);
      }
    });
  }

  TextEditingController postDateStartController = TextEditingController();
  TextEditingController postDateStopController = TextEditingController();

  Future<void> _selectDateStart(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: currentDate.add(Duration(days: 365)),
    );
    if (selectedDate != null && selectedDate != currentDate) {
      String formattedDate =
          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().padLeft(4, '0')}";
      postDateStartController.text = formattedDate;
      String formattedDate2 =
          "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}:${selectedDate.second.toString().padLeft(2, '0')}";
      dateStart = formattedDate2;
    }
  }

  Future<void> _selectDateStop(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: currentDate.add(Duration(days: 365)),
    );
    if (selectedDate != null && selectedDate != currentDate) {
      String formattedDate =
          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().padLeft(4, '0')}";
      postDateStopController.text = formattedDate;
      String formattedDate2 =
          "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}:${selectedDate.second.toString().padLeft(2, '0')}";
      dateStop = formattedDate2;
    }
  }

  Future<String> formattedDate(String selectedDate) async {
    DateTime parsedDate = DateTime.parse(selectedDate);
    String formattedDate =
        "${parsedDate.toLocal().day.toString().padLeft(2, '0')}/${parsedDate.toLocal().month.toString().padLeft(2, '0')}/${parsedDate.toLocal().year.toString().padLeft(4, '0')}";
    return formattedDate;
  }

  List<Choice> choices = [];
  List<Interest> interests = [];
  InterestController interestController = InterestController();
  bool? isDataLoaded = false;
  int? pointmember;

  Future loadInterests() async {
    Member? member;
    List<Interest> interestList =
        await interestController.listInterestsByUser(widget.username);
    member = await memberController.getMemberById(widget.username);
    setState(() {
      interests = interestList;
      pointmember = member!.point;
    });
  }

  Post? posts;
  Future<void> setInitialValues() async {
    Post? post = await postController.getPostById(widget.postId);
    List<Choice> choice =
        await choiceController.listAllChoicesById(widget.postId);
    for (int i = 0; i < choice.length; i++) {
      fileImagesToDisplay.add(null);
      fileImageName.add("");
    }
    setState(() {
      posts = post;
      choices = choice;
      print("-------A--------- ${choices.length}");
      print("-------B--------- ${fileImagesToDisplay.length}");
      print("-------C--------- ${fileImageName.length}");
      selectedInterest = posts!.interest!.interestId;
      postDateStartController.text = formatDate(posts!.dateStart.toString());
      postDateStopController.text = formatDate(posts!.dateStop.toString());
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

  String formatDateNew(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      return formatter.format(date.toLocal());
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    loadInterests();
    setInitialValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: MainColor,
            title: Text("แก้ไขโพสต์", style: TextStyle(fontFamily: 'Light')),
            centerTitle: true,
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
            )),
        body: isDataLoaded == true
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: fromKey,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Center(
                              child: Text(
                            "Assist Decisions",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Light'),
                            textAlign: TextAlign.center,
                          )),
                          Center(
                              child: Text(
                            "ให้เราสนับสนุนการตัดสินใจของคุณ\nจากโพสต์ของคุณ",
                            style: TextStyle(fontFamily: 'Light'),
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(height: 16),
                          Text(
                            "ส่วนของคำถาม",
                            style: TextStyle(fontSize: 20, fontFamily: 'Light'),
                          ),
                          TextFormField(
                            initialValue: posts!.title.toString(),
                            decoration: InputDecoration(
                              labelText: 'หัวข้อ',
                              labelStyle: TextStyle(
                                  color: MainColor, fontFamily: 'Light'),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                            validator: validateTitle,
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: isLoadingPicture
                                ? Image.network(
                                    baseURL +
                                        '/posts/downloadimg/${posts!.postImage}',
                                    fit: BoxFit.cover,
                                    width: 250,
                                    height: 250,
                                  )
                                : fileToDisplay != null
                                    ? Image.file(
                                        fileToDisplay!,
                                        height: 200,
                                      )
                                    : Container(),
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _pickFile();
                              },
                              icon: Icon(Icons.image),
                              label: Text("เลือกรูปภาพ",style: TextStyle(fontFamily: 'Light')),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  isLoadingPicture ? MainColor : SecondColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: posts!.description,
                            decoration: InputDecoration(
                              labelText: 'รายละเอียด',
                              border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.blueGrey[50],
                        labelStyle:
                            TextStyle(color: MainColor, fontFamily: 'Light'),
                            ),
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "คะแนน",
                                    style: TextStyle(
                                  color: MainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Light'),
                                  ),
                                  Container(
                                    width: 120.0,
                                    child: TextFormField(
                                      enabled: false,
                                      initialValue: (posts!.postPoint)
                                          ?.toInt()
                                          .toString(),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                       border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.blueGrey[50],
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          point = value;
                                        });
                                      },
                                      validator: (value) =>
                                          validatePoint(value, pointmember!),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "ต่ำสุด",
                                    style: TextStyle(
                                  color: MainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Light'),
                                  ),
                                  Container(
                                    width: 120.0,
                                    child: TextFormField(
                                      enabled: false,
                                      initialValue:
                                          (posts!.qtyMin)?.toInt().toString(),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                       border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.blueGrey[50],
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          min = value;
                                        });
                                      },
                                      validator: validateMin,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "สูงสุด",
                                     style: TextStyle(
                                  color: MainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Light'),
                                  ),
                                  Container(
                                    width: 120.0,
                                    child: TextFormField(
                                      initialValue:
                                          (posts!.qtyMax)?.toInt().toString(),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.blueGrey[50],
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          max = value;
                                        });
                                      },
                                      validator: validateMax,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                           Center(
                        child: Text(
                      "เมื่อทำการสร้างคะแนนของคุณจะลดลงตามคะแนนที่คุณสร้าง",
                      style: TextStyle(fontFamily: 'Light'),
                      textAlign: TextAlign.center,
                    )),
                          SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              width: 300,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'สิ่งที่สนใจ',
                                   border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                              labelStyle: TextStyle(
                                  color: MainColor, fontFamily: 'Light')
                                ),
                                value: selectedInterest,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedInterest = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "กรุณาเลือกสิ่งที่สนใจ";
                                  }
                                },
                                items: interests.map((interest) {
                                  return DropdownMenuItem<String>(
                                    value: interest.interestId,
                                    child: Text(interest.interestName ?? ''),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 160,
                                child: TextFormField(
                                  controller: postDateStartController,
                                  enabled: false,
                                  readOnly: true,
                                  onTap: () => _selectDateStart(context),
                                  decoration: InputDecoration(
                                    labelText: "วันที่เริ่ม",
                                    counterText: "",
labelStyle: TextStyle(
                                  color: MainColor, fontFamily: 'Light'),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                              prefixIcon: Icon(Icons.calendar_month),
                              prefixIconColor: MainColor,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Itim',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              SizedBox(
                                width: 160,
                                child: TextFormField(
                                  controller: postDateStopController,
                                  readOnly: true,
                                  onTap: () => _selectDateStop(context),
                                  decoration: InputDecoration(
                                    labelText: "วันที่สิ้นสุด",
                                    counterText: "",
                                    labelStyle: TextStyle(
                                  color: MainColor, fontFamily: 'Light'),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                              prefixIcon: Icon(Icons.calendar_month),
                              prefixIconColor: MainColor,
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Itim',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                        child: Text(
                      "วันที่สิ้นสุดควรหากจากวันที่เริ่มต้นอย่างน้อย 1 วัน",
                      style: TextStyle(fontFamily: 'Light'),
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(height: 16),
                    Text(
                      "ส่วนของตัวเลือก",
                      style: TextStyle(fontSize: 20, fontFamily: 'Light'),
                    ),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: choices.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      choices[index].choiceImage != "" &&
                                              fileImagesToDisplay[index] == null
                                          ? GestureDetector(
                                              onTap: () {
                                                _pickFileChoices(index);
                                              },
                                              child:
                                                  fileImagesToDisplay[index] ==
                                                          null
                                                      ? Image.network(
                                                          baseURL +
                                                              '/choices/downloadimg/${choices[index].choiceImage}',
                                                          fit: BoxFit.cover,
                                                          width: 50,
                                                          height: 50,
                                                        )
                                                      : Image.file(
                                                          fileImagesToDisplay[
                                                                  index] ??
                                                              File(""),
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                            )
                                          : fileImagesToDisplay[index] != null
                                              ? GestureDetector(
                                                  child: fileImagesToDisplay[
                                                              index] !=
                                                          null
                                                      ? Image.file(
                                                          fileImagesToDisplay[
                                                                  index] ??
                                                              File(""),
                                                          width: 50,
                                                          height: 50,
                                                        )
                                                      : Image.asset(
                                                          'assets/images/logo.png'),
                                                  onTap: () {
                                                    _pickFileChoices(index);
                                                  },
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    _pickFileChoices(index);
                                                  },
                                                  child: Icon(Icons.image,
                                                      size: 30,
                                                      color: MainColor),
                                                ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue:
                                              choices[index].choiceName,
                                          decoration: InputDecoration(
                                            labelText:
                                                'ตัวเลือกที่ ${index + 1}',
                                            border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.blueGrey[50],
                                    labelStyle: TextStyle(
                                        color: MainColor, fontFamily: 'Light')
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              choices[index].choiceName = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value!.isNotEmpty) {
                                              return null;
                                            } else {
                                              return "กรุณากรอกตัวเลือก";
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // choices[index].choiceId == null
                                      //     ?
                                      InkWell(
                                        onTap: () => _removeChoice(index),
                                        child: Icon(Icons.cancel,
                                            size: 30, color: Colors.red),
                                      )
                                      // : SizedBox(
                                      //     width: 30,
                                      //   )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.green,
                              size: 30,
                            ), // ไอคอนและสี
                            onPressed: () {
                              _addNewChoice();
                            },
                          ),
                          Container(
                            height: 50,
                            child: ElevatedButton(
                                child: Text("ยืนยันการเปลี่ยนแปลง",style: TextStyle(fontFamily: 'Light',fontSize: 20),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MainColor,
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  if (fileToDisplay != null) {
                                    var uploadedFile = await postController
                                        .upload(fileToDisplay!);
                                    if (uploadedFile != null) {
                                      image = uploadedFile;
                                    }
                                  }
                                  if (fromKey.currentState!.validate()) {
                                    if (postDateStartController.text.isEmpty) {
                                      // แจ้งเตือนผู้ใช้ให้เลือกวันที่
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("แจ้งเตือน"),
                                            content: Text("โปรดเลือกวันที่เริ่ม"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("ปิด"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (postDateStopController
                                        .text.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("แจ้งเตือน"),
                                            content:
                                                Text("โปรดเลือกวันที่สิ้นสุด"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("ปิด"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (postDateStopController.text
                                            .compareTo(
                                                postDateStartController.text) <
                                        1) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("แจ้งเตือน"),
                                            content: Text(
                                                "โปรดเลือกวันที่สิ้นสุดให้มากกว่าวันที่เริ่ม"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("ปิด"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      print("------object pass------");
                                      print("${title ?? posts!.title}");
                                      print("${image ?? posts!.postImage}");
                                      print(
                                          "${description ?? posts!.description}");
                                      print("${point ?? posts!.postPoint}");
                                      print("${min ?? posts!.qtyMin}");
                                      print("${max ?? posts!.qtyMax}");
                                      print("${selectedInterest}");
                                      print(
                                          "${dateStart ?? formatDateNew(posts!.dateStart.toString())}");
                                      print(
                                          "${dateStop ?? formatDateNew(posts!.dateStop.toString())}");
                                      postController.doEditPost(
                                          posts!.postId.toString(),
                                          title ?? posts!.title.toString(),
                                          image ?? posts!.postImage.toString(),
                                          description ??
                                              posts!.description.toString(),
                                          point ?? posts!.postPoint.toString(),
                                          dateStart ??
                                              formatDateNew(
                                                  posts!.dateStart.toString()),
                                          dateStop ??
                                              formatDateNew(
                                                  posts!.dateStop.toString()),
                                          min ?? posts!.qtyMin.toString(),
                                          max ?? posts!.qtyMax.toString(),
                                          widget.username.toString(),
                                          selectedInterest ??
                                              posts!.interest!.interestId
                                                  .toString());
                                      for (int i = 0; i < choices.length; i++) {
                                        if (fileImagesToDisplay[i] != null) {
                                          var uploadedFile =
                                              await choiceController.upload(
                                                  fileImagesToDisplay[i] ??
                                                      File(""));
                                          if (uploadedFile != null) {
                                            choices[i].choiceImage = uploadedFile;
                                          }
                                        }
                                        print(
                                            "----------${choices[i].choiceImage}-----------");
                                        print("${choices[i].choiceId}");
                                        print("${choices[i].choiceName}");
                                        print("${choices[i].choiceImage}");
                          
                                        if (fromKey.currentState!.validate()) {
                                          await choiceController.editChoice(
                                              "true",
                                              choices[i].choiceId ?? "",
                                              choices[i].choiceName ?? "",
                                              choices[i].choiceImage ?? "",
                                              posts!.postId ?? "");
                                        }
                                      }
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return HomeScreen(
                                            username: widget.username);
                                      }));
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
