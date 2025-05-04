class AvailableSlotsModel {
  String? therapistId;
  String? name;
  List<AvailableSlots>? availableSlots;
  bool? slotAvailability;

  AvailableSlotsModel({
    this.therapistId,
    this.name,
    this.availableSlots,
    this.slotAvailability,
  });

  AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    therapistId = json['therapistId'];
    name = json['name'];
    if (json['availableSlots'] != null) {
      availableSlots = <AvailableSlots>[];
      json['availableSlots'].forEach((v) {
        availableSlots!.add(AvailableSlots.fromJson(v));
      });
    }
    slotAvailability = json['slotAvailability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['therapistId'] = therapistId;
    data['name'] = name;
    if (availableSlots != null) {
      data['availableSlots'] = availableSlots!.map((v) => v.toJson()).toList();
    }
    data['slotAvailability'] = slotAvailability;
    return data;
  }
}

class AvailableSlots {
  String? sId;
  SlotId? slotId;
  bool? status;

  AvailableSlots({this.sId, this.slotId, this.status});

  AvailableSlots.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slotId = json['slotId'] != null ? SlotId.fromJson(json['slotId']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    if (slotId != null) {
      data['slotId'] = slotId!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class SlotId {
  String? sId;
  String? day;
  String? slot;

  SlotId({this.sId, this.day, this.slot});

  SlotId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    day = json['day'];
    slot = json['slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['day'] = day;
    data['slot'] = slot;
    return data;
  }
}
