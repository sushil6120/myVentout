class TherapistBycateModel {
  bool? popupBool;
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

  TherapistBycateModel({
    this.popupBool,
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
  });

  factory TherapistBycateModel.fromJson(Map<String, dynamic> json) {
    return TherapistBycateModel(
      popupBool: json['popupBool'],
      sId: json['_id'],
      phone: json['phone'],
      iV: json['__v'],
      category: (json['category'] as List<dynamic>?)?.map((e) {
        // Check if each item is a map
        if (e is Map<String, dynamic>) {
          return Category.fromJson(e);
        } else {
          throw Exception('Unexpected category item format: $e');
        }
      }).toList(),
      createdAt: json['createdAt'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      isFree: json['isFree'] ?? false,
      isSuspended: json['isSuspended'] ?? false,
      language: (json['language'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      otp: json['otp'] ?? '',
      otpExpiration: json['otpExpiration'] ?? '',
      registered: json['registered'] ?? false,
      updatedAt: json['updatedAt'] ?? '',
      dOB: json['DOB'] ?? '',
      about: json['about'] ?? '',
      gender: json['gender'] ?? '',
      name: json['name'] ?? '',
      profileImg: json['profileImg'] ?? '',
      psychologistCategory: json['psychologistCategory'] ?? '',
      qualification: json['qualification'] ?? '',
      discountedFees: (json['discountedFees'] as int?) ??
          (json['discountedFees'] as double?)?.toInt() ??
          0,
      fees: (json['fees'] as int?) ?? (json['fees'] as double?)?.toInt() ?? 0,
      feesPerMinute: json['feesPerMinute']?.toDouble() ?? 0.0,
      question1: (json['question1'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      question2: (json['question2'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      aadharCard: json['aadharCard'] ?? '',
      degree: json['degree'] ?? '',
      risingStar: json['risingStar'] ?? false,
      fcmToken: json['fcmToken'] ?? '',
      avgRating: json['avgRating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'popupBool': popupBool,
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
