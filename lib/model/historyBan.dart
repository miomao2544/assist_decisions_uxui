import 'package:assist_decisions_app/model/banType.dart';
import 'package:assist_decisions_app/model/member.dart';

class HistoryBan{
  String? historyId;
  String? banComment;
  String? banDate;
  BanType? banType;
  Member? member;

  HistoryBan({
    this.historyId,
    this.banComment,
    this.banDate,
    this.banType,
    this.member,
  });

  factory HistoryBan.fromJsonToHistoryBan(Map<String,dynamic> json) => HistoryBan(
    historyId: json["historyId"],
    banComment: json["banComment"],
    banDate: json["banDate"],
    banType: json["banType"] == null?null: BanType.fromJsonToBanType(json["banType"]),
    member: json["member"] == null?null: Member.fromJsonToMember(json["member"]),
  );

  Map<String,dynamic> fromHistoryBanToJson(){
    return<String,dynamic>{
      'historyId' : historyId,
      'banComment' : banComment,
      'banDate' : banDate,
      'banType' : banType?.banTypeId,
      'member' : member?.username,
    };
  }
}