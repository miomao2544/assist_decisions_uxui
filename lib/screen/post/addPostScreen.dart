import 'package:assist_decisions_app/controller/choiceController.dart';
import 'package:assist_decisions_app/controller/interestController.dart';
import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/interest.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../validators/validatorPost.dart';

class AddPostScreen extends StatefulWidget {
  final String username;
  const AddPostScreen({required this.username});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  String? title;
  String? image;
  String? description;
  String? point;
  String? min;
  String? max;
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
  List<String>? fileImageName = [];
  List<File>? fileImagesToDisplay = [];
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

  void _pickFileChoices() async {
    try {
      setState(() {
        isLoadingPicture = true;
      });

      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
      if (filePickerResult != null) {
        fileImageName?.add(filePickerResult!.files.first.name);
        pickedFile = filePickerResult!.files.first;
        fileImagesToDisplay?.add(File(pickedFile!.path.toString()));
      }
      print("File is ${fileImageName![0]}");
      setState(() {
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _removeChoice(int index) {
    setState(() {
      if (index >= 0 && index < choices.length) {
        choices.removeAt(index);
      }
      if (fileImagesToDisplay != null &&
          index >= 0 &&
          index < fileImagesToDisplay!.length) {
        fileImagesToDisplay!.removeAt(index);
      }
      if (fileImageName != null &&
          index >= 0 &&
          index < fileImageName!.length) {
        fileImageName!.removeAt(index);
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
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    loadInterests();
    for (int i = 0; i < 2; i++) {
      choices.add(Choice(choiceName: ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MainColor,
          title: Text("สร้างโพสต์"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: fromKey,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'หัวข้อ',
                      border: OutlineInputBorder(),
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
                        ? Image.asset(
                            "assets/images/logo.png",
                            width: 250,
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
                      label: Text("เลือกรูปภาพ"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          isLoadingPicture ? MainColor : SecondColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                      border: OutlineInputBorder(),
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 120.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 120.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 120.0,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
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
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'สิ่งที่สนใจ',
                          border: OutlineInputBorder(),
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
                          readOnly: true,
                          onTap: () => _selectDateStart(context),
                          decoration: InputDecoration(
                            labelText: "วันที่เริ่ม",
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
                      SizedBox(width: 16),
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
                    ],
                  ),
                  SizedBox(height: 16),
                  for (int i = 0; i < choices.length; i++) ...[
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Center(
                            child: fileImagesToDisplay != null &&
                                    fileImagesToDisplay!.isNotEmpty &&
                                    i < fileImagesToDisplay!.length
                                ? GestureDetector(
                                    child: Image.file(
                                      fileImagesToDisplay![i],
                                      width: 100,
                                      height: 100,
                                    ),
                                    onTap: () {
                                      _pickFileChoices();
                                    },
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      _pickFileChoices();
                                    },
                                    child: Icon(Icons.image,
                                        size: 30, color: MainColor),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'ตัวเลือกที่ ${i + 1}',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  choices[i].choiceName = value;
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
                          InkWell(
                            onTap: () => _removeChoice(i),
                            child:
                                Icon(Icons.cancel, size: 30, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 30,
                    ), // ไอคอนและสี
                    onPressed: () {
                      setState(() {
                        choices.add(Choice(choiceName: ''));
                      });
                    },
                  ),
                  ElevatedButton(
                      child: Text("ยืนยัน"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColor,
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (fileToDisplay != null) {
                          var uploadedFile =
                              await postController.upload(fileToDisplay!);
                          if (uploadedFile != null) {
                            image = uploadedFile;
                          }
                        }
                        for (int i = 0; i < fileImagesToDisplay!.length; i++) {
                          //  != null
                          if (fileImagesToDisplay?[i] != null) {
                            var uploadedFile = await choiceController
                                .upload(fileImagesToDisplay![i]);

                            if (uploadedFile != null) {
                              images!.add(uploadedFile);
                            }
                            print(
                                "----------${images![i].toString()}-----------");
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
                          } else if (postDateStopController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("แจ้งเตือน"),
                                  content: Text("โปรดเลือกวันที่สิ้นสุด"),
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
                                  .compareTo(postDateStartController.text) <
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
                            int pointresult = int.parse(point!);
                            await memberController.doUpdatePoint(
                                widget.username,
                                (pointmember! - pointresult).toString());
                            var response = await postController.doAddPost(
                                title ?? "",
                                image ?? "I00002.png",
                                description ?? "",
                                point ?? "",
                                dateStart ?? "",
                                dateStop ?? "",
                                min ?? "",
                                max ?? "",
                                widget.username.toString(),
                                selectedInterest ?? '');

                            for (int i = 0; i < choices.length; i++) {
                              Choice choice = choices[i];
                              await choiceController.addChoice(
                                choice.choiceName ?? '',
                                images != null && i < images!.length
                                    ? images![i]
                                    : "",
                                response["postId"],
                              );
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomeScreen(username: widget.username);
                              }));
                            }
                          }
                          print("------object pass------");
                          print("${title}");
                          print("${image ?? "I00002.png"}");
                          print("${description}");
                          print("${point}");
                          print("${min}");
                          print("${max}");
                          print("${selectedInterest}");
                          print("${dateStart}");
                          print("${dateStop}");
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}