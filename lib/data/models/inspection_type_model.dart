import 'package:inspecoespoty/data/models/inspection_subtype_model.dart';

class InspectionTypeModel {
  String? id;
  String name;
  int? quantity = 0;
  int departmentId;
  List<InspectionSubtypeModel> subtypes;

  InspectionTypeModel({this.id, required this.name, this.quantity = 0, required this.departmentId, this.subtypes = const <InspectionSubtypeModel>[]});

  factory InspectionTypeModel.fromJson(Map<String, dynamic> json) {
    return InspectionTypeModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      quantity: json['quantity'] as int?,
      departmentId: json['departmentID'],
      subtypes: (json['subtypes'] as List<dynamic>?)
          ?.map((e) => InspectionSubtypeModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? <InspectionSubtypeModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['departmentID'] = departmentId;
    return data;
  }

  Map<String, dynamic> toJsonCreateOrAlter() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['departmentID'] = departmentId;
    data['subtypes'] = subtypes.map((e) => e.toJsonCreateOrUpdate()).toList();
    return data;
  }

  Map<String, dynamic> toJsonCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['departmentID'] = departmentId;
    return data;
  }
}
