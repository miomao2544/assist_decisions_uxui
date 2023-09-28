class BanType{
  String? banTypeId;
  String? typeName;
  int? numberOfDay;

  BanType({
    this.banTypeId,
    this.typeName,
    this.numberOfDay,
  });

  factory BanType.fromJsonToBanType(Map<String,dynamic> json) => BanType(
    banTypeId: json["banTypeId"],
    typeName: json["typeName"],
    numberOfDay: json["numberOfDay"],
  );

  Map<String,dynamic> fromBanTypeToJson(){
    return<String,dynamic>{
      'banTypeId' : banTypeId,
      'typeName' : typeName,
      'numberOfDay' : numberOfDay,
    };
  }
}