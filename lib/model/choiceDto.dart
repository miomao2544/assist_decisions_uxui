
class ChoiceDto{
  String? choiceName;
  String? choiceImage;

  ChoiceDto({
    this.choiceName,
    this.choiceImage,
  });

  factory ChoiceDto.fromJsonToChoiceDto(Map<String,dynamic> json) => ChoiceDto(
    choiceName: json["choiceName"],
    choiceImage: json["choiceImage"],
  );

  Map<String,dynamic> fromChoiceDtoToJson(){
    return<String,dynamic>{
      'choiceName' : choiceName,
      'choiceImage' : choiceImage,
    };
  }
}