import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/member.dart';

class Vote{
  String? voteId;
  String? voteDate;
  Member? member;
  Choice? choice;

  Vote({
    this.voteId,
    this.voteDate,
    this.member,
    this.choice,
  });

  factory Vote.fromJsonToVote(Map<String,dynamic> json) => Vote(
    voteId: json["voteId"],
    voteDate: json["voteDate"],
    member: json["member"] == null?null: Member.fromJsonToMember(json["member"]),
    choice: json["choice"] == null?null: Choice.fromJsonToChoice(json["choice"]),
  );

  Map<String,dynamic> fromVoteToJson(){
    return<String,dynamic>{
      'voteId' : voteId,
      'voteDate' : voteDate,
      'member' : member?.username,
      'choice' : choice?.choiceId,
    };
  }
}