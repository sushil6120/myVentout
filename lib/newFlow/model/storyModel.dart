// class StoryModel {
//   String? sId;
//   String? title;
//   String? description;
//   String? shortDescription;
//   String? image;
//   List<String>? categoryId;
//   String? indexTime;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   StoryModel(
//       {this.sId,
//       this.title,
//       this.description,
//       this.shortDescription,
//       this.image,
//       this.categoryId,
//       this.indexTime,
//       this.createdAt,
//       this.updatedAt,
//       this.iV});
//
//   StoryModel.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     title = json['title'];
//     description = json['description'];
//     shortDescription = json['shortDescription'];
//     image = json['image'];
//     categoryId = json['categoryId'].cast<String>();
//     indexTime = json['indexTime'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['shortDescription'] = this.shortDescription;
//     data['image'] = this.image;
//     data['categoryId'] = this.categoryId;
//     data['indexTime'] = this.indexTime;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }

class StoryModel {
  String? sId;
  String? title;
  String? shortDescription;
  String? description;
  String? image;
  List<CategoryId>? categoryId;
  String? indexTime;
  String? createdAt;
  String? updatedAt;
  int? iV;

  StoryModel(
      {this.sId,
        this.title,
        this.shortDescription,
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
    shortDescription = json['shortDescription'];
    description = json['description'];
    image = json['image'];
    if (json['categoryId'] != null) {
      categoryId = <CategoryId>[];
      json['categoryId'].forEach((v) {
        categoryId!.add(new CategoryId.fromJson(v));
      });
    }
    indexTime = json['indexTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['shortDescription'] = this.shortDescription;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.categoryId != null) {
      data['categoryId'] = this.categoryId!.map((v) => v.toJson()).toList();
    }
    data['indexTime'] = this.indexTime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class CategoryId {
  String? sId;
  String? categoryName;
  String? emoji;

  CategoryId({this.sId, this.categoryName, this.emoji});

  CategoryId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['categoryName'] = this.categoryName;
    data['emoji'] = this.emoji;
    return data;
  }
}




