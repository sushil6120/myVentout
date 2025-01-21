class OtpVerifyModel {
  String? message;
  String? phone;
  String? userId;
  bool? isRegistered;
  String? name;
  bool? freeStatus;
  String? token;

  OtpVerifyModel(
      {this.message,
      this.phone,
      this.userId,
      this.isRegistered,
      this.name,
      this.freeStatus,
      this.token});

  OtpVerifyModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    phone = json['phone'];
    userId = json['userId'];
    isRegistered = json['isRegistered'];
    name = json['name'];
    freeStatus = json['freeStatus'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['phone'] = this.phone;
    data['userId'] = this.userId;
    data['isRegistered'] = this.isRegistered;
    data['name'] = this.name;
    data['freeStatus'] = this.freeStatus;
    data['token'] = this.token;
    return data;
  }
}
