class SessionHistoryModel {
  String? sId;
  BookedBy? bookedBy;
  TherapistId? therapistId;  // New field
  SessionId? sessionId;
  DateTime? createdAt;
  DateTime? updatedAt;  // Updated to DateTime type
  int? iV;

  SessionHistoryModel(
      {this.sId,
      this.bookedBy,
      this.therapistId,  // New field
      this.sessionId,
      this.createdAt,
      this.updatedAt,  // Updated
      this.iV});

  SessionHistoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bookedBy = json['bookedBy'] != null
        ? BookedBy.fromJson(json['bookedBy'])
        : null;
    therapistId = json['therapistId'] != null
        ? TherapistId.fromJson(json['therapistId'])  // New field
        : null;
    sessionId = json['sessionId'] != null
        ? SessionId.fromJson(json['sessionId'])
        : null;
    createdAt = DateTime.parse(json['createdAt'] ?? DateTime.now().toString());
    updatedAt = DateTime.parse(json['updatedAt'] ?? DateTime.now().toString());  // Updated
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    if (bookedBy != null) {
      data['bookedBy'] = bookedBy!.toJson();
    }
    if (therapistId != null) {  // New field
      data['therapistId'] = therapistId!.toJson();
    }
    if (sessionId != null) {
      data['sessionId'] = sessionId!.toJson();
    }
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();  // Updated
    data['__v'] = iV;
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
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['phone'] = phone;
    data['age'] = age;
    data['name'] = name;
    return data;
  }
}

class TherapistId {  // New class for therapist details
  String? sId;
  String? name;
  String? phone;
  String? profileImg;

  TherapistId({this.sId, this.name, this.phone, this.profileImg});

  TherapistId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    data['profileImg'] = profileImg;
    return data;
  }
}

class SessionId {
  String? sId;
  double? fees;
  String? timeDuration;
  String? bookingStatus;

  SessionId({this.sId, this.fees, this.timeDuration, this.bookingStatus});

  SessionId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fees = json['fees'] != null
        ? (json['fees'] is int ? (json['fees'] as int).toDouble() : json['fees'])
        : null;
    timeDuration = json['timeDuration'];
    bookingStatus = json['bookingStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['fees'] = fees;
    data['timeDuration'] = timeDuration;
    data['bookingStatus'] = bookingStatus;
    return data;
  }
}
