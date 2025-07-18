import 'package:inspecoespoty/data/models/inspection_item_model.dart';

class InspectionSubtypeModel {
  String? id;
  String name;
  int? quantity = 0;
  String inspectionTypeId;
  List<InspectionItemModel>? inspectionItens;

  InspectionSubtypeModel({this.id, required this.name, this.quantity = 0, required this.inspectionTypeId});

  factory InspectionSubtypeModel.fromJson(Map<String, dynamic> json) {
    return InspectionSubtypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      inspectionTypeId: json['inspectionTypeId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['inspectionTypeId'] = inspectionTypeId;
    return data;
  }

  Map<String, dynamic> toJsonCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['inspectionTypeId'] = inspectionTypeId;
    return data;
  }
}
