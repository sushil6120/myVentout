class SendNotificationModel {
  String? userId;
  String? therapistId;
  String? sessionId;
  String? bookingType;
  String? fees;
  String? callerName;
  String? agoraToken;
  String? channelName;

  SendNotificationModel(
      {this.userId,
      this.therapistId,
      this.sessionId,
      this.bookingType,
      this.fees,
      this.callerName,
      this.agoraToken,
      this.channelName});

  SendNotificationModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    therapistId = json['therapistId'];
    sessionId = json['sessionId'];
    bookingType = json['bookingType'];
    fees = json['fees'];
    callerName = json['callerName'];
    agoraToken = json['agoraToken'];
    channelName = json['channelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['therapistId'] = this.therapistId;
    data['sessionId'] = this.sessionId;
    data['bookingType'] = this.bookingType;
    data['fees'] = this.fees;
    data['callerName'] = this.callerName;
    data['agoraToken'] = this.agoraToken;
    data['channelName'] = this.channelName;
    return data;
  }
}
