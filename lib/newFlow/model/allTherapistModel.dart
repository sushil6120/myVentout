class AllTherapistModel {
  bool? popupBool;
  bool? myTherapist;
  String? sId;
  String? phone;
  int? iV;
  List<Category>? category;
  String? createdAt;
  bool? isAvailable;
  bool? isFree;
  bool? isSuspended;
  List<String>? language;
  String? otp;
  String? otpExpiration;
  bool? registered;
  String? updatedAt;
  String? dOB;
  String? about;
  String? gender;
  String? name;
  String? profileImg;
  String? psychologistCategory;
  String? qualification;
  int? discountedFees;
  int? fees;
  double? feesPerMinute;
  List<String>? question1;
  List<String>? question2;
  String? aadharCard;
  String? degree;
  bool? risingStar;
  String? fcmToken;
  double? avgRating;
  int? feesForTenMinute;
  double? feesPerMinuteOfTenMinute;
  int? discountedFeesForTenMinute;
  double? discountedFeesPerMinute;
  double? discountedFeesPerMinuteOfTenMinute;

  AllTherapistModel({
    this.popupBool,
    this.myTherapist,
    this.sId,
    this.phone,
    this.iV,
    this.category,
    this.createdAt,
    this.isAvailable,
    this.isFree,
    this.isSuspended,
    this.language,
    this.otp,
    this.otpExpiration,
    this.registered,
    this.updatedAt,
    this.dOB,
    this.about,
    this.gender,
    this.name,
    this.profileImg,
    this.psychologistCategory,
    this.qualification,
    this.discountedFees,
    this.fees,
    this.feesPerMinute,
    this.question1,
    this.question2,
    this.aadharCard,
    this.degree,
    this.risingStar,
    this.fcmToken,
    this.avgRating,
    this.feesForTenMinute,
    this.feesPerMinuteOfTenMinute,
    this.discountedFeesForTenMinute,
    this.discountedFeesPerMinute,
    this.discountedFeesPerMinuteOfTenMinute,
  });

  factory AllTherapistModel.fromJson(Map<String, dynamic> json) {
    return AllTherapistModel(
      popupBool: json['popupBool'],
      myTherapist: json['myTherapist'],
      sId: json['_id'],
      phone: json['phone'],
      iV: json['__v'],
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'],
      isAvailable: json['isAvailable'],
      isFree: json['isFree'],
      isSuspended: json['isSuspended'],
      language: (json['language'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      otp: json['otp'],
      otpExpiration: json['otpExpiration'],
      registered: json['registered'],
      updatedAt: json['updatedAt'],
      dOB: json['DOB'],
      about: json['about'],
      gender: json['gender'],
      name: json['name'],
      profileImg: json['profileImg'],
      psychologistCategory: json['psychologistCategory'],
      qualification: json['qualification'],
      discountedFees: json['discountedFees']?.toInt(),
      fees: json['fees']?.toInt(),
      feesPerMinute: json['feesPerMinute']?.toDouble(),
      question1: (json['question1'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      question2: (json['question2'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      aadharCard: json['aadharCard'],
      degree: json['degree'],
      risingStar: json['risingStar'],
      fcmToken: json['fcmToken'],
      avgRating: json['avgRating']?.toDouble(),
      feesForTenMinute: json['feesForTenMinute']?.toInt(),
      feesPerMinuteOfTenMinute: json['feesPerMinuteOfTenMinute']?.toDouble(),
      discountedFeesForTenMinute: json['discountedFeesForTenMinute']?.toInt(),
      discountedFeesPerMinute: json['discountedFeesPerMinute']?.toDouble(),
      discountedFeesPerMinuteOfTenMinute:
          json['discountedFeesPerMinuteOfTenMinute']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'popupBool': popupBool,
      'myTherapist': myTherapist,
      '_id': sId,
      'phone': phone,
      '__v': iV,
      'category': category?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'isAvailable': isAvailable,
      'isFree': isFree,
      'isSuspended': isSuspended,
      'language': language,
      'otp': otp,
      'otpExpiration': otpExpiration,
      'registered': registered,
      'updatedAt': updatedAt,
      'DOB': dOB,
      'about': about,
      'gender': gender,
      'name': name,
      'profileImg': profileImg,
      'psychologistCategory': psychologistCategory,
      'qualification': qualification,
      'discountedFees': discountedFees,
      'fees': fees,
      'feesPerMinute': feesPerMinute,
      'question1': question1,
      'question2': question2,
      'aadharCard': aadharCard,
      'degree': degree,
      'risingStar': risingStar,
      'fcmToken': fcmToken,
      'avgRating': avgRating,
      'feesForTenMinute': feesForTenMinute,
      'feesPerMinuteOfTenMinute': feesPerMinuteOfTenMinute,
      'discountedFeesForTenMinute': discountedFeesForTenMinute,
      'discountedFeesPerMinute': discountedFeesPerMinute,
      'discountedFeesPerMinuteOfTenMinute':
          discountedFeesPerMinuteOfTenMinute,
    };
  }
}

class Category {
  String? sId;
  String? categoryName;
  String? emoji;

  Category({this.sId, this.categoryName, this.emoji});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      sId: json['_id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      emoji: json['emoji'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'categoryName': categoryName,
      'emoji': emoji,
    };
  }
}
