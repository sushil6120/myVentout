class UserProfileModel {
  String sId;
  String phone;
  int iV;
  List<String> category;
  bool isRegistered;
  bool isSuspended;
  List<String> language;
  String otp;
  String otpExpiration;
  List<Qna> qna;
  int totalValue;
  String age;
  String gender;
  String name;
  String fcmToken;
  String pdf;

  UserProfileModel({
    this.sId = "",
    this.phone = "",
    this.iV = 0,
    List<String>? category,
    this.isRegistered = false,
    this.isSuspended = false,
    List<String>? language,
    this.otp = "",
    this.otpExpiration = "",
    List<Qna>? qna,
    this.totalValue = 0,
    this.age = "",
    this.gender = "",
    this.name = "",
    this.fcmToken = "",
    this.pdf = "",
  })  : category = category ?? [],
        language = language ?? [],
        qna = qna ?? [];

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : sId = json['_id'] ?? "",
        phone = json['phone'] ?? "",
        iV = json['__v'] ?? 0,
        category = List<String>.from(json['category'] ?? []),
        isRegistered = json['isRegistered'] ?? false,
        isSuspended = json['isSuspended'] ?? false,
        language = List<String>.from(json['language'] ?? []),
        otp = json['otp'] ?? "",
        otpExpiration = json['otpExpiration'] ?? "",
        qna = (json['qna'] as List?)?.map((v) => Qna.fromJson(v)).toList() ?? [],
        totalValue = json['totalValue'] ?? 0,
        age = json['age'] ?? "",
        gender = json['gender'] ?? "",
        name = json['name'] ?? "",
        fcmToken = json['fcmToken'] ?? "",
        pdf = json['pdf'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'phone': phone,
      '__v': iV,
      'category': category,
      'isRegistered': isRegistered,
      'isSuspended': isSuspended,
      'language': language,
      'otp': otp,
      'otpExpiration': otpExpiration,
      'qna': qna.map((v) => v.toJson()).toList(),
      'totalValue': totalValue,
      'age': age,
      'gender': gender,
      'name': name,
      'fcmToken': fcmToken,
      'pdf': pdf,
    };
  }
}

class Qna {
  String question;
  String answer;
  int value;
  String sId;

  Qna({
    this.question = "",
    this.answer = "",
    this.value = 0,
    this.sId = "",
  });

  Qna.fromJson(Map<String, dynamic> json)
      : question = json['question'] ?? "",
        answer = json['answer'] ?? "",
        value = json['value'] ?? 0,
        sId = json['_id'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'value': value,
      '_id': sId,
    };
  }
}
