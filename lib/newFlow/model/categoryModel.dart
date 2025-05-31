class CategoryModel {
  String? sId;
  String? categoryName;
  String? emoji;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CategoryModel(
      {this.sId,
      this.categoryName,
      this.emoji,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
    emoji = json['emoji'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['categoryName'] = this.categoryName;
    data['emoji'] = this.emoji;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
