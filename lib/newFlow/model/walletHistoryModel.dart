class WalletHistoryModel {
  String? sId;
  int? transactionAmount;
  bool? isDeducted;
  String? userData;
  TransactionWith? transactionWith;
  String? transactionToModel;
  DateTime? createdAt;
  String? updatedAt;
  int? iV;

  WalletHistoryModel(
      {this.sId,
      this.transactionAmount,
      this.isDeducted,
      this.userData,
      this.transactionWith,
      this.transactionToModel,
      this.createdAt,
      this.updatedAt,
      this.iV});

  WalletHistoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Handling the transactionAmount being a double or int
    transactionAmount = (json['transactionAmount'] is double)
        ? (json['transactionAmount'] as double).toInt()
        : json['transactionAmount'];

    isDeducted = json['isDeducted'];
    userData = json['userData'];
    transactionWith = json['transactionWith'] != null
        ? new TransactionWith.fromJson(json['transactionWith'])
        : null;
    transactionToModel = json['transactionToModel'];
    createdAt = DateTime.parse(json['createdAt'] ?? DateTime.now().toString());
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['transactionAmount'] = this.transactionAmount;
    data['isDeducted'] = this.isDeducted;
    data['userData'] = this.userData;
    if (this.transactionWith != null) {
      data['transactionWith'] = this.transactionWith!.toJson();
    }
    data['transactionToModel'] = this.transactionToModel;
    data['createdAt'] = createdAt!.toIso8601String();
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class TransactionWith {
  String? sId;
  String? name;
  String? profileImg;

  TransactionWith({this.sId, this.name, this.profileImg});

  TransactionWith.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profileImg'] = this.profileImg;
    return data;
  }
}
