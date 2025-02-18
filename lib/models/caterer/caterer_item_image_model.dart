class CatererItemImagesModel {
  String? code;
  String? image;
  String? catererCode;
  String? itemCode;

  CatererItemImagesModel({
    this.code,
    this.image,
    this.catererCode,
    this.itemCode,
  });

  factory CatererItemImagesModel.fromJson(Map<String, dynamic> json) => CatererItemImagesModel(
    code: json["code"],
    image: json["image"],
    catererCode: json["caterer_code"],
    itemCode: json["item_code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "image": image,
    "caterer_code": catererCode,
    "item_code": itemCode,
  };
}