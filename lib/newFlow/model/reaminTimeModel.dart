class remainTimeModel {
  double? remainingMinutes;

  remainTimeModel({this.remainingMinutes});

  remainTimeModel.fromJson(Map<String, dynamic> json) {
    // Ensure that remainingMinutes is always a double
    if (json['remainingMinutes'] is int) {
      remainingMinutes = (json['remainingMinutes'] as int).toDouble();
    } else if (json['remainingMinutes'] is double) {
      remainingMinutes = json['remainingMinutes'] as double;
    } else {
      remainingMinutes = 0.0; 
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remainingMinutes'] = this.remainingMinutes;
    return data;
  }
}
