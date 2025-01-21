class ZegoCloudeModel {
  String? message;
  List<ZegoCloud>? zegoCloud;

  ZegoCloudeModel({this.message, this.zegoCloud});

  ZegoCloudeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['zegoCloud'] != null) {
      zegoCloud = <ZegoCloud>[];
      json['zegoCloud'].forEach((v) {
        zegoCloud!.add(new ZegoCloud.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.zegoCloud != null) {
      data['zegoCloud'] = this.zegoCloud!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ZegoCloud {
  String? sId;
  String? appId;
  String? secretKey;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ZegoCloud(
      {this.sId,
      this.appId,
      this.secretKey,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ZegoCloud.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    appId = json['appId'];
    secretKey = json['secretKey'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['appId'] = this.appId;
    data['secretKey'] = this.secretKey;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
