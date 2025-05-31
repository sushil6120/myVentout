class ReviewModel {
  String? sId;
  String? review;
  int? rating;
  TherapistId? therapistId;
  UserId? userId;
  bool? isApproved;
  DateTime? createdAt;
  String? updatedAt;
  int? iV;

  ReviewModel(
      {this.sId,
      this.review,
      this.rating,
      this.therapistId,
      this.userId,
      this.isApproved,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    review = json['review'];
    rating = json['rating'];
    therapistId = json['therapistId'] != null
        ? new TherapistId.fromJson(json['therapistId'])
        : null;
    userId =
        json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    isApproved = json['isApproved'];
    createdAt = DateTime.parse(json['createdAt'] ?? DateTime.now().toString());
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['review'] = this.review;
    data['rating'] = this.rating;
    if (this.therapistId != null) {
      data['therapistId'] = this.therapistId!.toJson();
    }
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['isApproved'] = this.isApproved;
    data['createdAt'] = createdAt!.toIso8601String();
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class TherapistId {
  String? sId;
  String? name;
  String? profileImg;

  TherapistId({this.sId, this.name, this.profileImg});

  TherapistId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profileImg'] = this.profileImg;
    return data;
  }
}

class UserId {
  String? sId;
  String? name;

  UserId({this.sId, this.name});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
