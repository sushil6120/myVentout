class StoryModel {
  String? sId;
  String? title;
  String? description;
  String? image;
  List<String>? categoryId;
  String? indexTime;
  String? createdAt;
  String? updatedAt;
  int? iV;

  StoryModel(
      {this.sId,
      this.title,
      this.description,
      this.image,
      this.categoryId,
      this.indexTime,
      this.createdAt,
      this.updatedAt,
      this.iV});

  StoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    categoryId = json['categoryId'].cast<String>();
    indexTime = json['indexTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['categoryId'] = this.categoryId;
    data['indexTime'] = this.indexTime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
