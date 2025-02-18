class ItemImagesModel {
  String? code;
  String? image;
  String? itemCode;

  ItemImagesModel({
    this.code,
    this.image,
    this.itemCode,
  });

  factory ItemImagesModel.fromJson(Map<String, dynamic> json) => ItemImagesModel(
    code: json["code"],
    image: json["image"],
    itemCode: json["item_code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "image": image,
    "item_code": itemCode,
  };
}