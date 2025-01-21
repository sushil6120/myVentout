class TherapistProfileModel {
  String? sId;
  String? phone;
  int? iV;
  double? avgRating;
  List<Category>? category;
  String? createdAt;
  bool? isAvailable;
  bool? isFree;
  bool? isSuspended;
  List<String>? language;
  String? otp;
  String? otpExpiration;
  bool? popupBool;
  bool? risingStar;
  bool? registered;
  String? updatedAt;
  String? dOB;
  String? about;
  String? experience;
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
  String? fcmToken;
  int? feesForTenMinute;
  double? feesPerMinuteOfTenMinute;
  String? aadharCard;
  String? degree;
  int? discountedFeesForTenMinute;
  double? discountedFeesPerMinute;
  double? discountedFeesPerMinuteOfTenMinute;

  TherapistProfileModel({
    this.sId,
    this.phone,
    this.iV,
    this.avgRating,
    this.category,
    this.createdAt,
    this.isAvailable,
    this.isFree,
    this.isSuspended,
    this.language,
    this.otp,
    this.otpExpiration,
    this.popupBool,
    this.risingStar,
    this.registered,
    this.updatedAt,
    this.dOB,
    this.about,
    this.experience,
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
    this.fcmToken,
    this.feesForTenMinute,
    this.feesPerMinuteOfTenMinute,
    this.aadharCard,
    this.degree,
    this.discountedFeesForTenMinute,
    this.discountedFeesPerMinute,
    this.discountedFeesPerMinuteOfTenMinute,
  });

  TherapistProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    iV = json['__v'];
    avgRating = json['avgRating']?.toDouble();
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    isAvailable = json['isAvailable'];
    isFree = json['isFree'];
    isSuspended = json['isSuspended'];
    language = json['language'].cast<String>();
    otp = json['otp'];
    otpExpiration = json['otpExpiration'];
    popupBool = json['popupBool'];
    risingStar = json['risingStar'];
    registered = json['registered'];
    updatedAt = json['updatedAt'];
    dOB = json['DOB'];
    about = json['about'];
    experience = json['experience'];
    gender = json['gender'];
    name = json['name'];
    profileImg = json['profileImg'];
    psychologistCategory = json['psychologistCategory'];
    qualification = json['qualification'];
    discountedFees = json['discountedFees'];
    fees = json['fees'];
    feesPerMinute = json['feesPerMinute']?.toDouble();
    question1 = json['question1'].cast<String>();
    question2 = json['question2'].cast<String>();
    fcmToken = json['fcmToken'];
    feesForTenMinute = json['feesForTenMinute'];
    feesPerMinuteOfTenMinute = json['feesPerMinuteOfTenMinute']?.toDouble();
    aadharCard = json['aadharCard'];
    degree = json['degree'];
    discountedFeesForTenMinute = json['discountedFeesForTenMinute'];
    discountedFeesPerMinute = json['discountedFeesPerMinute']?.toDouble();
    discountedFeesPerMinuteOfTenMinute = json['discountedFeesPerMinuteOfTenMinute']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['phone'] = phone;
    data['__v'] = iV;
    data['avgRating'] = avgRating;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['isAvailable'] = isAvailable;
    data['isFree'] = isFree;
    data['isSuspended'] = isSuspended;
    data['language'] = language;
    data['otp'] = otp;
    data['otpExpiration'] = otpExpiration;
    data['popupBool'] = popupBool;
    data['risingStar'] = risingStar;
    data['registered'] = registered;
    data['updatedAt'] = updatedAt;
    data['DOB'] = dOB;
    data['about'] = about;
    data['experience'] = experience;
    data['gender'] = gender;
    data['name'] = name;
    data['profileImg'] = profileImg;
    data['psychologistCategory'] = psychologistCategory;
    data['qualification'] = qualification;
    data['discountedFees'] = discountedFees;
    data['fees'] = fees;
    data['feesPerMinute'] = feesPerMinute;
    data['question1'] = question1;
    data['question2'] = question2;
    data['fcmToken'] = fcmToken;
    data['feesForTenMinute'] = feesForTenMinute;
    data['feesPerMinuteOfTenMinute'] = feesPerMinuteOfTenMinute;
    data['aadharCard'] = aadharCard;
    data['degree'] = degree;
    data['discountedFeesForTenMinute'] = discountedFeesForTenMinute;
    data['discountedFeesPerMinute'] = discountedFeesPerMinute;
    data['discountedFeesPerMinuteOfTenMinute'] = discountedFeesPerMinuteOfTenMinute;
    return data;
  }
}

class Category {
  String? sId;
  String? categoryName;
  String? emoji;

  Category({this.sId, this.categoryName, this.emoji});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['categoryName'] = categoryName;
    data['emoji'] = emoji;
    return data;
  }
}
