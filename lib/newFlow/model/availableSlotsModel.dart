class AvailableSlotsModel {
  String? therapistId;
  String? name;
  List<AvailableSlots>? availableSlots;
  bool? slotAvailability;

  AvailableSlotsModel(
      {this.therapistId,
        this.name,
        this.availableSlots,
        this.slotAvailability});

  AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    therapistId = json['therapistId'];
    name = json['name'];
    if (json['availableSlots'] != null) {
      availableSlots = <AvailableSlots>[];
      json['availableSlots'].forEach((v) {
        availableSlots!.add(new AvailableSlots.fromJson(v));
      });
    }
    slotAvailability = json['slotAvailability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['therapistId'] = this.therapistId;
    data['name'] = this.name;
    if (this.availableSlots != null) {
      data['availableSlots'] =
          this.availableSlots!.map((v) => v.toJson()).toList();
    }
    data['slotAvailability'] = this.slotAvailability;
    return data;
  }
}

class AvailableSlots {
  String? sId;
  String? day;
  String? slot;

  AvailableSlots({this.sId, this.day, this.slot});

  AvailableSlots.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    day = json['day'];
    slot = json['slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['day'] = this.day;
    data['slot'] = this.slot;
    return data;
  }
}
