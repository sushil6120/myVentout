class WalletModel {
  String? sId;
  double? balance;
  String? userData;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WalletModel({
    this.sId,
    this.balance,
    this.userData,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  WalletModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    // Handle balance that might be an int or double
    balance = json['balance'] != null 
        ? (json['balance'] is int 
            ? (json['balance'] as int).toDouble() 
            : json['balance'])
        : null;
    userData = json['userData'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['balance'] = this.balance;
    data['userData'] = this.userData;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
