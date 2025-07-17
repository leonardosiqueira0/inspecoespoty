class InspectionTypeModel {
  String? id;
  String name;
  int departmentId;

  InspectionTypeModel({this.id, required this.name, required this.departmentId});

  factory InspectionTypeModel.fromJson(Map<String, dynamic> json) {
    return InspectionTypeModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      departmentId: json['departmentID'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['departmentID'] = departmentId;
    return data;
  }

  Map<String, dynamic> toJsonCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['departmentID'] = departmentId;
    return data;
  }
}
