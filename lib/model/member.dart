
import 'package:assist_decisions_app/model/interest.dart';

class Member{
  String? username;
  String? password;
  String? nickname;
  String? gender;
  String? firstname;
  String? lastname;
  String? email;
  String? tel;
  String? image;
  String? status;
  bool? adminstatus;
  int? point;
  Interest? interest;

  Member({
    this.username,
    this.password,
    this.nickname,
    this.gender,
    this.firstname,
    this.lastname,
    this.email,
    this.tel,
    this.image,
    this.status,
    this.adminstatus,
    this.point,
    this.interest
  });

  factory Member.fromJsonToMember(Map<String,dynamic> json) => Member(
    username: json["username"],
    password: json["password"],
    nickname: json["nickname"],
    gender: json["gender"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    tel: json["tel"],
    image: json["image"],
    status: json["status"],
    adminstatus: json["adminstatus"],
    point: json["point"],
    interest: json["interest"] == null?null: Interest.fromJsonToInterest(json["interest"])
  );
  Map<String,dynamic> fromMemberToJson(){
    return<String,dynamic>{
      'username' : username,
      'password' : password,
      'nickname' : nickname,
      'gender' : gender,
      'firstname' : firstname,
      'lastname' : lastname,
      'email' : email,
      'tel' : tel,
      'image' : image,
      'status' : status,
      'adminstatus' : adminstatus,
      'point' : point,
      'interests': interest?.interestId
    };
  }
}