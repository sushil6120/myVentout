class SingleSessionModel {
  String sId;
  BookedBy bookedBy;
  TherapistId therapistId;
  int fees;
  String timeDuration;
  String startTime;
  bool isInstant;
  String bookingStatus;
  String bookingType;
  bool isCompleted;
  bool endMeeting;
  bool isWebsite;
  String meetLink;
  Slot slot;
  String createdAt;
  String updatedAt;
  int iV;

  SingleSessionModel({
    this.sId = '',
    BookedBy? bookedBy,
    TherapistId? therapistId,
    this.fees = 0,
    this.timeDuration = '',
    this.startTime = '',
    this.isInstant = false,
    this.bookingStatus = '',
    this.bookingType = '',
    this.isCompleted = false,
    this.endMeeting = false,
    this.isWebsite = false,
    this.meetLink = '',
    Slot? slot,
    this.createdAt = '',
    this.updatedAt = '',
    this.iV = 0,
  })  : bookedBy = bookedBy ?? BookedBy(),
        therapistId = therapistId ?? TherapistId(),
        slot = slot ?? Slot();

  SingleSessionModel.fromJson(Map<String, dynamic> json)
      : sId = json['_id'] ?? '',
        bookedBy = json['bookedBy'] != null ? BookedBy.fromJson(json['bookedBy']) : BookedBy(),
        therapistId = json['therapistId'] != null ? TherapistId.fromJson(json['therapistId']) : TherapistId(),
        fees = json['fees'] ?? 0,
        timeDuration = json['timeDuration'] ?? '',
        startTime = json['startTime'] ?? '',
        isInstant = json['isInstant'] ?? false,
        bookingStatus = json['bookingStatus'] ?? '',
        bookingType = json['bookingType'] ?? '',
        isCompleted = json['isCompleted'] ?? false,
        endMeeting = json['endMeeting'] ?? false,
        isWebsite = json['isWebsite'] ?? false,
        meetLink = json['meetLink'] ?? '',
        slot = json['slot'] != null ? Slot.fromJson(json['slot']) : Slot(),
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '',
        iV = json['__v'] ?? 0;

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'bookedBy': bookedBy.toJson(),
        'therapistId': therapistId.toJson(),
        'fees': fees,
        'timeDuration': timeDuration,
        'startTime': startTime,
        'isInstant': isInstant,
        'bookingStatus': bookingStatus,
        'bookingType': bookingType,
        'isCompleted': isCompleted,
        'endMeeting': endMeeting,
        'isWebsite': isWebsite,
        'meetLink': meetLink,
        'slot': slot.toJson(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': iV,
      };
}

class BookedBy {
  String sId;
  String phone;
  int totalValue;
  String age;
  String gender;
  String name;

  BookedBy({
    this.sId = '',
    this.phone = '',
    this.totalValue = 0,
    this.age = '',
    this.gender = '',
    this.name = '',
  });

  BookedBy.fromJson(Map<String, dynamic> json)
      : sId = json['_id'] ?? '',
        phone = json['phone'] ?? '',
        totalValue = json['totalValue'] ?? 0,
        age = json['age'] ?? '',
        gender = json['gender'] ?? '',
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'phone': phone,
        'totalValue': totalValue,
        'age': age,
        'gender': gender,
        'name': name,
      };
}

class TherapistId {
  String sId;
  String phone;
  String gender;
  String name;
  String profileImg;

  TherapistId({
    this.sId = '',
    this.phone = '',
    this.gender = '',
    this.name = '',
    this.profileImg = '',
  });

  TherapistId.fromJson(Map<String, dynamic> json)
      : sId = json['_id'] ?? '',
        phone = json['phone'] ?? '',
        gender = json['gender'] ?? '',
        name = json['name'] ?? '',
        profileImg = json['profileImg'] ?? '';

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'phone': phone,
        'gender': gender,
        'name': name,
        'profileImg': profileImg,
      };
}

class Slot {
  String sId;
  String day;
  String slot;
  bool isWebsite;
  bool isAvailableWebsite;
  String createdAt;
  String updatedAt;
  int iV;

  Slot({
    this.sId = '',
    this.day = '',
    this.slot = '',
    this.isWebsite = false,
    this.isAvailableWebsite = false,
    this.createdAt = '',
    this.updatedAt = '',
    this.iV = 0,
  });

  Slot.fromJson(Map<String, dynamic> json)
      : sId = json['_id'] ?? '',
        day = json['day'] ?? '',
        slot = json['slot'] ?? '',
        isWebsite = json['isWebsite'] ?? false,
        isAvailableWebsite = json['isAvailableWebsite'] ?? false,
        createdAt = json['createdAt'] ?? '',
        updatedAt = json['updatedAt'] ?? '',
        iV = json['__v'] ?? 0;

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'day': day,
        'slot': slot,
        'isWebsite': isWebsite,
        'isAvailableWebsite': isAvailableWebsite,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': iV,
      };
}
