class SingleSessionModel {
  String? sId;
  BookedBy? bookedBy;
  TherapistId? therapistId;
  double? fees;
  String? timeDuration;
  String? startTime;
  bool? isInstant;
  String? bookingStatus;
  String? agoraToken;
  String? channelName;
  String? bookingType;
  bool? isCompleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SingleSessionModel(
      {this.sId,
      this.bookedBy,
      this.therapistId,
      this.fees,
      this.timeDuration,
      this.startTime,
      this.isInstant,
      this.bookingStatus,
      this.agoraToken,
      this.channelName,
      this.bookingType,
      this.isCompleted,
      this.createdAt,
      this.updatedAt,
      this.iV});

  SingleSessionModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bookedBy = json['bookedBy'] != null
        ? new BookedBy.fromJson(json['bookedBy'])
        : null;
    therapistId = json['therapistId'] != null
        ? new TherapistId.fromJson(json['therapistId'])
        : null;
    fees = json['fees'] != null
        ? (json['fees'] is int
            ? (json['fees'] as int).toDouble()
            : json['fees'])
        : null;
    timeDuration = json['timeDuration'];
    startTime = json['startTime'];
    isInstant = json['isInstant'];
    bookingStatus = json['bookingStatus'];
    agoraToken = json['agoraToken'];
    channelName = json['channelName'];
    bookingType = json['bookingType'];
    isCompleted = json['isCompleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.bookedBy != null) {
      data['bookedBy'] = this.bookedBy!.toJson();
    }
    if (this.therapistId != null) {
      data['therapistId'] = this.therapistId!.toJson();
    }
    data['fees'] = this.fees;
    data['timeDuration'] = this.timeDuration;
    data['startTime'] = this.startTime;
    data['isInstant'] = this.isInstant;
    data['bookingStatus'] = this.bookingStatus;
    data['agoraToken'] = this.agoraToken;
    data['channelName'] = this.channelName;
    data['bookingType'] = this.bookingType;
    data['isCompleted'] = this.isCompleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class BookedBy {
  String? sId;
  String? phone;
  String? age;
  String? name;

  BookedBy({this.sId, this.phone, this.age, this.name});

  BookedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    age = json['age'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phone'] = this.phone;
    data['age'] = this.age;
    data['name'] = this.name;
    return data;
  }
}

class TherapistId {
  String? sId;
  String? phone;
  String? name;
  String? profileImg;

  TherapistId({this.sId, this.phone, this.name, this.profileImg});

  TherapistId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    name = json['name'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['profileImg'] = this.profileImg;
    return data;
  }
}
