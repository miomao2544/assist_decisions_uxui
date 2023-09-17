import 'package:assist_decisions_app/model/post.dart';

class Choice{
  String? choiceID;
  String? choiceName;
  String? choiceImage;
  Post? post;

  Choice({
    this.choiceID,
    this.choiceName,
    this.choiceImage,
    this.post,
  });

  factory Choice.fromJsonToChoice(Map<String,dynamic> json) => Choice(
    choiceID: json["choiceID"],
    choiceName: json["choiceName"],
    choiceImage: json["choiceImage"],
    post: json["post"] == null?null: Post.fromJsonToPost(json["post"]),
  );

  Map<String,dynamic> fromChoiceToJson(){
    return<String,dynamic>{
      'choiceID' : choiceID,
      'choiceName' : choiceName,
      'choiceImage' : choiceImage,
      'post' : post?.postID
    };
  }


  
}