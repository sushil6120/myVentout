class CreatePaymentModel {
  String? message;
  String? orderId;

  CreatePaymentModel({this.message, this.orderId});

  CreatePaymentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['orderId'] = this.orderId;
    return data;
  }
}
