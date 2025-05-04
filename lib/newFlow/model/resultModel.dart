class ResultModel {
  List<Data>? data;

  ResultModel({this.data});

  ResultModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? title;
  String? score;
  String? description;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.title,
      this.score,
      this.description,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id']??'';
    title = json['title']??'';
    score = json['score']??'';
    description = json['description']??'';
    image = json['image']??'';
    createdAt = json['createdAt']??'';
    updatedAt = json['updatedAt']??'';
    iV = json['__v']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['score'] = this.score;
    data['description'] = this.description;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
