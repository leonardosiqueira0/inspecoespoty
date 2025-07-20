class InspectionItemModel {
  String? id;
  String name;
  String inspectionSubtypeID;
  bool isEdited;

  InspectionItemModel({this.id, required this.name, required this.inspectionSubtypeID, this.isEdited = false});

  factory InspectionItemModel.fromJson(Map<String, dynamic> json) {
    return InspectionItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      inspectionSubtypeID: json['inspectionSubtypeID'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['inspectionSubtypeID'] = inspectionSubtypeID;
    return data;
  }

  Map<String, dynamic> toJsonCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['inspectionSubtypeID'] = inspectionSubtypeID;
    return data;
  }
}
