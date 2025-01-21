class CreateSessionModel {
  String? message;
  PopulatedSession? populatedSession;

  CreateSessionModel({this.message, this.populatedSession});

  CreateSessionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    populatedSession = json['populatedSession'] != null
        ? new PopulatedSession.fromJson(json['populatedSession'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.populatedSession != null) {
      data['populatedSession'] = this.populatedSession!.toJson();
    }
    return data;
  }
}

class PopulatedSession {
  String? bookedBy;
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
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PopulatedSession(
      {this.bookedBy,
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
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PopulatedSession.fromJson(Map<String, dynamic> json) {
    bookedBy = json['bookedBy'];
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
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookedBy'] = this.bookedBy;
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
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
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
